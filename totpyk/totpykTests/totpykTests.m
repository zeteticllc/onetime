//
//  totpykTests.m
//  totpykTests
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import "totpykTests.h"
#import "ZETYkKey.h"

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
    ZETYkKey *key = [[ZETYkKey alloc] init];
    STAssertFalse(key.error, @"error opening key");
    STAssertNil(key.errorMessage, @"errorMessage should be nil");
    STAssertTrue(2 == key.versionMajor, @"major version number %d is not 2", key.versionMajor);
    STAssertTrue(2 == key.versionMinor, @"minor version number %d is not 2", key.versionMinor);
    [key release];
}

- (void)testYkHmac
{
    ZETYkKey *key = [[ZETYkKey alloc] init];
    
    
    [key release];
}

@end
