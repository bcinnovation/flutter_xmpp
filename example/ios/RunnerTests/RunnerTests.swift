import Flutter
import UIKit
import XCTest

@testable import flutter_xmpp

class RunnerTests: XCTestCase {
  func testUnknownMethodIsNotImplemented() {
    let plugin = FlutterXmppPlugin()
    let call = FlutterMethodCall(methodName: "getPlatformVersion", arguments: [])
    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertTrue(result is FlutterMethodNotImplemented)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }
}
