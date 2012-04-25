/*
 
 OneTime
 Developed by Zetetic LLC
 support@zetetic.net
 http://zetetic.net/
 
 Copyright (c) 2012, Zetetic LLC. All rights reserved.
 
 This file is part of OneTime.
 
 OneTime is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 OneTime is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Foobar.  If not, see <http://www.gnu.org/licenses/>
*/

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
