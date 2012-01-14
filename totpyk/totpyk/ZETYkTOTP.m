//
//  ZETTOTP.m
//  totpyk
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#include "totp.h"
#import "ZETYkTOTP.h"

@implementation ZETYkTOTP
@synthesize slot, digits, step, mayBlock, verbose;
@synthesize result = _result;

- (id)init {
    self = [super init];
    slot = 2;
    digits = 6;
    step = 30;
    mayBlock = 1;
    verbose =0;
    return self;
}

- (NSString*) totpChallenge{
    YK_KEY *yk = 0;
    NSString *otpFormat = @"%%0%uu";
	unsigned int rawResult;
	ykp_errno = 0;
	yk_errno = 0;
        
	if (yk_init() && (yk = yk_open_first_key())) {
        if (check_firmware(yk, verbose)) {
            if (totp_challenge(yk, (int)slot, (int)digits, (int)step,
                                 (int)mayBlock, (int)verbose, &rawResult)) {
                _result = rawResult;
            } else {
               return @"totp failed"; 
            }
            
        } else {
            return @"incorrect firmware version";
        }
	} else {
        return @"unable to open key";
    }
    
	if (yk && !yk_close_key(yk)) {
        return @"close failed";
	}
    
    if(!yk_release()) {
        return @"release failed";
    }

    return [NSString stringWithFormat:[NSString stringWithFormat:otpFormat, digits], rawResult];
}

@end
