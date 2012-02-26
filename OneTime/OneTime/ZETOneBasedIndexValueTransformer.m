//
//  ZETOneBasedIndexValueTransformer.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/31/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "ZETOneBasedIndexValueTransformer.h"

@implementation ZETOneBasedIndexValueTransformer

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value
{
    NSInteger index = [value integerValue];
    return [NSNumber numberWithInteger:index - 1];
}

- (id)reverseTransformedValue:(id)value
{
    NSInteger index = [value integerValue];
    return [NSNumber numberWithInteger:index + 1];
}

@end
