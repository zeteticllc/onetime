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
