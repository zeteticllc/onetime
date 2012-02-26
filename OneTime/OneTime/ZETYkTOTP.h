//
//  ZETTOTP.h
//  OneTimeTests
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZETYkKey.h"

@interface ZETYkTOTP : NSObject {
    ZETYkKey *key;
    NSInteger digits;
    NSInteger step;
    NSInteger mayBlock;
    NSInteger verbose;
}

@property (nonatomic,retain) ZETYkKey *key;
@property (nonatomic) NSInteger digits;
@property (nonatomic) NSInteger step;
@property (nonatomic) NSInteger mayBlock;
@property (nonatomic) NSInteger verbose;

- (NSString*) totpChallenge;
- (NSString *) totpChallengeWithData:(NSData *)timeData;
- (NSString *) totpChallengeWithMovingFactor:(unsigned long)movingfactor;

@end
