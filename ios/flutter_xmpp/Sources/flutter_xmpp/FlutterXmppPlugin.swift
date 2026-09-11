import Flutter
import Foundation
import XMPPFramework

public class FlutterXmppPlugin: NSObject, FlutterPlugin, XMPPStreamDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_xmpp", binaryMessenger: registrar.messenger())
        let instance = FlutterXmppPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private var channel: FlutterMethodChannel?
    private var stream: XMPPStream?
    private var autoPing: XMPPAutoPing?
    private var password: String = ""

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "start":
            let args = call.arguments as? [String: Any] ?? [:]
            start(
                id: args["id"] as? String ?? "",
                password: args["password"] as? String ?? "",
                host: args["host"] as? String ?? "",
                port: args["port"] as? Int ?? 5222,
                resource: args["resource"] as? String ?? "xmppframework"
            )
            result(nil)
        case "stop":
            stop()
            result(nil)
        case "send":
            let args = call.arguments as? [String: Any] ?? [:]
            result(send(
                to: args["to"] as? String ?? "",
                body: args["body"] as? String ?? ""
            ))
        case "goOnline":
            goOnline()
            result(nil)
        case "goOffline":
            goOffline()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func start(id: String, password: String, host: String, port: Int, resource: String) {
        if let stream = stream, stream.isConnected() {
            return
        }
        stop()
        self.password = password

        let stream = XMPPStream()
        stream.hostName = host
        stream.hostPort = UInt16(port)
        stream.myJID = XMPPJID(user: id, domain: host, resource: resource)
        stream.addDelegate(self, delegateQueue: DispatchQueue.main)

        let ping = XMPPAutoPing(dispatchQueue: DispatchQueue.main)
        ping.pingInterval = 60.0
        ping.activate(stream)

        self.stream = stream
        self.autoPing = ping

        do {
            try stream.connect(withTimeout: 15.0)
        } catch {
            notify("onClosed", arguments: nil)
        }
    }

    private func stop() {
        if let stream = stream {
            stream.removeDelegate(self)
            goOffline()
            autoPing?.deactivate()
            stream.disconnect()
        }
        stream = nil
        autoPing = nil
    }

    private func send(to: String, body: String) -> Bool {
        guard let stream = stream, stream.isConnected() else {
            return false
        }
        let jid = XMPPJID(string: to)
        let message = XMPPMessage(type: "chat", to: jid)
        message?.addBody(body)
        if let message = message {
            stream.send(message)
            return true
        }
        return false
    }

    private func goOnline() {
        guard let stream = stream else {
            return
        }
        stream.send(XMPPPresence())
    }

    private func goOffline() {
        guard let stream = stream else {
            return
        }
        stream.send(XMPPPresence(type: "unavailable"))
    }

    private func notify(_ method: String, arguments: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod(method, arguments: arguments)
        }
    }

    public func xmppStreamDidConnect(_ sender: XMPPStream!) {
        do {
            try sender.authenticate(withPassword: password)
        } catch {
        }
    }

    public func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        goOnline()
        notify("onAuthenticated", arguments: nil)
    }

    public func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error?) {
        notify("onClosed", arguments: nil)
    }

    public func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        if message.type() != "chat" {
            return
        }
        guard let body = message.body(), !body.isEmpty else {
            return
        }
        notify("onMessage", arguments: ["body": body])
    }
}
