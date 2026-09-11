#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterXmppEngine : NSObject

@property (nonatomic, copy, nullable) void (^onMessage)(NSString *body);
@property (nonatomic, copy, nullable) void (^onClosed)(void);
@property (nonatomic, copy, nullable) void (^onAuthenticated)(void);

- (void)startWithId:(NSString *)userId
           password:(NSString *)password
               host:(NSString *)host
               port:(int)port
           resource:(NSString *)resource;
- (void)stop;
- (BOOL)sendTo:(NSString *)to body:(NSString *)body;
- (void)goOnline;
- (void)goOffline;

@end

NS_ASSUME_NONNULL_END
