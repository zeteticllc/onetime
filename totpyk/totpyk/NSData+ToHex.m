//
//  NSData+ToHex.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/28/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "NSData+ToHex.h"

@implementation NSData (ToHex)

- (NSString*) toHex {
    NSMutableString *hex = [NSMutableString stringWithCapacity:([self length] * 2)];
    
    for (int i = 0; i < [self length]; i++) {
        [hex appendFormat:@"%02x", (unsigned long)((unsigned char*)[self bytes])[ i ]];
    }
    return [[hex copy] autorelease];
}

@end

