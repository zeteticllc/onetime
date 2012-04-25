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

#import <Carbon/Carbon.h>
#include <ApplicationServices/ApplicationServices.h>
#import "ZETYkTOTP.h"
#import "ZETMenuController.h"
#import "ZETAppDelegate.h"


@implementation ZETMenuController
@synthesize statusMenu, statusItem, prefsController;

- (id)init
{
    self = [super init];
    if (self) {
        statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
        statusItem.highlightMode = YES;
        statusItem.enabled = YES;
        statusItem.image = [NSImage imageNamed:@"Menu"];
        statusItem.alternateImage = [NSImage imageNamed:@"MenuHighlighted"];
        if([NSBundle loadNibNamed:@"ZETMenuController" owner:self]) {
            statusItem.menu = self.statusMenu;
        }
    }
    
    return self;
}

- (IBAction)insert:(id)sender {
    ZETYkTOTP *totp = [[ZETYkTOTP alloc] init];
    ZETPrefs *prefs = [[[ZETPrefs alloc] init] autorelease];
    
    totp.step = prefs.timeStep;
    totp.digits = prefs.digits;
    totp.key.slot = prefs.keySlot;
    
    NSString *otp = [totp totpChallenge];
    
    if(otp != nil && !totp.key.error) {
        
        CGEventSourceRef eventSource = CGEventSourceCreate(kCGEventSourceStateHIDSystemState); 
        CGEventRef event; //= CGEventCreateKeyboardEvent(eventSource, 0, true); 

        for(int i = 0; i < otp.length; i++) {
            unichar c = [otp characterAtIndex:i];
            event = CGEventCreateKeyboardEvent(eventSource, 1, true);
            CGEventKeyboardSetUnicodeString(event, 1, &c);
            CGEventPost(kCGHIDEventTap, event);
            CFRelease(event);
        }

        if(prefs.typeReturnKey) {
            event = CGEventCreateKeyboardEvent(eventSource, 76, true); // 76 is RETURN key (extracted from SRKeyCodeTransformer)
            CGEventPost(kCGHIDEventTap, event);
            CFRelease(event);
        }
        
        CFRelease(eventSource);
    } else {
        NSAlert *alert= [NSAlert alertWithMessageText:@"Error"
                               defaultButton:@"OK"
                             alternateButton:nil
                                 otherButton:nil
                   informativeTextWithFormat:[NSString stringWithFormat:@"Unable to challenge Yubikey: %@", totp.key.errorMessage]];
        
        NSApplication *thisApp = [NSApplication sharedApplication];
        [thisApp activateIgnoringOtherApps:YES];
        [alert runModal];
    }
    [totp release];
}

- (void) insertHotKey:(id)sender {
    usleep(500000); // sleep to allow hotkey press to release
    [self insert:sender];
}

- (IBAction)showPrefWindow:(id)sender {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    if(prefsController == nil) {
        self.prefsController = [[ZETPrefsController alloc] init];
    }
    [prefsController.window makeKeyAndOrderFront:sender];
}

- (IBAction)showAboutWindow:(id)sender {
    NSApplication *thisApp = [NSApplication sharedApplication];
    // since this is a menu app, we need to activate it to bring up the about panel in front
    [thisApp activateIgnoringOtherApps:YES];
    [thisApp orderFrontStandardAboutPanel:sender];
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    [statusItem release];
    [statusMenu release];
    [prefsController release];
    [super dealloc];
}

@end
