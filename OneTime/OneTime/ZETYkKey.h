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

#import <Cocoa/Cocoa.h>
#include <yubikey.h>
#include <ykpers.h>
#include <ykdef.h>

@interface ZETYkKey : NSObject {
    NSInteger slot;
    YK_KEY *yk;
    YK_STATUS *st;
    NSInteger versionMajor;
    NSInteger versionMinor;
    NSInteger versionBuild;
    BOOL error;
    NSString *errorMessage;
}

@property (nonatomic) NSInteger slot;
@property (nonatomic) NSInteger versionMajor;
@property (nonatomic) NSInteger versionMinor;
@property (nonatomic) NSInteger versionBuild;
@property (nonatomic) BOOL error;
@property (nonatomic,retain) NSString *errorMessage;


-(NSData *)hmacChallenge:(NSData *)challenge challengeLength:(NSInteger)length;
-(BOOL)writeHmacCRConfigWithBase32Key:(NSString *)key buttonTrigger:(BOOL)buttonTrigger;
-(BOOL)writeHmacCRConfigWithHexKey:(NSString *)key buttonTrigger:(BOOL)buttonTrigger;
-(void)setErrorState:(NSString *)message;

+(unsigned long) toBigEndian:(unsigned long)value;
+(NSString *)normalizeBase32Key:(NSString *)value;
+(NSString *)normalizeKey:(NSString *)value;
+(BOOL)isHexKeyValid:(NSString *)value;
+(BOOL)isBase32KeyValid:(NSString *)value;

@end
