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

#import "NSData+Hex.h"

#define _T(a) L ## a

static inline int hex2byte(char c) {
	return (c>=_T('0') && c<=_T('9')) ? (c)-_T('0') :
    (c>=_T('A') && c<=_T('F')) ? (c)-_T('A')+10 :
    (c>=_T('a') && c<=_T('f')) ? (c)-_T('a')+10 : 0;
}

@implementation NSData (Hex)

- (NSString*) dataToHex {
    NSMutableString *hex = [NSMutableString stringWithCapacity:([self length] * 2)];
    
    for (int i = 0; i < [self length]; i++) {
        [hex appendFormat:@"%02x", (unsigned long)((unsigned char*)[self bytes])[ i ]];
    }
    return [[hex copy] autorelease];
}

+ (NSData *)dataFromHex:(NSString *)hexString {
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
    
    return [[binData copy] autorelease];
}

@end

