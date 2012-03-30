//
//  ZETPrefsController.m
//  OneTimeTests
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

#define KEY_ENCODING_BASE32 0
#define KEY_ENCODING_HEX 1

@implementation ZETPrefsController

@synthesize recorderControl, writeKeyPress, writeKey, writeKeySlot, prefs, objectController, keyEncoding, hotKeyDescription;

- (void)dealloc
{
    [recorderControl release];
    [writeKey release];
    [prefs release];
    [objectController release];
    [hotKeyDescription release];
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"ZETPrefsController"];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) { 
        writeKeySlot = 2;
        keyEncoding = KEY_ENCODING_BASE32;
        prefs = [[ZETPrefs alloc] init];
        self.hotKeyDescription = [prefs.hotKeyCombo description];
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
    SGKeyCombo *combo = [SGKeyCombo keyComboWithKeyCode:newKeyCombo.code modifiers:[aRecorder cocoaToCarbonFlags:newKeyCombo.flags]];
    if([combo isValidHotKeyCombo]) {
        NSLog(@"shortcutRecorder keyComboDidChange");
        prefs.hotKeyCombo = combo;
        [((ZETAppDelegate *)[NSApp delegate]) registerHotKeyCombo:prefs.hotKeyCombo];
        self.hotKeyDescription = [prefs.hotKeyCombo description];
    }
}


- (BOOL) validateWriteKey:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) return NO;
    
    NSString *value = (NSString *)*ioValue;
    
    if([ZETYkKey isBase32KeyValid:value]) return YES;
    
    if(keyEncoding == KEY_ENCODING_BASE32) {
        *outError = [NSError errorWithDomain:@"ZETDomain" 
                                        code:100 
                                    userInfo:[NSMutableDictionary 
                                              dictionaryWithObject:@"Key must be a Base32 string of 32 characters or less"
                                              forKey:NSLocalizedDescriptionKey]];
    } else if (keyEncoding == KEY_ENCODING_HEX) {
        if([ZETYkKey isHexKeyValid:value]) return YES;
        
        *outError = [NSError errorWithDomain:@"ZETDomain" 
                                        code:100 
                                    userInfo:[NSMutableDictionary 
                                              dictionaryWithObject:@"Key must be a Hex string of 40 characters or less"
                                              forKey:NSLocalizedDescriptionKey]];
    }
    return NO;
}

- (IBAction)writeConfig:(id)sender
{   
    if([objectController commitEditing] && writeKey != nil && writeKey.length > 0) 
    {
        ZETYkKey *ykKey = [[ZETYkKey alloc] init];
        ykKey.slot = (int) writeKeySlot;
        
        BOOL result = false;
        
        if(keyEncoding == KEY_ENCODING_BASE32) {
            result = [ykKey writeHmacCRConfigWithBase32Key:writeKey buttonTrigger:writeKeyPress];
        } else if(keyEncoding == KEY_ENCODING_HEX) {
            result = [ykKey writeHmacCRConfigWithHexKey:writeKey buttonTrigger:writeKeyPress];
        }
        
        NSAlert * alert;
        if(result) {
            self.writeKey = @""; //clear write key box after commit;
            alert= [NSAlert alertWithMessageText:@"Success!"
                                   defaultButton:@"OK"
                                 alternateButton:nil
                                     otherButton:nil
                       informativeTextWithFormat:[NSString stringWithFormat:@"Wrote configuration to Yubikey slot %d", ykKey.slot]];
        }
        else {
             alert= [NSAlert alertWithMessageText:@"Configuration Error"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                  informativeTextWithFormat:[NSString stringWithFormat:@"Error occurred writing configuration to Yubikey: %@", ykKey.errorMessage]];
        }
        
        [alert beginSheetModalForWindow:self.window
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:nil];
        
        [ykKey release];
        
    }
}
                                    

@end
