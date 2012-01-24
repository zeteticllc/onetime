//
//  ZETAppDelegate.m
//  totpyk
//
//  Created by Stephen Lombardo on 12/30/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import "ZETAppDelegate.h"
#import "SGKeyCombo.h"
#import "SGHotKeyCenter.h"
#import "SRCommon.h"


@implementation ZETAppDelegate

@synthesize menuController,hotKey;
- (void)dealloc
{
    [menuController release];
    [hotKey release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.menuController = [[ZETMenuController alloc] init] release];
    
    id hotKeyPlist = [defaults objectForKey:kGlobalHotKey];
    if(hotKeyPlist) {
        [self registerHotKeyCombo:[[[SGKeyCombo alloc] initWithPlistRepresentation:hotKeyPlist] autorelease]];
    } else {
        // first run no preferences set
        
        [defaults setInteger:30 forKey:kTimeStep];
        [defaults setInteger:6 forKey:kDigits];
        [defaults setInteger:2 forKey:kKeySlot];
        
        [self registerHotKey:kVK_Space modifiers:(kCommandUnicode|kShiftUnicode)];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    self.menuController = nil;
    return NSTerminateNow;
}

- (void) registerHotKey:(NSInteger)theKeyCode modifiers:(NSUInteger)theModifiers {
    [self registerHotKeyCombo:[SGKeyCombo keyComboWithKeyCode:theKeyCode modifiers:theModifiers]];
}
       
- (void) registerHotKeyCombo:(SGKeyCombo *)keyCombo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[SGHotKeyCenter sharedCenter] unregisterHotKey:hotKey];	
    self.hotKey = [[SGHotKey alloc] initWithIdentifier:kGlobalHotKey 
                                             keyCombo:keyCombo target:menuController action:@selector(insertHotKey:)];
    [[SGHotKeyCenter sharedCenter] registerHotKey:hotKey];
    [defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalHotKey];
}

@end
