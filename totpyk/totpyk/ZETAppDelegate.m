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

NSString *kGlobalHotKey = @"Global Hot Key";

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
    [self.menuController = [[ZETMenuController alloc] init] release];
    
    [self registerHotKey:kVK_Space modifiers:(kCommandUnicode|kShiftUnicode)];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    self.menuController = nil;
    return NSTerminateNow;
}

- (void) registerHotKey:(NSInteger)theKeyCode modifiers:(NSUInteger)theModifiers {
    SGKeyCombo *keyCombo = [SGKeyCombo keyComboWithKeyCode:theKeyCode modifiers:theModifiers];
    [[SGHotKeyCenter sharedCenter] unregisterHotKey:hotKey];	
    self.hotKey = [[SGHotKey alloc] initWithIdentifier:kGlobalHotKey 
                                                keyCombo:keyCombo target:menuController action:@selector(insertHotKey:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:hotKey];
}

@end
