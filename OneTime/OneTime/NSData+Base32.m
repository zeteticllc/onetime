//
//  NSData+Base32.m
//  OneTime
//
//  Extracted from the Amber Framework
//  http://code.google.com/p/amber-framework
//
//  Copyright (c) 2008-2010, Keith Duncan
//  All rights reserved.
//

#import "NSData+Base32.h"

@implementation NSData (Base32)


static const char _base32Alphabet[32] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
static const char _base32Padding[1] = "=";

+ (id)dataWithBase32String:(NSString *)base32String {
	if (([base32String length] % 8) != 0) return nil;
	
	NSString *base32Alphabet = [[[NSString alloc] initWithBytes:_base32Alphabet length:32 encoding:NSASCIIStringEncoding] autorelease];
	
	NSMutableCharacterSet *base32CharacterSet = [[[NSMutableCharacterSet alloc] init] autorelease];
	[base32CharacterSet addCharactersInString:base32Alphabet];
	[base32CharacterSet addCharactersInString:[[[NSString alloc] initWithBytes:_base32Padding length:1 encoding:NSASCIIStringEncoding] autorelease]];
	if ([[base32String stringByTrimmingCharactersInSet:base32CharacterSet] length] != 0) return nil;
	
	NSUInteger paddingCharacters = 0; // 6, 4, 3, 1, 0 are allowed
	NSRange paddingRange = NSMakeRange(NSNotFound, 0);
	do {
		paddingRange = [base32String rangeOfString:@"=" options:(NSAnchoredSearch | NSBackwardsSearch) range:NSMakeRange(0, ([base32String length] - paddingCharacters))];
		if (paddingRange.location != NSNotFound) paddingCharacters++;
	} while (paddingRange.location != NSNotFound);
	if (paddingCharacters > 6 || (paddingCharacters == 5 || paddingCharacters == 2)) return nil;
	if ([base32String rangeOfString:@"=" options:(NSStringCompareOptions)0 range:NSMakeRange(0, ([base32String length] - paddingCharacters))].location != NSNotFound) return nil;
	
	
	NSMutableData *data = [NSMutableData dataWithCapacity:(([base32String length] / 8) * 5)];
	CFRetain(base32String);
	
	NSUInteger characterOffset = 0;
	while (characterOffset < [base32String length]) {
		uint8_t values[8] = {0};
		for (NSUInteger valueIndex = 0; valueIndex < 8; valueIndex++) {
			unichar currentCharacter = [base32String characterAtIndex:(characterOffset + valueIndex)];
			if (currentCharacter == _base32Padding[0]) {
				// Note: each value is a 5 bit quantity, UINT8_MAX is outside that range
				values[valueIndex] = UINT8_MAX;
				continue;
			}
			
			values[valueIndex] = (uint8_t)[base32Alphabet rangeOfString:[NSString stringWithFormat:@"%C", currentCharacter]].location;
		}
		
		// Note: there will always be at least two non-padding characters
		
		NSUInteger byteCount = 0;
		uint8_t bytes[5] = {0};
		
		do {
			// Note: first byte
			{
				bytes[0] = bytes[0] | ((values[0] & /* 0b11111 */ 31) << 3);
				bytes[0] = bytes[0] | ((values[1] & /* 0b11100 */ 28) >> 2);
			}
			byteCount++;
			
			// Note: second byte
			if (values[2] == UINT8_MAX) break;
			{
				bytes[1] = bytes[1] | ((values[1] & /* 0b00011 */ 3)  << 6);
				bytes[1] = bytes[1] | ((values[2] & /* 0b11111 */ 31) << 1);
				bytes[1] = bytes[1] | ((values[3] & /* 0b10000 */ 16) >> 4);
			}
			byteCount++;
			
			// Note: third byte
			if (values[4] == UINT8_MAX) break;
			{
				bytes[2] = bytes[2] | ((values[3] & /* 0b01111 */ 15) << 4);
				bytes[2] = bytes[2] | ((values[4] & /* 0b11110 */ 30) >> 1);
			}
			byteCount++;
			
			// Note: fourth byte
			if (values[5] == UINT8_MAX) break;
			{
				bytes[3] = bytes[3] | ((values[4] & /* 0b00001 */ 1)  << 7);
				bytes[3] = bytes[3] | ((values[5] & /* 0b11111 */ 31) << 2);
				bytes[3] = bytes[3] | ((values[6] & /* 0b11000 */ 24) >> 3);
			}
			byteCount++;
			
			// Note: fifth byte
			if (values[7] == UINT8_MAX) break;
			{
				bytes[4] = bytes[4] | ((values[6] & /* 0b00111 */ 7)  << 5);
				bytes[4] = bytes[4] | ((values[7] & /* 0b11111 */ 31) << 0);
			}
			byteCount++;
		} while (NO);
		
		[data appendBytes:bytes length:byteCount];
		characterOffset += 8;
	}
	
	CFRelease(base32String);
	
	return data;
}

- (NSString *)base32String {
	NSMutableString *string = [NSMutableString stringWithCapacity:(([self length] / 5) * 8)];
	
	CFRetain(self);
	
	const uint8_t *currentByte = [self bytes];
	NSUInteger byteOffset = 0;
	
	while (byteOffset < [self length]) {
		// Note: every 40 bits evaluates to 8 characters
		char characters[8] = "========";
		
		do {
			// Note: the first five bits depend on the first byte
			{
				uint8_t bits = ((*currentByte & /* 0b11111000 */ 248) >> 3);
				characters[0] = _base32Alphabet[bits];
			}
			
			// Note: the second five bits depend on the first byte
			{
				uint8_t bits = ((*currentByte & /* 0b00000111 */ 7) << 2); 
				bits = bits | (((byteOffset + 1) > [self length]) ? 0 : ((*(currentByte + 1) & /* 0b11000000 */ 192) >> 6));
				characters[1] = _base32Alphabet[bits];
			}
			
			// Note: the third five bits depend on the second byte
			if ((byteOffset + 2) > [self length]) break;
			{
				uint8_t bits = ((*(currentByte + 1) & /* 0b00111110 */ 62) >> 1);
				characters[2] = _base32Alphabet[bits];
			}
			
			// Note: the fourth five bits depend on the second byte
			{
				uint8_t bits = ((*(currentByte + 1) & /* 0b00000001 */ 1) << 4);
				bits = bits | ((byteOffset + 2 > [self length]) ? 0 : (((*(currentByte + 2)) & /* 0b11110000 */ 240) >> 4));
				characters[3] = _base32Alphabet[bits];
			}
			
			// Note: the fifth five bits depend on the third byte
			if ((byteOffset + 3) > [self length]) break;
			{
				uint8_t bits = ((*(currentByte + 2) & /* 0b00001111 */ 15) << 1);
				bits = bits | ((byteOffset + 3 > [self length]) ? 0 : ((*(currentByte + 3) & /* 0b1000000 */ 128) >> 7));
				characters[4] = _base32Alphabet[bits];
			}
			
			// Note: the sixth five bits depend on the fourth byte
			if ((byteOffset + 4) > [self length]) break;
			{
				uint8_t bits = ((*(currentByte + 3) & /* 0b01111100 */ 124) >> 2);
				characters[5] = _base32Alphabet[bits];
			}
			
			// Note: the seventh five bits depend on the fourth byte
			{
				uint8_t bits = ((*(currentByte + 3) & /* 0b00000011 */ 3) << 3);
				bits = bits | ((byteOffset + 4 > [self length]) ? 0 : ((*(currentByte + 4) & /* 0b11100000 */ 224) >> 5));
				characters[6] = _base32Alphabet[bits];
			}
			
			// Note: the eighth five bits depend on the fifth byte
			if ((byteOffset + 5) > [self length]) break;
			{
				uint8_t bits = *(currentByte + 4) & /* 0b00011111 */ 31;
				characters[7] = _base32Alphabet[bits];
			}
		} while (NO);
		
		[string appendString:[[[NSString alloc] initWithBytes:characters length:8 encoding:NSASCIIStringEncoding] autorelease]];
		
		byteOffset += 5;
		currentByte += 5;
	}
	
	CFRelease(self);
	
	return string;
}

@end
