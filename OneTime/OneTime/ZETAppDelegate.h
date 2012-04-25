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

#import <Cocoa/Cocoa.h>
#import "SGHotKey.h"
#import "ZETPrefs.h"
#import "ZETMenuController.h"

@interface ZETAppDelegate : NSObject <NSApplicationDelegate> {
    ZETMenuController *menuController;
    SGHotKey *hotKey;
    ZETPrefs *prefs;
}

@property (nonatomic, retain) ZETMenuController *menuController;
@property (nonatomic, retain) SGHotKey *hotKey;
@property (nonatomic, retain) ZETPrefs *prefs;

- (void) registerHotKeyCombo:(SGKeyCombo *)keyCombo;
@end
