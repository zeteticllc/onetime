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
#import "SRRecorderControl.h"
#import "ZETPrefs.h"
 
@interface ZETPrefsController : NSWindowController <NSWindowDelegate>{
    @private
    IBOutlet SRRecorderControl *recorderControl;
    ZETPrefs *prefs;
    NSString *writeKey;
    NSInteger writeKeySlot;
    NSInteger keyEncoding;
    BOOL writeKeyPress;
    IBOutlet NSObjectController *objectController;
    NSString *hotKeyDescription;
}

@property (nonatomic, retain) IBOutlet SRRecorderControl *recorderControl;
@property (nonatomic, retain) ZETPrefs *prefs;
@property (nonatomic, retain) NSString *writeKey;
@property (nonatomic) NSInteger writeKeySlot;
@property (nonatomic) NSInteger keyEncoding;
@property (nonatomic) BOOL writeKeyPress;
@property (nonatomic, retain) IBOutlet NSObjectController *objectController;
@property (nonatomic, retain) NSString *hotKeyDescription;

- (BOOL) shortcutRecorder:(SRRecorderControl *)aRecorder 
                isKeyCode:(signed short)keyCode 
            andFlagsTaken:(unsigned int)flags 
                   reason:(NSString **)aReason;

- (void) shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo;

- (IBAction)writeConfig:(id)sender;
@end
