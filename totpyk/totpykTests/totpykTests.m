//
//  totpykTests.m
//  totpykTests
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import "totpykTests.h"
#import "ZETYkKey.h"
#import "NSData+ToHex.h"

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
    
    NSData *keyData = [NSData dataWithBytes:"12345678901234567890" length:20];
    NSString *hexKey = [keyData toHexString];
    
    ZETYkKey *ykKey = [[ZETYkKey alloc] init];
    
    [ykKey writeConfig:hexKey buttonTrigger:false];
    
    STAssertFalse(ykKey.error, @"error opening key");
    STAssertNil(ykKey.errorMessage, @"errorMessage should be nil");
    
    unsigned long long challengeLong = 1;
    
    NSData *challenge = [NSData dataWithBytes:&challengeLong length:sizeof(challengeLong)];
    
    NSData *response = [ykKey hmacChallenge:challenge challengeLength:challege.lenth];
    
    STAssertEquals(<#a1#>, <#a2#>, <#description#>, <#...#>)
    [key release];
}

@end
