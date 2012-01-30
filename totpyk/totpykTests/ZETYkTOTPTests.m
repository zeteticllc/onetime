//
//  ZETYkTOTPTests.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/29/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "ZETYkTOTPTests.h"
#import "ZETYkTOTP.h"
#import "NSData+Hex.h"
#import "NSData+Base32.h"
#import "NSString+Padding.h"

@implementation ZETYkTOTPTests

- (void)testRfc6238
{   
    NSString *hexKey = [[@"12345678901234567890" dataUsingEncoding:NSASCIIStringEncoding] dataToHex];
    
    
    NSArray *tests = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:@"0000000000000001", @"94287082", nil],
                      [NSArray arrayWithObjects:@"00000000023523EC", @"07081804", nil],
                      [NSArray arrayWithObjects:@"00000000023523ED", @"14050471", nil],
                      [NSArray arrayWithObjects:@"000000000273EF07", @"89005924", nil],
                      [NSArray arrayWithObjects:@"0000000003F940AA", @"69279037", nil],
                      [NSArray arrayWithObjects:@"0000000027BC86AA", @"65353130", nil],   
                      nil];
    
    ZETYkTOTP *totp = [[ZETYkTOTP alloc] init];
    totp.digits = 8;
    
    STAssertFalse(totp.key.error, @"error opening key: %@", totp.key.errorMessage);
    
    [totp.key writeHmacCRConfig:hexKey buttonTrigger:false];
    STAssertFalse(totp.key.error, @"error writing config: %@", totp.key.errorMessage);
    
    for(NSArray *item in tests) {
        STAssertEqualObjects([totp totpChallengeWithData:[NSData dataFromHex:[item objectAtIndex:0]]], [item objectAtIndex:1], @"mismatch");
        STAssertFalse(totp.key.error, @"error with TOTP challenge: %@", totp.key.errorMessage);
    }
                              
    [totp release];
}

- (void)testGoogle
{   
    // from test site http://google-authenticator.googlecode.com/hg/libpam/totp.html
    
    // convert base32 to data, then to hex, then right pad to 40 characters
    
    NSString *hexKey = [[[NSData dataWithBase32String:
                           [@"4blsxd2mdcowx6iz" uppercaseString]] dataToHex] stringByPaddingRight:@"0" length:40];
    
    unsigned long movingfactors[4] = {
        44263222, 44263223, 44263226, 44263239};
    
    NSArray *tests = [NSArray arrayWithObjects:
        @"415850", @"119013", @"013202", @"375264", nil];
    
    ZETYkTOTP *totp = [[ZETYkTOTP alloc] init];
    STAssertFalse(totp.key.error, @"error opening key: %@", totp.key.errorMessage);
    
    totp.digits = 6;
    
    [totp.key writeHmacCRConfig:hexKey buttonTrigger:false];
    STAssertFalse(totp.key.error, @"error writing config: %@", totp.key.errorMessage);
    
    int i = 0;
    for(NSString *item in tests) {
        STAssertEqualObjects([totp totpChallengeWithMovingFactor:movingfactors[i]], item, @"mismatch");
        STAssertFalse(totp.key.error, @"error with TOTP challenge: %@", totp.key.errorMessage);
        i++;
    }
    
    [totp release];
}



@end
