//
//  NSDataHexTests.m
//  OneTime
//
//  Created by Stephen Lombardo on 1/29/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "NSDataHexTests.h"
#import "NSData+Hex.h"

@implementation NSDataHexTests

- (void)testToHex
{   
    STAssertEqualObjects(
                         [[@"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~`!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?\0" dataUsingEncoding:NSASCIIStringEncoding] dataToHex],
                         @"313233343536373839306162636465666768696a6b6c6d6e6f707172737475767778797a4142434445464748494a4b4c4d4e4f505152535455565758595a7e6021402324255e262a28292d5f3d2b5b7b5d7d5c7c3b3a27222c3c2e3e2f3f00", @"hex doesn't match");

    
    
}

- (void)testFromHex
{
    NSData *data = [NSData dataFromHex:@"313233343536373839306162636465666768696a6b6c6d6e6f707172737475767778797a4142434445464748494a4b4c4d4e4f505152535455565758595a7e6021402324255e262a28292d5f3d2b5b7b5d7d5c7c3b3a27222c3c2e3e2f3f00"];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    STAssertEqualObjects(str,
                         @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~`!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?\0", @"hex doesn't match");

    [str release];
}

@end
