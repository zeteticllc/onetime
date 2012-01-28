//
//  NSData+ToHex.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/28/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "NSData+Hex.h"

#define _T(a) L ## a

static inline int hex2byte(char c) {
	return (c>=_T('0') && c<=_T('9')) ? (c)-_T('0') :
    (c>=_T('A') && c<=_T('F')) ? (c)-_T('A')+10 :
    (c>=_T('a') && c<=_T('f')) ? (c)-_T('a')+10 : 0;
}

@implementation NSData (ToHex)

- (NSString*) toHex {
    NSMutableString *hex = [NSMutableString stringWithCapacity:([self length] * 2)];
    
    for (int i = 0; i < [self length]; i++) {
        [hex appendFormat:@"%02x", (unsigned long)((unsigned char*)[self bytes])[ i ]];
    }
    return [[hex copy] autorelease];
}

+ (NSData *)fromHex:(NSString *)hexString {
    NSData *hexData = [[hexString lowercaseString] dataUsingEncoding:NSASCIIStringEncoding];
    unsigned char *hex = (unsigned char*) [hexData bytes];
    
    NSUInteger len = hexData.length / 2;
    
    NSMutableData *binData = [NSMutableData dataWithLength:len];
    unsigned char *bin = [binData mutableBytes];
    
    for(int i = 0; i < len; i++) {
		char hbyte = *hex++;
		char lbyte = *hex++;
        
		*bin++ = (unsigned char) (hex2byte(hbyte)<<4 | hex2byte(lbyte));
	}
    
    for(int i = 0; i<len; i++) {
        char hbyte = *hex++;
        char lbyte = *hex++;
        *bin++ = (unsigned char) (hex2byte(hbyte)<<4 | hex2byte(lbyte));
    }
    
    return [NSData dataWithData:binData];
}

@end

