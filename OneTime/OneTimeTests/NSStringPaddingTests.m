//
//  NSStringPaddingTests.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/29/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "NSStringPaddingTests.h"
#import "NSString+Padding.h"

@implementation NSStringPaddingTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLeftPad
{
    // pad with empty string, should return input unchanged
    STAssertEqualObjects([@"123" stringByPaddingLeft:@"" length:10], @"123", @"incorrect padding");
    
    // standard left pad
    STAssertEqualObjects([@"123" stringByPaddingLeft:@"0" length:10], @"0000000123", @"incorrect padding");
    
    // target length equal to existing string length, should return input unchanged
    STAssertEqualObjects([@"aaaa" stringByPaddingLeft:@"b" length:4], @"aaaa", @"incorrect padding");
    
    // target length less than existing string length, should return input unchanged
    STAssertEqualObjects([@"aaaa" stringByPaddingLeft:@"b" length:3], @"aaaa", @"incorrect padding");
    
    // padding empty string should result in n pad characters
    STAssertEqualObjects([@"" stringByPaddingLeft:@"a" length:10], @"aaaaaaaaaa", @"incorrect padding");
    
    // multi character pad, should truncate properly
    STAssertEqualObjects([@"aaa" stringByPaddingLeft:@"bcd" length:10], @"bcdbcdbaaa", @"incorrect padding");
    STAssertEqualObjects([@"" stringByPaddingLeft:@"abcd" length:10], @"abcdabcdab", @"incorrect padding");
}

- (void)testRightPad
{
    // pad with empty string, should return input unchanged
    STAssertEqualObjects([@"123" stringByPaddingRight:@"" length:10], @"123", @"incorrect padding");
    
    // standard left pad
    STAssertEqualObjects([@"123" stringByPaddingRight:@"0" length:10], @"1230000000", @"incorrect padding");
    
    // target length equal to existing string length, should return input unchanged
    STAssertEqualObjects([@"aaaa" stringByPaddingRight:@"b" length:4], @"aaaa", @"incorrect padding");
    
    // target length less than existing string length, should return input unchanged
    STAssertEqualObjects([@"aaaa" stringByPaddingRight:@"b" length:3], @"aaaa", @"incorrect padding");
    
    // padding empty string should result in n pad characters
    STAssertEqualObjects([@"" stringByPaddingRight:@"a" length:10], @"aaaaaaaaaa", @"incorrect padding");
    
    // multi character pad, should truncate properly
    STAssertEqualObjects([@"aaa" stringByPaddingRight:@"bcd" length:10], @"aaabcdbcdb", @"incorrect padding");
    STAssertEqualObjects([@"" stringByPaddingRight:@"abcd" length:10], @"abcdabcdab", @"incorrect padding");
}

@end
