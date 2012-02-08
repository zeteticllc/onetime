//
//  ZETYkKey.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/28/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "ZETYkKey.h"
#import "NSData+Hex.h"
#import "NSData+Base32.h"
#import "NSString+Padding.h"

@implementation ZETYkKey

@synthesize slot, error, errorMessage, versionMajor, versionMinor, versionBuild;

- (void) dealloc {
    free(st);
    if (yk) { // close and release handle to yubikey
        yk_close_key(yk);
        yk_release();
    }
    [errorMessage release];
}

-(void)setErrorState:(NSString *)message {
    error = TRUE;
    errorMessage = [message retain];
}

- (id) init {
    yk_errno = 0;
    self = [super init];
    if(self) {
        slot = 2;
        st = ykds_alloc();
        error = NO;
        versionMajor = versionMinor = versionBuild = 0;
        
        if (yk_init() && (yk = yk_open_first_key())) {
            if (!yk_get_status(yk, st)) {
                [self setErrorState:[NSString stringWithFormat:@"Unable to get status from Yubikey: error %d (%s)", yk_errno, yk_strerror(yk_errno)]];
            } else {
                versionMajor = ykds_version_major(st);
                versionMinor = ykds_version_minor(st);
                versionBuild = ykds_version_build(st); 
                if (versionMajor < 2 || (versionMajor == 2 && versionMinor < 2)) {
                    [self setErrorState:[NSString stringWithFormat:@"Incorrect firmware version: HMAC challenge-response not supported with YubiKey %d.%d.%d", 
                                    versionMajor, versionMinor, versionBuild]];
                }
            }
        } else {
            [self setErrorState:[NSString stringWithFormat:@"Unable to open Yubikey: code %d (%s)", yk_errno, yk_strerror(yk_errno)]];
        }
    }
    return self;
}

- (NSData *) hmacChallenge:(NSData *)challenge challengeLength:(NSInteger)length {
    int yk_cmd = (slot == 1) ? SLOT_CHAL_HMAC1 : SLOT_CHAL_HMAC2;
    unsigned char response[64];
	unsigned int response_len = 0;
	unsigned int expect_bytes = 20;
	
    if(!yk || error) return nil;
       
	if (!yk_write_to_key(yk, yk_cmd, [challenge bytes], (int)length)) {
        [self setErrorState:@"Error writing HMAC challenge to Yubikey"];
    }
    
	if (!yk_read_response_from_key(
            yk, slot, YK_FLAG_MAYBLOCK, // use selected slot and allow the yubikey to block for button press
            &response, sizeof(response), expect_bytes, &response_len)) {
        [self setErrorState:[NSString stringWithFormat:@"Error reading HMAC response from Yubikey: code %d (%s)", yk_errno, yk_strerror(yk_errno)]];
    } else {
        /* HMAC responses are 160 bits */
        if (response_len > expect_bytes) response_len = expect_bytes;
    }
    
    return [NSData dataWithBytes:response length:response_len];
}

+ (NSString *)normalizeKey:(NSString *)value {
    return [[value stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
}

+ (BOOL)isHexKeyValid:(NSString *)value {
    if(value == nil) return NO;
        
    value = [self normalizeKey:value];
    
    NSCharacterSet *hexSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"];
    NSCharacterSet *valueSet = [NSCharacterSet characterSetWithCharactersInString:value];
    
    if(value.length % 2 == 0 && value.length <= 40 && [hexSet isSupersetOfSet:valueSet]) return YES;
    
    return NO;
}

+ (BOOL)isBase32KeyValid:(NSString *)value {
    if(value == nil) return NO;
    
    value = [self normalizeKey:value];
    
    NSCharacterSet *base32Set = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"];
    NSCharacterSet *valueSet = [NSCharacterSet characterSetWithCharactersInString:value];
    
    if(value.length % 8 == 0 && value.length <= 32 && [base32Set isSupersetOfSet:valueSet]) return YES;
    
    return NO;
}


-(BOOL)writeHmacCRConfigWithBase32Key:(NSString *)key buttonTrigger:(BOOL)buttonTrigger {
    key = [ZETYkKey normalizeKey:key];
    
    if(key == nil || ![ZETYkKey isBase32KeyValid:key]) {
        [self setErrorState:@"invalid Base32 key"];
    }
    
    return [self writeHmacCRConfigWithHexKey:[[NSData dataWithBase32String:key] dataToHex] buttonTrigger:buttonTrigger];
}
    
-(BOOL)writeHmacCRConfigWithHexKey:(NSString *)key buttonTrigger:(BOOL)buttonTrigger {
    key = [ZETYkKey normalizeKey:key];
    
    if(key == nil || ![ZETYkKey isHexKeyValid:key]) {
        [self setErrorState:@"invalid Hex Key"];
    }
    
    key = [key stringByPaddingRight:@"0" length:40];
    
    ykp_errno = yk_errno = 0;
    YKP_CONFIG *cfg = ykp_create_config();
    
    if(!yk || error) return false;
    
    if (!yk_get_status(yk, st)) {
        [self setErrorState:@"unable to get status from Yubikey before configuration write"];
    }
    
    struct config_st *ycfg = (struct config_st *) ykp_core_config(cfg);
    ycfg->tktFlags = ycfg->cfgFlags = ycfg->extFlags =  0; // clear flags
    
    ykp_configure_for(cfg, (int)slot, st);
    
    ykp_set_tktflag_CHAL_RESP(cfg, 1);
    ykp_set_cfgflag_CHAL_HMAC(cfg, 1);
    ykp_set_cfgflag_HMAC_LT64(cfg, 1);
    
    if (buttonTrigger) {
        ykp_set_cfgflag_CHAL_BTN_TRIG(cfg, 1);
    }
    
    if(ykp_HMAC_key_from_hex(cfg, [[key lowercaseString] UTF8String])) { // yubikey wants it lowercased
        [self setErrorState:@"invalid key data provided"];
    } else  {
        if (!yk_write_config(yk, ykp_core_config(cfg), ykp_config_num(cfg), NULL)) {
            [self setErrorState:[NSString stringWithFormat:@"failed to write from Yubikey before configuration write: error %d (%s)", ykp_errno, ykp_strerror(ykp_errno)]];
        }
    }
    
    free(cfg);
    return !error;
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
