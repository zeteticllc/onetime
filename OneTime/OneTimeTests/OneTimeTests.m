/*
 
 OneTime
 Developed by Zetetic LLC
 support@zetetic.net
 http://zetetic.net/
 
 Copyright (c) 2012, Zetetic LLC. All rights reserved.
 
 This file is part of OneTime.
 
 OneTime is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 OneTime is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Foobar.  If not, see <http://www.gnu.org/licenses/>
*/

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
