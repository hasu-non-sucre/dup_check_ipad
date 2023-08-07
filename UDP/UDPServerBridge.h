//
//  UDPServerBridge.h
//  UDP
//
//  Created by User on 2023/07/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UDPServerBridge : NSObject

typedef void (^MessageHandler)(NSString *);

- (void)startUDPServerWithHandler:(MessageHandler)handler;

@end

NS_ASSUME_NONNULL_END
