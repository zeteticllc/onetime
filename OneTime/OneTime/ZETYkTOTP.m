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

#include "totp.h"
#import "ZETYkTOTP.h"

//                            0 1  2   3    4     5      6       7        8
const int digits_power[9] = { 1,10,100,1000,10000,100000,1000000,10000000,100000000 };

@implementation ZETYkTOTP
@synthesize key, digits, step, mayBlock, verbose;

- (void) dealloc {
    [key release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    key = [[ZETYkKey alloc] init];
    digits = 6;
    step = 30;
    mayBlock = 1;
    verbose =0;
    return self;
}

- (NSString *) totpChallenge {
    time_t t = time(NULL);
    unsigned long moving_factor = t / step;
    return [self totpChallengeWithMovingFactor:moving_factor];
}

- (NSString *) totpChallengeWithMovingFactor:(unsigned long)movingfactor {
    unsigned long be_moving_factor = [ZETYkKey toBigEndian:movingfactor];
    return [self totpChallengeWithData:[NSData dataWithBytes:&be_moving_factor length:sizeof(be_moving_factor)]];
}

- (NSString *) totpChallengeWithData:(NSData *)timeData {
    NSString *otpFormat = @"%%0%uu";
	unsigned int offset, raw_otp, otp;

    NSData *responseData;
    unsigned char* response;
    
    responseData = [key hmacChallenge:timeData challengeLength:timeData.length];
    
    if(responseData && !key.error) {
        response = (unsigned char*) [responseData bytes];
        offset = response[responseData.length-1] & 0xf;
        raw_otp =  (
                    (response[offset]&0x7f) << 24 |
                    (response[offset+1]&0xff) << 16 |
                    (response[offset+2]&0xff) << 8 |
                    (response[offset+3]&0xff));
        
        otp = raw_otp % digits_power[digits];
        
        return [NSString stringWithFormat:[NSString stringWithFormat:otpFormat, digits], otp];
    }
    return nil;
}

@end
