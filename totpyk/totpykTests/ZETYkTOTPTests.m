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

@end
