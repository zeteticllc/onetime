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
        
	if (!yk_init()) {
        // error checking
	}
    
	if (!(yk = yk_open_first_key())) {
        // error checking
	}
    
	if (! check_firmware(yk, verbose)) {
        // error checking
	}
    
	if (! totp_challenge(yk, (int)slot, (int)digits, (int)step,
                         (int)mayBlock, (int)verbose, &rawResult)) {
        // error checking
	}
    
    _result = rawResult;
    
	if (yk && !yk_close_key(yk)) {
		// error checking
	}
    
	if (!yk_release()) {
        // error checking
	}
    
    return [NSString stringWithFormat:[NSString stringWithFormat:otpFormat, digits], rawResult];
}

@end
