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

#import <Foundation/Foundation.h>
#import "ZETPrefsController.h"

@interface ZETMenuController : NSObject {
@private
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    ZETPrefsController *prefsController;
}

@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) ZETPrefsController *prefsController;


- (IBAction)insert:(id)sender;
- (void)insertHotKey:(id)sender;
- (IBAction)showPrefWindow:(id)sender;
- (IBAction)showAboutWindow:(id)sender;

@end
