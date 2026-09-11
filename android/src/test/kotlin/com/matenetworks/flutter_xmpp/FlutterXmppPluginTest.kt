package com.matenetworks.flutter_xmpp

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

internal class FlutterXmppPluginTest {
    @Test
    fun onMethodCall_unknown_isNotImplemented() {
        val plugin = FlutterXmppPlugin()
        val call = MethodCall("getPlatformVersion", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)
        Mockito.verify(mockResult).notImplemented()
    }
}
