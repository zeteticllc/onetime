    //
//  ZETPrefsController.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/14/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "ZETPrefsController.h"
#import "ZETAppDelegate.h"
#import "NSData+Hex.h"
#import "NSData+Base32.h"
#import "NSString+Padding.h"
#import "ZETYkKey.h"
#include <ykpers.h>
#include <ykdef.h>
#include <totp.h>

@implementation ZETPrefsController

@synthesize recorderControl, writeKeyPress, writeKey, writeKeySlot, prefs, objectController;

- (void)dealloc
{
    [recorderControl release];
    [writeKey release];
    [prefs release];
    [objectController release];
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"ZETPrefsController"];
    prefs = [[ZETPrefs alloc] init];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) { 
        writeKeySlot = 2;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void) windowWillClose:(NSNotification *)notification
{
    [objectController commitEditing];
}

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder 
               isKeyCode:(signed short)keyCode 
           andFlagsTaken:(unsigned int)flags 
                  reason:(NSString **)aReason {
    
    NSLog(@"shortcutRecorder isKeyCode");
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo 
{
    NSLog(@"shortcutRecorder keyComboDidChange");
    prefs.hotKeyCombo = [SGKeyCombo keyComboWithKeyCode:newKeyCombo.code modifiers:[aRecorder cocoaToCarbonFlags:newKeyCombo.flags]];
    [((ZETAppDelegate *)[NSApp delegate]) registerHotKeyCombo:prefs.hotKeyCombo];
}


- (BOOL) validateWriteKey:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) return NO;
    
    NSString *value = [ZETPrefsController normalizeKey:(NSString *)*ioValue];
    
    if([ZETPrefsController isKeyValid:value]) return YES;
    
    *outError = [NSError errorWithDomain:@"ZETDomain" 
                                    code:100 
                                userInfo:[NSMutableDictionary 
                                          dictionaryWithObject:@"Key must be a Base 32 or Hex string"
                                          forKey:NSLocalizedDescriptionKey]];
    return NO;
}

+ (NSString *)normalizeKey:(NSString *)value {
    return [[value stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
}

+ (BOOL)isKeyValid:(NSString *)value {
    
    if(value == nil) return NO;
    
    NSCharacterSet *hexSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"];
    NSCharacterSet *base32Set = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"];
    NSCharacterSet *valueSet = [NSCharacterSet characterSetWithCharactersInString:value];
    
    if(
       ((value.length == 16 || value.length == 32) && [base32Set isSupersetOfSet:valueSet]) || 
       ((value.length == 20 || value.length == 40)  && [hexSet isSupersetOfSet:valueSet])) {
        return YES;
    }
    return NO;
}

- (IBAction)writeConfig:(id)sender
{   
    if([objectController commitEditing]) 
    {
        NSString *keyString = [ZETPrefsController normalizeKey:writeKey];
        
        if([ZETPrefsController isKeyValid:keyString]){
            NSString *hexKey = [[[NSData dataWithBase32String:keyString] dataToHex] stringByPaddingRight:@"0" length:40];
            
            ZETYkKey *ykKey = [[ZETYkKey alloc] init];
            ykKey.slot = (int) writeKeySlot;
            [ykKey writeHmacCRConfig:hexKey buttonTrigger:writeKeyPress];
            
            [ykKey release];
        }
    }
}
                                        

@end
