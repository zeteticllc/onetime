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

@implementation totpykTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
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

- (void)testYkWriteConfig
{
    //
    ZETYkKey *ykKey = [[ZETYkKey alloc] init];
    [ykKey writeConfig:@"0000000000000000000000000000000000000000" buttonTrigger:false];
    STAssertFalse(ykKey.error, @"error opening key");
    STAssertNil(ykKey.errorMessage, @"errorMessage should be nil");
    [ykKey release];
}

- (void)testYkHMAC
{
    //http://tools.ietf.org/html/rfc2202
    
    
    NSData *keyData = [NSData fromHex:@"0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b"];
    NSString *hexKey = [keyData toHex];
    
    ZETYkKey *ykKey = [[ZETYkKey alloc] init];
    
    [ykKey writeConfig:hexKey buttonTrigger:false];
    
    STAssertFalse(ykKey.error, @"error opening key");
    STAssertNil(ykKey.errorMessage, @"errorMessage should be nil");
        
    
    NSData *response = [ykKey hmacChallenge:[@"Hi There" dataUsingEncoding:NSASCIIStringEncoding] challengeLength:8];
    
    STAssertEqualObjects([response toHex], @"b617318655057264e28bc0b6fb378c8ef146be00", @"response %@ doesn't match %@", [response toHex], @"b617318655057264e28bc0b6fb378c8ef146be00");
    [ykKey release];
}

@end
