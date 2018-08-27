//
//  main.m
//  Demo
//
//  Created by 赵睿 on 8/2/18.
//  Copyright © 2018 赵睿. All rights reserved.
//

#import <Foundation/Foundation.h>
@import ZRTasking;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        int status;
//        NSData* result = runCommandSync(@"/usr/bin/curl -fsSL taobao.com", YES, &status);
//        NSLog(@"data length: %ld, status: %d", [result length], status);
//
//        NSData* data = runCommandSync(@"echo md5 | md5", YES, nil);
//        NSLog(@"md5 is %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//
//        runCommandAsync(@"/usr/bin/curl -fsSL taobao.com", YES, ^(NSData * _Nonnull data, int exitStatus) {
//            NSLog(@"data length: %ld, status: %d", [data length], exitStatus);
//        });
        
        
        for (int i = 0; i < 10; i++) {
            runCommandAsyncTimeout(@"echo begin;sleep 10;echo end", YES, 2, ^(NSData * _Nonnull data, int exitStatus) {
                if (exitStatus == CMD_TIMEOUT_ERR) {
                    NSLog(@"command running timeout: %@", data);
                } else {
                    NSLog(@"command complete: %@", data);
                }
            });
        }
        
        [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
