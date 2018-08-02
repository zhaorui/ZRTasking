//
//  CmdUtil.h
//  Cisco
//
//  Created by 赵睿 on 8/1/18.
//  Copyright © 2018 赵睿. All rights reserved.
//

#ifndef CmdUtil_h
#define CmdUtil_h

#import <Foundation/Foundation.h>
#import "COTTaskHelper.h"

NS_ASSUME_NONNULL_BEGIN


NSData* runCommandSync(NSString* commandToRun, BOOL isErrorOutputEnable, int* _Nullable status);
void runCommandAsnyc(NSString* commandToRun, BOOL isErrorOutputEnable, void(^completionHandler)(NSData* data, int exitStatus));


NS_ASSUME_NONNULL_END


#endif /* CmdUtil_h */
