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
    runCommandAsnyc(@"/sbin/ping -c 3 taobao.com", YES, ^(NSData * _Nonnull data, int exitStatus) {
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
        runCommandAsnyc(@"/sbin/ping -c 3 taobao.com", YES, ^(NSData * _Nonnull data, int exitStatus) {
            XCTAssert([data length]);
            XCTAssert(exitStatus == 0);
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [expectation fulfill];
        });
    }
    [self waitForExpectations:mExpectArray timeout:10.0];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
