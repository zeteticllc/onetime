//
//  NSData+Base32.h
//  OneTime
//
//  Extracted from the Amber Framework
//  http://code.google.com/p/amber-framework
//
//  Copyright (c) 2008-2010, Keith Duncan
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base32)

+ (id)dataWithBase32String:(NSString *)base32String;
- (NSString *)base32String;

@end
