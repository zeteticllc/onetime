//
//  NSDataBase32Tests.m
//  OneTime
//
//  Created by Stephen Lombardo on 1/29/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "NSDataBase32Tests.h"
#import "NSData+Base32.h"
#import "NSData+Hex.h"

@implementation NSDataBase32Tests

- (void)setUp
{
    [super setUp];
    
    // http://tools.ietf.org/html/rfc4648
    tests = [[NSArray arrayWithObjects:
             [NSArray arrayWithObjects:@"", @"", nil],
             [NSArray arrayWithObjects:@"f", @"MY======", nil],
             [NSArray arrayWithObjects:@"fo", @"MZXQ====", nil],
             [NSArray arrayWithObjects:@"foo", @"MZXW6===", nil],
             [NSArray arrayWithObjects:@"foob", @"MZXW6YQ=", nil],
             [NSArray arrayWithObjects:@"fooba", @"MZXW6YTB", nil],   
             [NSArray arrayWithObjects:@"foobar", @"MZXW6YTBOI======", nil], 
             nil] retain];
}

- (void)tearDown
{
    [tests release];
    [super tearDown];
}

- (void)testToBase32
{   
    for(NSArray *item in tests) {
        STAssertEqualObjects(
                             [[[item objectAtIndex:0] dataUsingEncoding:NSASCIIStringEncoding] base32String],
                             [item objectAtIndex:1], @"base32 doesn't match");
    }
}

- (void)testFromBase32
{
    for(NSArray *item in tests) {
        NSString* str = [[NSString alloc] 
                         initWithData:[NSData dataWithBase32String:[item objectAtIndex:1]] 
                         encoding:NSASCIIStringEncoding];
        STAssertEqualObjects(str, [item objectAtIndex:0], @"hex doesn't match");
        [str release];
    }
}

- (void)testFromBase32Google
{
    STAssertEqualObjects(
                         [[[NSData dataWithBase32String:[@"nxu7v4sqp6njsgj5" uppercaseString]] dataToHex] uppercaseString], 
                         @"6DE9FAF2507F9A99193D",
                         @"hex doesn't match");
    
    STAssertEqualObjects(
                         [[[NSData dataWithBase32String:[@"4blsxd2mdcowx6iz" uppercaseString]] dataToHex] uppercaseString], 
                         @"E0572B8F4C189D6BF919",
                         @"hex doesn't match");
}


@end
