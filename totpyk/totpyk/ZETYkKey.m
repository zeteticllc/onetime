//
//  ZETYkKey.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/28/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "ZETYkKey.h"

@implementation ZETYkKey

@synthesize slot, error, errorMessage, versionMajor, versionMinor, versionBuild;

- (void) dealloc {
    free(st);
    if (yk) { // close and release handle to yubikey
        yk_close_key(yk);
        yk_release();
    }
}

- (id) init {
    self = [super init];
    if(self) {
        slot = 2;
        st = ykds_alloc();
        error = NO;
        versionMajor = versionMinor = versionBuild = 0;
        
        if (yk_init() && (yk = yk_open_first_key())) {
            if (!yk_get_status(yk, st)) {
                error = YES;
                errorMessage = @"Unable to get status from Yubikey";
            } else {
                versionMajor = ykds_version_major(st);
                versionMinor = ykds_version_minor(st);
                versionBuild = ykds_version_build(st); 
                if (versionMajor < 2 || (versionMajor == 2 && versionMinor < 2)) {
                    error = YES;
                    errorMessage = [NSString stringWithFormat:@"Incorrect firmware version: HMAC challenge-response not supported with YubiKey %d.%d.%d", 
                                    versionMajor, versionMinor, versionBuild];
                }
            }
        } else {
            error = YES;
            errorMessage = @"Unable to get status from Yubikey";
        }
    }
    return self;
}

- (NSData *) hmacChallenge:(NSData *)challenge challengeLength:(NSInteger)length {
    int yk_cmd = (slot == 1) ? SLOT_CHAL_HMAC1 : SLOT_CHAL_HMAC2;
    unsigned char response[64];
	unsigned int response_len = 0;
	unsigned int expect_bytes = 20;
	
	if (!yk_write_to_key(yk, yk_cmd, [challenge bytes], (int)length)) {
        error = YES;
        errorMessage = @"Error writing HMAC challenge to Yubikey";
    }
    
    
	if (!yk_read_response_from_key(
            yk, slot, YK_FLAG_MAYBLOCK, // use selected slot and allow the yubikey to block for button press
            &response, sizeof(response), expect_bytes, &response_len)) {
        error = YES;
        errorMessage = @"Error reading HMAC response from Yubikey";
    } else {
        /* HMAC responses are 160 bits */
        if (response_len > expect_bytes) response_len = expect_bytes;
    }
    
    return [NSData dataWithBytes:response length:response_len];
}



+(unsigned long) toBigEndian:(unsigned long)value
{
    value = (value>>56) | 
    ((value<<40) & 0x00FF000000000000) |
    ((value<<24) & 0x0000FF0000000000) |
    ((value<<8)  & 0x000000FF00000000) |
    ((value>>8)  & 0x00000000FF000000) |
    ((value>>24) & 0x0000000000FF0000) |
    ((value>>40) & 0x000000000000FF00) |
    (value<<56);
    return value;
}

@end
