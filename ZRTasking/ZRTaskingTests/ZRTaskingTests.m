//
//  ZRTaskingTests.m
//  ZRTaskingTests
//
//  Created by 赵睿 on 8/2/18.
//  Copyright © 2018 赵睿. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CmdUtil.h"

@interface ZRTaskingTests : XCTestCase

@end

@implementation ZRTaskingTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testRunCommandSync {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSData* data = runCommandSync(@"echo md5 | md5", YES, nil);
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    XCTAssert([result isEqualToString:@"772ac1a55fab1122f3b369ee9cd31549\n"]);
}

- (void)testRunCommandAsync {
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous command complete"];
    runCommandAsync(@"/sbin/ping -c 3 taobao.com", YES, ^(NSData * _Nonnull data, int exitStatus) {
        XCTAssert([data length]);
        XCTAssert(exitStatus == 0);
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [expectation fulfill];
    });
    [self waitForExpectations:@[expectation] timeout:5.0];
}

-(void)testRunCommandAsyncMultipleTimes {
    NSMutableArray* mExpectArray = [NSMutableArray new];
    for (int i = 0; i < 50; i++) {
        [mExpectArray addObject:[self expectationWithDescription:@"asynchronous command complete"]];
    }
    for (XCTestExpectation* expectation in mExpectArray) {
        runCommandAsync(@"/sbin/ping -c 3 taobao.com", YES, ^(NSData * _Nonnull data, int exitStatus) {
            XCTAssert([data length]);
            XCTAssert(exitStatus == 0);
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [expectation fulfill];
        });
    }
    [self waitForExpectations:mExpectArray timeout:10.0];
}

-(void)testRunCommandTimeout {
    XCTestExpectation *expectation = [self expectationWithDescription:@"expect timeout for the task"];
    runCommandAsyncTimeout(@"echo begin;sleep 5;echo end", YES, 4, ^(NSData * _Nonnull data, int exitStatus) {
        if (exitStatus == CMD_TIMEOUT_ERR) {
            NSLog(@"command running timeout: %@", data);
            [expectation fulfill];
        } else {
            NSLog(@"command complete: %@", data);
        }
    });
    [self waitForExpectations:@[expectation] timeout:10.0];
}

-(void)testRunCommandTimeoutForMutipleTimes {
    NSMutableArray* mExpectArray = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        [mExpectArray addObject:[self expectationWithDescription:@"expect timeout for the task"]];
    }
    for (XCTestExpectation* expectation in mExpectArray) {
        runCommandAsyncTimeout(@"echo begin;sleep 5;echo end", YES, 1, ^(NSData * _Nonnull data, int exitStatus) {
            if (exitStatus == CMD_TIMEOUT_ERR) {
                NSLog(@"command running timeout: %@", data);
                [expectation fulfill];
            } else {
                NSLog(@"command complete: %@", data);
            }
        });
    }
    [self waitForExpectations:mExpectArray timeout:10.0];
}

-(void)testRunCommandAsyncMaxTimeout {
    XCTestExpectation *expectation = [self expectationWithDescription:@"expect runCommandAsync reach max timeout: 60s"];
    runCommandAsync(@"echo begin;sleep 65;echo end", YES, ^(NSData * _Nonnull data, int exitStatus) {
        if (exitStatus == CMD_TIMEOUT_ERR) {
            NSLog(@"command running timeout: %@", data);
            [expectation fulfill];
        } else {
            NSLog(@"command complete: %@", data);
        }
    });
    [self waitForExpectations:@[expectation] timeout:70];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
