//
//  ZETAppDelegate.m
//  totpyk
//
//  Created by Stephen Lombardo on 12/30/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import "ZETAppDelegate.h"
#import "ZETOneBasedIndexValueTransformer.h"
#import "SGKeyCombo.h"
#import "SGHotKeyCenter.h"
#import "SRCommon.h"

@implementation ZETAppDelegate

@synthesize menuController,hotKey, prefs;
- (void)dealloc
{
    [menuController release];
    [prefs release];
    [hotKey release];
    [super dealloc];
}

- (void) initialize {
    ZETOneBasedIndexValueTransformer *obit = [[[ZETOneBasedIndexValueTransformer alloc] init]
                                              autorelease];
    [NSValueTransformer setValueTransformer:obit
                                    forName:@"ZETOneBasedIndexValueTransformer"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    prefs = [[ZETPrefs alloc]init];
    menuController = [[ZETMenuController alloc] init];
    
    if(!prefs.hotKeyCombo) {
        // first run no preferences set
        prefs.timeStep = 30;
        prefs.digits = 6;
        prefs.keySlot = 2;
        prefs.launchAtLogin = YES;
        prefs.typeReturnKey = YES;
        prefs.hotKeyCombo = [SGKeyCombo keyComboWithKeyCode:kVK_ANSI_Y modifiers:(kCommandUnicode|kShiftUnicode)];
        
        [menuController showPrefWindow:nil];
    }
    [self registerHotKeyCombo:prefs.hotKeyCombo];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    self.menuController = nil;
    return NSTerminateNow;
}
       
- (void) registerHotKeyCombo:(SGKeyCombo *)keyCombo {
    [[SGHotKeyCenter sharedCenter] unregisterHotKey:hotKey];	
    self.hotKey = [[SGHotKey alloc] initWithIdentifier:kGlobalHotKey 
                                             keyCombo:keyCombo target:menuController action:@selector(insertHotKey:)];
    [[SGHotKeyCenter sharedCenter] registerHotKey:hotKey];
}

@end
