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


