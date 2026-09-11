import Flutter
import Foundation

#if canImport(flutter_xmpp_core)
import flutter_xmpp_core
#endif

public class FlutterXmppPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_xmpp", binaryMessenger: registrar.messenger())
        let instance = FlutterXmppPlugin()
        instance.channel = channel
        instance.bindEngine()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private var channel: FlutterMethodChannel?
    private let engine = FlutterXmppEngine()

    private func bindEngine() {
        engine.onMessage = { [weak self] body in
            self?.notify("onMessage", arguments: ["body": body])
        }
        engine.onClosed = { [weak self] in
            self?.notify("onClosed", arguments: nil)
        }
        engine.onAuthenticated = { [weak self] in
            self?.notify("onAuthenticated", arguments: nil)
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "start":
            let args = call.arguments as? [String: Any] ?? [:]
            engine.start(
                withId: args["id"] as? String ?? "",
                password: args["password"] as? String ?? "",
                host: args["host"] as? String ?? "",
                port: Int32(args["port"] as? Int ?? 5222),
                resource: args["resource"] as? String ?? "xmppframework"
            )
            result(nil)
        case "stop":
            engine.stop()
            result(nil)
        case "send":
            let args = call.arguments as? [String: Any] ?? [:]
            result(engine.send(
                to: args["to"] as? String ?? "",
                body: args["body"] as? String ?? ""
            ))
        case "goOnline":
            engine.goOnline()
            result(nil)
        case "goOffline":
            engine.goOffline()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func notify(_ method: String, arguments: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod(method, arguments: arguments)
        }
    }
}
