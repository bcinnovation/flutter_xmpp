#import "FlutterXmppEngine.h"

#import "XMPP.h"
#import "XMPPAutoPing.h"
#import "XMPPReconnect.h"

@interface FlutterXmppEngine () <XMPPStreamDelegate>
@property (nonatomic, strong, nullable) XMPPStream *stream;
@property (nonatomic, strong, nullable) XMPPAutoPing *autoPing;
@property (nonatomic, strong, nullable) XMPPReconnect *reconnect;
@property (nonatomic, copy) NSString *password;
@end

@implementation FlutterXmppEngine

- (void)startWithId:(NSString *)userId
           password:(NSString *)password
               host:(NSString *)host
               port:(int)port
           resource:(NSString *)resource {
    self.password = password ?: @"";
    if (self.stream != nil) {
        if (self.stream.isConnected) {
            return;
        }
        NSError *error = nil;
        if (![self.stream connectWithTimeout:15.0 error:&error]) {
            if (self.onClosed != nil) {
                self.onClosed();
            }
        }
        return;
    }

    XMPPStream *stream = [[XMPPStream alloc] init];
    stream.hostName = host;
    stream.hostPort = (UInt16)port;
    stream.myJID = [XMPPJID jidWithUser:userId domain:host resource:resource];
    [stream addDelegate:self delegateQueue:dispatch_get_main_queue()];

    XMPPAutoPing *ping = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    ping.pingInterval = 60.0;
    [ping activate:stream];

    XMPPReconnect *reconnect = [[XMPPReconnect alloc] init];
    [reconnect activate:stream];

    self.stream = stream;
    self.autoPing = ping;
    self.reconnect = reconnect;

    NSError *error = nil;
    if (![stream connectWithTimeout:15.0 error:&error]) {
        if (self.onClosed != nil) {
            self.onClosed();
        }
    }
}

- (void)stop {
    if (self.stream != nil) {
        [self.stream removeDelegate:self];
        [self goOffline];
        [self.autoPing deactivate];
        [self.reconnect deactivate];
        [self.stream disconnect];
    }
    self.stream = nil;
    self.autoPing = nil;
    self.reconnect = nil;
}

- (BOOL)sendTo:(NSString *)to body:(NSString *)body {
    if (self.stream == nil || !self.stream.isConnected) {
        return NO;
    }
    XMPPJID *jid = [XMPPJID jidWithString:to];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid];
    [message addBody:body];
    [self.stream sendElement:message];
    return YES;
}

- (void)goOnline {
    if (self.stream == nil) {
        return;
    }
    [self.stream sendElement:[XMPPPresence presence]];
}

- (void)goOffline {
    if (self.stream == nil) {
        return;
    }
    [self.stream sendElement:[XMPPPresence presenceWithType:@"unavailable"]];
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSError *error = nil;
    [sender authenticateWithPassword:self.password error:&error];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    [self goOnline];
    if (self.onAuthenticated != nil) {
        self.onAuthenticated();
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    if (self.onClosed != nil) {
        self.onClosed();
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    if (![message isChatMessageWithBody]) {
        return;
    }
    NSString *body = [message body];
    if (body.length == 0 || self.onMessage == nil) {
        return;
    }
    self.onMessage(body);
}

@end
