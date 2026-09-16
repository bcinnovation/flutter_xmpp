package com.matenetworks.flutter_xmpp

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.jivesoftware.smack.ConnectionConfiguration
import org.jivesoftware.smack.ConnectionListener
import org.jivesoftware.smack.ReconnectionManager
import org.jivesoftware.smack.SmackException
import org.jivesoftware.smack.StanzaListener
import org.jivesoftware.smack.XMPPConnection
import org.jivesoftware.smack.filter.AndFilter
import org.jivesoftware.smack.filter.StanzaTypeFilter
import org.jivesoftware.smack.packet.Message
import org.jivesoftware.smack.packet.Presence
import org.jivesoftware.smack.tcp.XMPPTCPConnection
import org.jivesoftware.smack.tcp.XMPPTCPConnectionConfiguration
import org.jivesoftware.smackx.ping.PingManager

class FlutterXmppPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel
    private val mainHandler = Handler(Looper.getMainLooper())
    private var connection: XMPPTCPConnection? = null
    private var userId: String? = null
    private var password: String? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "start" -> {
                start(
                    call.argument<String>("id").orEmpty(),
                    call.argument<String>("password").orEmpty(),
                    call.argument<String>("host").orEmpty(),
                    call.argument<Int>("port") ?: 5222,
                    call.argument<String>("resource").orEmpty(),
                )
                result.success(null)
            }
            "stop" -> {
                stop()
                result.success(null)
            }
            "send" -> {
                result.success(
                    send(
                        call.argument<String>("to").orEmpty(),
                        call.argument<String>("body").orEmpty(),
                    ),
                )
            }
            "goOnline" -> {
                goOnline()
                result.success(null)
            }
            "goOffline" -> {
                goOffline()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        stop()
    }

    private fun start(id: String, pwd: String, host: String, port: Int, resource: String) {
        userId = id
        password = pwd
        val current = connection
        if (current != null) {
            if (current.isConnected) {
                if (current.isAuthenticated) {
                    notify("onAuthenticated", null)
                }
                return
            }
            connectAndLogin(current)
            return
        }
        val config = XMPPTCPConnectionConfiguration.builder()
            .setServiceName(host)
            .setHost(host)
            .setPort(port)
            .setSecurityMode(ConnectionConfiguration.SecurityMode.disabled)
            .setConnectTimeout(60 * 1000)
            .setSendPresence(true)
            .setResource(resource)
            .build()
        val conn = XMPPTCPConnection(config)
        conn.packetReplyTimeout = 60000
        conn.addConnectionListener(object : ConnectionListener {
            override fun connected(xmppConnection: XMPPConnection) {
                PingManager.getInstanceFor(xmppConnection).pingInterval = 3 * 60
                ReconnectionManager.getInstanceFor(conn).enableAutomaticReconnection()
            }

            override fun authenticated(connection: XMPPConnection, resumed: Boolean) {
                notify("onAuthenticated", null)
            }

            override fun connectionClosed() {
                notify("onClosed", null)
            }

            override fun connectionClosedOnError(e: Exception) {
                notify("onClosed", null)
            }

            override fun reconnectingIn(seconds: Int) {}

            override fun reconnectionSuccessful() {
                if (conn.isAuthenticated) {
                    return
                }
                try {
                    conn.login(userId, password)
                } catch (e: Exception) {
                    Log.e(TAG, "relogin failed", e)
                }
            }

            override fun reconnectionFailed(e: Exception) {
                notify("onClosed", null)
            }
        })
        conn.addAsyncStanzaListener(
            StanzaListener { packet ->
                val message = packet as? Message ?: return@StanzaListener
                val body = message.body ?: return@StanzaListener
                notify("onMessage", mapOf("body" to body))
            },
            AndFilter(StanzaTypeFilter(Message::class.java)),
        )
        connection = conn
        connectAndLogin(conn)
    }

    // connect() logs in on its own once the connection has authenticated before, so
    // logging in from the ConnectionListener would be a second login and throw.
    private fun connectAndLogin(conn: XMPPTCPConnection) {
        Thread {
            try {
                if (!conn.isConnected) {
                    conn.connect()
                }
                if (!conn.isAuthenticated) {
                    conn.login(userId, password)
                }
            } catch (e: SmackException.AlreadyLoggedInException) {
                notify("onAuthenticated", null)
            } catch (e: SmackException.AlreadyConnectedException) {
                if (conn.isAuthenticated) {
                    notify("onAuthenticated", null)
                }
            } catch (e: Exception) {
                Log.e(TAG, "connect failed", e)
                notify("onClosed", null)
            }
        }.start()
    }

    private fun stop() {
        val conn = connection
        connection = null
        if (conn != null) {
            try {
                conn.disconnect()
            } catch (e: Exception) {
                Log.e(TAG, "disconnect ignored", e)
            }
        }
    }

    private fun send(toJid: String, body: String): Boolean {
        val conn = connection
        if (conn == null || !conn.isConnected) {
            return false
        }
        val msg = Message()
        msg.type = Message.Type.chat
        msg.to = toJid
        msg.body = body
        return try {
            conn.sendStanza(msg)
            true
        } catch (e: Exception) {
            Log.e(TAG, "send failed", e)
            false
        }
    }

    private fun goOnline() {
        val conn = connection
        if (conn == null || !conn.isConnected) {
            return
        }
        try {
            conn.sendStanza(Presence(Presence.Type.available))
        } catch (e: Exception) {
            Log.e(TAG, "goOnline ignored", e)
        }
    }

    private fun goOffline() {
        val conn = connection
        if (conn == null || !conn.isConnected) {
            return
        }
        try {
            conn.sendStanza(Presence(Presence.Type.unavailable))
        } catch (e: Exception) {
            Log.e(TAG, "goOffline ignored", e)
        }
    }

    private fun notify(method: String, args: Any?) {
        if (!::channel.isInitialized) {
            return
        }
        mainHandler.post {
            channel.invokeMethod(method, args)
        }
    }

    companion object {
        const val CHANNEL = "flutter_xmpp"
        private const val TAG = "FlutterXmpp"
    }
}
