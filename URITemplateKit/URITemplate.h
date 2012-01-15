//
//  URITemplate.h
//  URITemplateKit
//
//  Created by Bennett Smith on 1/13/12.
//  Copyright (c) 2012 iDevelopSoftware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URITemplate : NSObject {
    
}

@property (nonatomic, retain) NSString* pattern;

+ (id)templateWithPattern:(NSString *)uriTemplatePattern;

- (id)initWithPattern:(NSString *)uriTemplatePattern;
- (NSString *)expandUsingVariables:(NSDictionary *)variables;
@end
