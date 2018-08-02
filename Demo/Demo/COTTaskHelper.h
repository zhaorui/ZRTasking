//
//  TaskHelper.h
//
//  Created by Tyler Hall on 12/8/14.
//  Copyright (c) 2014 Click On Tyler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COTTaskHelper : NSObject

@property (nonatomic, strong) NSTask *task;
@property (assign) BOOL isErrorOutputEnable;
@property (nonatomic, copy) void (^outputHandler)(NSData *outputData);
@property (nonatomic, copy) void (^taskFinish)(void); // Call immediately when a task finish
@property (nonatomic, copy) void (^taskComplete)(NSData* response, int status); // task finish and response data is all received

- (void)launch;

@end
