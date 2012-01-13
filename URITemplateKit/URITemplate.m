//
//  URITemplate.m
//  URITemplateKit
//
//  Created by Bennett Smith on 1/13/12.
//  Copyright (c) 2012 iDevelopSoftware, Inc. All rights reserved.
//

#import "URITemplate.h"

@implementation URITemplate

@synthesize pattern;

+ (id)templateWithPattern:(NSString *)uriTemplatePattern
{
    return [[URITemplate alloc] initWithPattern:(NSString *)uriTemplatePattern];
}

- (id)initWithPattern:(NSString *)uriTemplatePattern
{
    self = [super init];
    if (self) {
        pattern = uriTemplatePattern;
    }
    return self;
}

- (NSString *)expandUsingVariables:(NSDictionary *)variables
{
    return @"";
}

@end
