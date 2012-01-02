//
//  ZETTOTP.h
//  totpyk
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZETYkTOTP : NSObject {
    NSInteger slot;
    NSInteger digits;
    NSInteger step;
    NSInteger mayBlock;
    NSInteger verbose;
    
@private
    NSUInteger _result;
}

@property (nonatomic) NSInteger slot;
@property (nonatomic) NSInteger digits;
@property (nonatomic) NSInteger step;
@property (nonatomic) NSInteger mayBlock;
@property (nonatomic) NSInteger verbose;
@property (nonatomic,readonly) NSUInteger result;

- (NSString*) totpChallenge;

@end
