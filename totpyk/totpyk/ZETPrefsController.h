//
//  ZETPrefsController.h
//  totpyk
//
//  Created by Stephen Lombardo on 1/14/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SRRecorderControl.h"
#import "ZETPrefs.h"
 
@interface ZETPrefsController : NSWindowController <NSWindowDelegate>{
    @private
    IBOutlet SRRecorderControl *recorderControl;
    ZETPrefs *prefs;
    NSString *writeKey;
    NSInteger writeKeySlot;
    BOOL writeKeyPress;
    IBOutlet NSObjectController *objectController;
}

@property (nonatomic, retain) IBOutlet SRRecorderControl *recorderControl;
@property (nonatomic, retain) ZETPrefs *prefs;
@property (nonatomic, retain) NSString *writeKey;
@property (nonatomic) NSInteger writeKeySlot;

@property (nonatomic) BOOL writeKeyPress;
@property (nonatomic, retain) IBOutlet NSObjectController *objectController;

- (BOOL) shortcutRecorder:(SRRecorderControl *)aRecorder 
                isKeyCode:(signed short)keyCode 
            andFlagsTaken:(unsigned int)flags 
                   reason:(NSString **)aReason;

- (void) shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo;

+ (NSString *)normalizeKey:(NSString *)value;
+ (BOOL)isKeyValid:(NSString *)value;
    
- (IBAction)writeConfig:(id)sender;
@end
