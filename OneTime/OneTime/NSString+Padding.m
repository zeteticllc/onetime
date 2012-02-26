//
//  NSString+Padding.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/29/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "NSString+Padding.h"

@implementation NSString (Padding)

- (NSString*) stringByPaddingRight:(NSString *)pad length:(NSInteger)length {
    if(self.length >= length || pad.length < 1) return self;
    
    NSInteger remain = length - self.length;
    
    NSMutableString *padded = [NSMutableString stringWithCapacity:length];
    
    [padded appendString:self];
    
    NSInteger pads = (remain % pad.length == 0) ? remain / pad.length : (remain / pad.length) + 1;
    
    for(int i=0; i < pads; i++) {
        [padded appendString:pad];
    }
    
    return [[[padded substringToIndex:length] copy] autorelease];
}


- (NSString*) stringByPaddingLeft:(NSString *)pad length:(NSInteger)length {
    if(self.length >= length || pad.length < 1) return self;
    
    NSInteger remain = length - self.length;
    
    NSMutableString *padded = [NSMutableString stringWithCapacity:length];
    
     NSInteger pads = (remain % pad.length == 0) ? remain / pad.length : (remain / pad.length) + 1;
    
    for(int i=0; i<pads; i++) {
        [padded appendString:pad];
    }
    
    [padded insertString:self atIndex:remain];
    
    return [[[padded substringToIndex:length] copy] autorelease];
}



@end


