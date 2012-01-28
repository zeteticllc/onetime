//
//  ZETYkKey.h
//  totpyk
//
//  Created by Stephen Lombardo on 1/28/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

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
-(BOOL)writeConfig:(NSString *)key buttonTrigger:(BOOL)buttonTrigger;

+(unsigned long) toBigEndian:(unsigned long)value;

@end
