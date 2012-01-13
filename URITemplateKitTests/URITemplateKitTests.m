//
//  URITemplateKitTests.m
//  URITemplateKitTests
//
//  Created by Bennett Smith on 1/13/12.
//  Copyright (c) 2012 iDevelopSoftware, Inc. All rights reserved.
//

#import "URITemplateKitTests.h"

#import "URITemplateKit.h"

@implementation URITemplateKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    stdVars = [[NSMutableDictionary alloc] initWithCapacity:12];
    [stdVars setValue:@"value" forKey:@"var"];
    [stdVars setValue:@"Hello World!" forKey:@"hello"];
    [stdVars setValue:[NSNull null] forKey:@"undef"];
    [stdVars setValue:@"" forKey:@"empty"];
    [stdVars setValue:[NSArray arrayWithObjects:@"val1", @"val2", @"val3", nil] forKey:@"list"];
    [stdVars setValue:[NSDictionary dictionaryWithObjectsAndKeys:@"val1", @"key1", @"val2", @"key2", nil] forKey:@"keys"];
    [stdVars setValue:@"/foo/bar" forKey:@"path"];
    [stdVars setValue:[NSNumber numberWithInt:1024] forKey:@"x"];
    [stdVars setValue:[NSNumber numberWithInt:768] forKey:@"y"];
    [stdVars setValue:@"fred" forKey:@"foo"];
    [stdVars setValue:@"That's right!" forKey:@"foo2"];
    [stdVars setValue:@"http://example.com/home/" forKey:@"base"];
}

- (void)tearDown
{
    // Tear-down code here.
    [stdVars removeAllObjects];
    stdVars = nil;
    
    [super tearDown];
}

- (void)testStdVars
{
    STAssertEquals([stdVars count], (NSUInteger)12, @"Incorrect number of items in stdVars dictionary", nil);
}

- (void)doTemplateTestsWith:(NSDictionary *)templates
{
    [templates enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        
        NSString *templatePattern = (NSString *)key;
        NSString *expectedOutput = (NSString *)object;
        NSLog(@"%@ = %@", templatePattern, expectedOutput);
        
        URITemplate *template = [URITemplate templateWithPattern:key];
        
        NSString *actualOutput = [template expandUsingVariables:stdVars];
        
        NSLog(@"  expectedOutput = '%@'", expectedOutput);
        NSLog(@"  actualOutput = '%@'", actualOutput);
        
        STAssertEquals(actualOutput, expectedOutput, @"Template expansion failed.", nil);
    }];
}

- (void)testSimpleExpansionWithCommaSeparatedValues
{
    NSMutableDictionary *templates = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"value", @"{var}",
                                      @"Hello%20World%21", @"{hello}",
                                      @"%2Ffoo%2Fbar/here", @"{path}/here",
                                      @"1024,768", @"{x,y}",
                                      @"value", @"{var=default}",
                                      @"default", @"{undef=default}",
                                      @"val1,val2,val3", @"{list}",
                                      @"val1,val2,val3", @"{list*}",
                                      @"list.val1,list.val2,list.val3", @"{list+}",
                                      @"key1,val1,key2,val2", @"{keys}",
                                      @"key1,val1,key2,val2", @"{keys*}",
                                      @"keys.key1,val1,keys.key2,val2", @"{keys+}", 
                                      nil];
    [self doTemplateTestsWith:templates];
}

- (void)testReservedExpansionWithCommaSeparatedValues
{
    NSMutableDictionary *templates = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"value", @"{+var}",
                                      @"Hello%20World!", @"{+hello}",
                                      @"/foo/bar/here", @"{+path}/here",
                                      @"/foo/bar,1024/here", @"{+path,x}/here",
                                      @"/foo/bar1024/here", @"{+path}{x}/here",
                                      @"/here", @"{+empty}/here",
                                      @"/here", @"{+undef}/here",
                                      @"val1,val2,val3", @"{+list}",
                                      @"val1,val2,val3", @"{+list*}",
                                      @"list.val1,list.val2,list.val3", @"{+list+}",
                                      @"key1,val1,key2,val2", @"{+keys}",
                                      @"key1,val1,key2,val2", @"{+keys*}",
                                      @"keys.key1,val1,keys.key2,val2", @"{+keys+}",
                                      nil];
    [self doTemplateTestsWith:templates];
}

- (void)testPathStyleParametersSemicolonPrefixed
{
    NSMutableDictionary *templates = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @";x=1024;y=768", @"{;x,y}",
                                      @";x=1024;y=768;empty", @"{;x,y,empty}",
                                      @";x=1024;y=768", @"{;x,y,undef}",
                                      @";val1,val2,val3", @"{;list}",
                                      @";val1;val2;val3", @"{;list*}",
                                      @";list=val1;list=val2;list=val3", @"{;list+}",
                                      @";key1,val1,key2,val2", @"{;keys}",
                                      @";key1=val1;key2=val2", @"{;keys*}",
                                      @";keys.key1=val1;keys.key2=val2", @"{;keys+}",
                                      nil];
    [self doTemplateTestsWith:templates];
}

- (void)testFormStyleParametersAmpersandSeparated
{
    NSMutableDictionary *templates = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"?x=1024&y=768", @"{?x,y}",
                                      @"?x=1024&y=768&empty=", @"{?x,y,empty}",
                                      @"?x=1024&y=768", @"{?x,y,undef}",
                                      @"?list=val1,val2,val3", @"{?list}",
                                      @"?val1&val2&val3", @"{?list*}",
                                      @"?list=val1&list=val2&list=val3", @"{?list+}",
                                      @"?keys=key1,val1,key2,val2", @"{?keys}",
                                      @"?key1=val1&key2=val2", @"{?keys*}",
                                      @"?keys.key1=val1&keys.key2=val2", @"{?keys+}",
                                      nil];
    [self doTemplateTestsWith:templates];
}

- (void)testHierarchicalPathSegmentsSlashSeparated
{
    NSMutableDictionary *templates = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"/value", @"{/var}",
                                      @"/value/", @"{/var,empty}",
                                      @"/value", @"{/var,undef}",
                                      @"/val1,val2,val3", @"{/list}",
                                      @"/val1/val2/val3", @"{/list*}",
                                      @"/val1/val2/val3/1024", @"{/list*,x}",
                                      @"/list.val1/list.val2/list.val3", @"{/list+}",
                                      @"/key1,val1,key2,val2", @"{/keys}",
                                      @"/key1/val1/key2/val2", @"{/keys*}",
                                      @"/keys.key1/val1/keys.key2/val2", @"{/keys+}",
                                      nil];
    [self doTemplateTestsWith:templates];
}

- (void)testLabelExpansionDotPrefixed
{
    NSMutableDictionary *templates = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"X.value", @"X{.var}",
                                      @"X.", @"X{.empty}",
                                      @"X", @"X{.undef}",
                                      @"X.val1,val2,val3", @"X{.list}",
                                      @"X.val1.val2.val3", @"X{.list*}",
                                      @"X.val1.val2.val3.1024", @"X{.list*,x}",
                                      @"X.list.val1.list.val2.list.val3", @"X{.list+}",
                                      @"X.key1,val1,key2,val2", @"X{.keys}",
                                      @"X.key1.val1.key2.val2", @"X{.keys*}",
                                      @"X.keys.key1.val1.keys.key2.val2", @"X{.keys+}",
                                      nil];
    [self doTemplateTestsWith:templates];
}

- (void)testSimpleExpansion
{
    NSMutableDictionary *templates = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"fred", @"{foo}",
                                      @"fred,fred", @"{foo,foo}",
                                      @"fred", @"{bar,foo}",
                                      @"wilma", @"{bar=wilma}",
                                      nil];
    [self doTemplateTestsWith:templates];
}

- (void)testReservedExpansion
{
    NSMutableDictionary *templates = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"That%27s%20right%21", @"{foo2}",
                                      @"That's%20right!", @"{+foo2}",
                                      @"http%3A%2F%2Fexample.com%2Fhome%2Findex", @"{base}index",
                                      @"http://example.com/home/index", @"{+base}index",
                                      nil];
    [self doTemplateTestsWith:templates];
}
@end
