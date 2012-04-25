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
