//
//  ZETTOTP.m
//  totpyk
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#include "totp.h"
#import "ZETYkTOTP.h"

//                            0 1  2   3    4     5      6       7        8
const int digits_power[9] = { 1,10,100,1000,10000,100000,1000000,10000000,100000000 };

@implementation ZETYkTOTP
@synthesize key, digits, step, mayBlock, verbose;

- (void)dealloc {
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
    unsigned long be_moving_factor = [ZETYkKey toBigEndian:moving_factor];
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
