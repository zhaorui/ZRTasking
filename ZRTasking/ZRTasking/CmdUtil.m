//
//  CmdUtil.m
//  Cisco
//
//  Created by 赵睿 on 8/1/18.
//  Copyright © 2018 赵睿. All rights reserved.
//

#import "CmdUtil.h"

NSTask *buildTask(NSString *commandToRun)
{
    NSTask *task = [NSTask new];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments: @[@"-c", commandToRun]];
    return task;
}

NSData* runCommandSync(NSString* commandToRun, BOOL isErrorOutputEnable, int* status){
    NSTask *task = buildTask(commandToRun);
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task setStandardOutput: pipe];
    if (isErrorOutputEnable) {
        [task setStandardError:pipe];
    }
    
    @try {
        [task launch];
        NSData *data = [file readDataToEndOfFile];
        //如果不关闭会导致pipe句柄泄漏
        [file closeFile];
        if (status) {
            *status = task.terminationStatus;
        }
        return data;
    } @catch (NSException *exception) {
        if (status) {
            *status = task.terminationStatus;
        }
    }
    return nil;
}

/// @name Run command asynchronously

void runCommandAsyncTimeout(NSString* commandToRun, BOOL isErrorOutputEnable, NSTimeInterval timeout, void(^completionHandler)(NSData* data, int exitStatus)) {
    dispatch_queue_t wq = dispatch_queue_create("com.zhaorui.on.other.thread", DISPATCH_QUEUE_SERIAL);
    NSDate* future = [NSDate dateWithTimeIntervalSinceNow:timeout + 5]; //run loop shall wait for the timeout event
    dispatch_async(wq, ^{
        NSTask *task = buildTask(commandToRun);
        COTTaskHelper* helper = [COTTaskHelper new];
        [helper setIsErrorOutputEnable:YES];
        [helper setTask:task];
        [helper setTaskComplete:completionHandler];
        [helper setTaskFinish:^{}];
        [helper launch];
        
        [NSRunLoop currentRunLoop];
        [NSTimer scheduledTimerWithTimeInterval:timeout
                                         target:helper
                                       selector:@selector(timesup:)
                                       userInfo:nil
                                        repeats:NO];
        [[NSRunLoop currentRunLoop] runUntilDate:future];
        NSLog(@"runloop finish!");
    });
}

void runCommandAsync(NSString* commandToRun, BOOL isErrorOutputEnable, void(^completionHandler)(NSData* data, int exitStatus)) {
    runCommandAsyncTimeout(commandToRun, isErrorOutputEnable, 60, completionHandler);
}
