//
//  TaskHelper.m
//
//  Created by Tyler Hall on 12/8/14.
//  Copyright (c) 2014 Click On Tyler. All rights reserved.
//

#import "COTTaskHelper.h"


@interface COTTaskHelper ()
@end

@implementation COTTaskHelper

- (void)launch
{
    //NSAssert([NSThread isMainThread], @"TaskHelper launch must be called from the main thread.");

    NSPipe *outputPipe = [NSPipe pipe];
    self.responseData = [NSMutableData new];
    [self.task setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
    [self.task setStandardOutput:outputPipe];
    if (self.isErrorOutputEnable) {
        [self.task setStandardError:outputPipe];
    }

    NSFileHandle *fhOut = [outputPipe fileHandleForReading];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedData:)
                                                 name:NSFileHandleDataAvailableNotification
                                               object:fhOut];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(complete:)
                                                 name:NSTaskDidTerminateNotification
                                               object:self.task];

    [fhOut waitForDataInBackgroundAndNotify];

    [self.task launch];
}

-(void)timesup:(NSTimer *)timer {
    if (self.task.running) {
        if (self.taskComplete) {
            self.taskComplete(self.responseData, CMD_TIMEOUT_ERR);
        }
        [self.task terminate];
    }
    [timer invalidate];
    timer = nil;
}

- (void)receivedData:(NSNotification *)notification
{
    NSFileHandle *fh = [notification object];
    NSData *outputData = [fh availableData];

    if(self.outputHandler) {
        self.outputHandler(outputData);
    }

    //Fix COTTaskHelper Bug, which task is teminated, but its output is not read.
    if(self.task.isRunning || [outputData length]) {
        [self.responseData appendData:outputData];
        [fh waitForDataInBackgroundAndNotify];
    } else {
        if (self.taskComplete) {
            self.taskComplete(self.responseData, self.task.terminationStatus);
        }
    }
}

- (void)complete:(NSNotification *)notification
{
    if(self.taskFinish) {
        NSLog(@"command[%@] finish", self.task.arguments[1]);
        self.taskFinish();
    }
}

@end
