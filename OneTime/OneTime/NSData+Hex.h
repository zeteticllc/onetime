//
//  NSData+ToHex.h
//  OneTime
//
//  Created by Stephen Lombardo on 1/28/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSData (Hex)
    - (NSString*) dataToHex;
    + (NSData*) dataFromHex:(NSString*)hex;
@end