//
//  NSString+Padding.h
//  OneTime
//
//  Created by Stephen Lombardo on 1/29/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Padding)
- (NSString*) stringByPaddingLeft:(NSString *)pad length:(NSInteger)length;
- (NSString*) stringByPaddingRight:(NSString *)pad length:(NSInteger)length;
@end