//
//  totpykTests.m
//  totpykTests
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import "totpykTests.h"
#import "ZETYkKey.h"
#import "NSData+Hex.h"
#import "NSString+Padding.h"

@implementation totpykTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testYkKeyOpen
{
    ZETYkKey *ykKey = [[ZETYkKey alloc] init];
    STAssertFalse(ykKey.error, @"error opening key");
    STAssertNil(ykKey.errorMessage, @"errorMessage should be nil");
    STAssertTrue(2 == ykKey.versionMajor, @"major version number %d is not 2", ykKey.versionMajor);
    STAssertTrue(2 == ykKey.versionMinor, @"minor version number %d is not 2", ykKey.versionMinor);
    [ykKey release];
}

- (void)testYkWriteHmacCRConfig
{
    //
    ZETYkKey *ykKey = [[ZETYkKey alloc] init];
    [ykKey writeHmacCRConfig:@"0000000000000000000000000000000000000000" buttonTrigger:false];
    STAssertFalse(ykKey.error, @"error opening key");
    STAssertNil(ykKey.errorMessage, @"errorMessage should be nil");
    [ykKey release];
}

- (void)testYkHMACSha1TestVector1
{
    /* 
     HMAC-SHA1 Test case 1 from http://tools.ietf.org/html/rfc2202
     test_case =     1
     key =           0x0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b
     key_len =       20
     data =          "Hi There"
     data_len =      8
     digest =        0xb617318655057264e28bc0b6fb378c8ef146be00
    */
    
    NSString *hexKey = @"0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b";
    NSString *challenge = @"Hi There";
    NSString *expected = @"b617318655057264e28bc0b6fb378c8ef146be00";
    
    ZETYkKey *ykKey = [[ZETYkKey alloc] init];
    
    [ykKey writeHmacCRConfig:hexKey buttonTrigger:false];
    
    STAssertFalse(ykKey.error, @"error opening key: %@", ykKey.errorMessage);
        
    NSData *response = [ykKey hmacChallenge:[challenge dataUsingEncoding:NSASCIIStringEncoding] challengeLength:challenge.length];
    
    STAssertFalse(ykKey.error, @"error executing hmacChallenge: %@", ykKey.errorMessage);
    STAssertNotNil(response, @"response should not be nil");
    
    STAssertEqualObjects([response dataToHex], expected, @"response %@ doesn't match %@", [response dataToHex], expected);
    [ykKey release];
}

- (void)testYkHMACSha1TestVector2
{
    /* 
     http://tools.ietf.org/html/rfc2202
     HMAC-SHA1 Test case 2 - short key, short message 
     test_case =     2
     key =           "Jefe"
     key_len =       4
     data =          "what do ya want for nothing?"
     data_len =      28
     digest =        0xeffcdf6ae5eb2fa2d27416d5f184df9c259a7c79
     */
    
    NSString *hexKey = [[[@"Jefe" dataUsingEncoding:NSASCIIStringEncoding] dataToHex] 
                        stringByPaddingRight:@"0"length:40];
    NSString *challenge = @"what do ya want for nothing?";
    NSString *expected = @"effcdf6ae5eb2fa2d27416d5f184df9c259a7c79";
    
    ZETYkKey *ykKey = [[ZETYkKey alloc] init];
    
    [ykKey writeHmacCRConfig:hexKey buttonTrigger:false];
    
    STAssertFalse(ykKey.error, @"error opening key: %@", ykKey.errorMessage);
    
    NSData *response = [ykKey hmacChallenge:[challenge dataUsingEncoding:NSASCIIStringEncoding] 
                            challengeLength:challenge.length];
    
    STAssertFalse(ykKey.error, @"error executing hmacChallenge: %@", ykKey.errorMessage);
    STAssertNotNil(response, @"response should not be nil");
    
    STAssertEqualObjects([response dataToHex], expected, @"response %@ doesn't match %@", [response dataToHex], expected);
    [ykKey release];
}

- (void)testYkHMACSha1TestVector5
{
    /* 
     http://tools.ietf.org/html/rfc2202
     HMAC-SHA1 Test case 5 - 20 byte key and message
     test_case =     5
     key =           0x0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c
     key_len =       20
     data =          "Test With Truncation"
     data_len =      20
     digest =        0x4c1a03424b55e07fe7f27be1d58bb9324a9a5a04
     */
    
    NSString *hexKey = @"0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c";
    NSString *challenge = @"Test With Truncation";
    NSString *expected = @"4c1a03424b55e07fe7f27be1d58bb9324a9a5a04";
    
    ZETYkKey *ykKey = [[ZETYkKey alloc] init];
    
    [ykKey writeHmacCRConfig:hexKey buttonTrigger:false];
    
    STAssertFalse(ykKey.error, @"error opening key: %@", ykKey.errorMessage);
    
    NSData *response = [ykKey hmacChallenge:[challenge dataUsingEncoding:NSASCIIStringEncoding] 
                            challengeLength:challenge.length];
    
    STAssertFalse(ykKey.error, @"error executing hmacChallenge: %@", ykKey.errorMessage);
    STAssertNotNil(response, @"response should not be nil");
    
    STAssertEqualObjects([response dataToHex], expected, @"response %@ doesn't match %@", [response dataToHex], expected);
    [ykKey release];
}


@end
