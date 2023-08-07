//
//  UDPServerBridge.m
//  UDP
//
//  Created by User on 2023/07/23.
//

#import "UDPServerBridge.h"
#import <arpa/inet.h>
#import <netinet/in.h>
#import <sys/socket.h>

@implementation UDPServerBridge

- (void)startUDPServerWithHandler:(MessageHandler)handler {
    uint16_t localPort = 8888;
    
    int fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (fd < 0) {
        NSLog(@"Failed to careate UDP socket.");
        return;
    }
    
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(localPort);
    addr.sin_addr.s_addr = INADDR_ANY;
    
    if (bind(fd, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
        NSLog(@"Failed to bind UDP socket.");
        close(fd);
        return;
    }
    
    char buffer[1024];
    while (1) {
        ssize_t bytesRead = recv(fd, buffer, sizeof(buffer), 0);
        if (bytesRead > 0) {
            NSString *message = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
            if (handler) {
                handler(message);
            }
        }
    }
}

@end
