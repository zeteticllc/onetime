//
//  OneTimeTests.m
//  OneTimeTests
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneTimeTests.h"

@implementation OneTimeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


- (void)testNSCharacterSet
{
    NSCharacterSet *set1 = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"];
    NSCharacterSet *set2 = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"];
    NSCharacterSet *set3 = [NSCharacterSet characterSetWithCharactersInString:@"012345"];
    NSCharacterSet *set4 = [NSCharacterSet characterSetWithCharactersInString:@"012345XYZ"];
    
    STAssertTrue([set1 isSupersetOfSet:set2], @"set1 should be superset of the same set values");
    STAssertTrue([set2 isSupersetOfSet:set3], @"set2 should be superset of a reduced set");
    STAssertFalse([set3 isSupersetOfSet:set4], @"set3 should NOT be superset of a set with other characters");
    STAssertTrue([set4 isSupersetOfSet:set3], @"set4 should be superset of a reduced set");
}

@end
