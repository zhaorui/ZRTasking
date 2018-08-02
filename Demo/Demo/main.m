//
//  main.m
//  Demo
//
//  Created by 赵睿 on 8/2/18.
//  Copyright © 2018 赵睿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CmdUtil.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int status;
        NSData* result = runCommandSync(@"/usr/bin/curl -fsSL taobao.com", YES, &status);
        NSLog(@"data length: %ld, status: %d", [result length], status);
        
        runCommandAsnyc(@"/usr/bin/curl -fsSL taobao.com", YES, ^(NSData * _Nonnull data, int exitStatus) {
            NSLog(@"data length: %ld, status: %d", [data length], exitStatus);
        });
        
        [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
