//
//  ZETPrefsController.h
//  totpyk
//
//  Created by Stephen Lombardo on 1/14/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SRRecorderControl.h"
 
@interface ZETPrefsController : NSWindowController <NSWindowDelegate>{
    @private
    IBOutlet SRRecorderControl *recorderControl;
    IBOutlet NSTextField *stepTextField;
    IBOutlet NSTextField *digitsTextField;
    IBOutlet NSStepper *digitsStepper;
    IBOutlet NSPopUpButton *keySlotPopUp;
}

@property (nonatomic, retain) IBOutlet SRRecorderControl *recorderControl;
@property (nonatomic, retain) IBOutlet NSTextField *stepTextField;
@property (nonatomic, retain) IBOutlet NSTextField *digitsTextField;
@property (nonatomic, retain) IBOutlet NSStepper *digitsStepper;
@property (nonatomic, retain) IBOutlet NSPopUpButton *keySlotPopUp;

- (BOOL) shortcutRecorder:(SRRecorderControl *)aRecorder 
                isKeyCode:(signed short)keyCode 
            andFlagsTaken:(unsigned int)flags 
                   reason:(NSString **)aReason;

- (void) shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo;
- (IBAction)digitsChanged:(id)sender;
- (IBAction)preferenceChanged:(id)sender;

- (void) loadUserDefaults;
- (void) saveUserDefaults;
@end
