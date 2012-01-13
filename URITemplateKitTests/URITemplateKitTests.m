//
//  URITemplateKitTests.m
//  URITemplateKitTests
//
//  Created by Bennett Smith on 1/13/12.
//  Copyright (c) 2012 iDevelopSoftware, Inc. All rights reserved.
//

#import "URITemplateKitTests.h"

#import "NSObject+URITemplateKit.h"

@implementation URITemplateKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testStringFromClass
{
    STAssertEqualObjects([[[NSObject alloc] init] stringFromClass], @"NSObject", nil);
    
    STAssertEqualObjects([@"" stringFromClass], @"__NSCFConstantString", nil);
    
    STAssertEqualObjects([NSObject stringFromClass], @"NSObject", nil);
}

@end
