//
//  ZETPrefsController.h
//  totpyk
//
//  Created by Stephen Lombardo on 1/14/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SRRecorderControl.h"
 
@interface ZETPrefsController : NSWindowController {
    @private
    IBOutlet SRRecorderControl *recorderControl;
    IBOutlet NSTextField *stepTextField;
}

@property (nonatomic, retain) IBOutlet SRRecorderControl *recorderControl;
@property (nonatomic, retain) IBOutlet NSTextField *stepTextField;

- (BOOL) shortcutRecorder:(SRRecorderControl *)aRecorder 
                isKeyCode:(signed short)keyCode 
            andFlagsTaken:(unsigned int)flags 
                   reason:(NSString **)aReason;

- (void) shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo;

@end
