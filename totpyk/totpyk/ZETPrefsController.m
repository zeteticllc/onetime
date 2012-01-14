//
//  ZETPrefsController.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/14/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "ZETPrefsController.h"
#import "ZETAppDelegate.h"

@implementation ZETPrefsController

@synthesize recorderControl, stepTextField;

- (id)init
{
    self = [super initWithWindowNibName:@"ZETPrefsController"];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder 
               isKeyCode:(signed short)keyCode 
           andFlagsTaken:(unsigned int)flags 
                  reason:(NSString **)aReason {
    
    NSLog(@"shortcutRecorder isKeyCode");
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    NSLog(@"shortcutRecorder keyComboDidChange");
    ZETAppDelegate *delegate = (ZETAppDelegate *)[NSApp delegate];
    NSUInteger flags = [aRecorder cocoaToCarbonFlags:newKeyCombo.flags];
    [delegate registerHotKey:newKeyCombo.code modifiers:flags];
}


@end
