//
//  ZETPrefsController.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/14/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "ZETPrefsController.h"
#import "ZETAppDelegate.h"
#include <ykpers.h>
#include <ykdef.h>
#include <totp.h>

@implementation ZETPrefsController

@synthesize recorderControl, stepTextField, digitsTextField, digitsStepper, keySlotPopUp, requireKeyPress;

- (void)dealloc
{
    [recorderControl release];
    [stepTextField release];
    [digitsTextField release];
    [digitsStepper release];
    [keySlotPopUp release];
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"ZETPrefsController"];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) { }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self loadUserDefaults];
}

- (void) windowWillClose:(NSNotification *)notification
{
    [self saveUserDefaults];
}

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder 
               isKeyCode:(signed short)keyCode 
           andFlagsTaken:(unsigned int)flags 
                  reason:(NSString **)aReason {
    
    NSLog(@"shortcutRecorder isKeyCode");
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo 
{
    NSLog(@"shortcutRecorder keyComboDidChange");
    ZETAppDelegate *delegate = (ZETAppDelegate *)[NSApp delegate];
    NSUInteger flags = [aRecorder cocoaToCarbonFlags:newKeyCombo.flags];
    [delegate registerHotKey:newKeyCombo.code modifiers:flags];
}

- (IBAction)preferenceChanged:(id)sender
{
    [self saveUserDefaults];
}

- (IBAction)digitsChanged:(id)sender
{
    int value = [sender intValue];
    [digitsTextField setIntValue:value];
    [digitsStepper setIntValue:value];
    [self preferenceChanged:sender];
}

- (void) loadUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [stepTextField setIntValue:(int)[defaults integerForKey:kTimeStep]];
    [digitsTextField setIntValue:(int)[defaults integerForKey:kDigits]];
    [digitsStepper setIntValue:(int)[defaults integerForKey:kDigits]];
    [keySlotPopUp selectItemAtIndex:(int)([defaults integerForKey:kKeySlot] - 1)];
}

- (void) saveUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int value = [digitsTextField intValue];
    if(value > 0 && value < 9) {
        [defaults setInteger:value forKey:kDigits];
    }
    
    value = [stepTextField intValue];
    if(value > 0 && value < 3600) {
        [defaults setInteger:value forKey:kTimeStep];
    }
    
    [defaults setInteger:[keySlotPopUp indexOfSelectedItem]+1 forKey:kKeySlot];
    [self loadUserDefaults]; // load back settings we just saved, in case there were any preference changes that were ignored
}

- (IBAction)writeConfig:(id)sender
{   YK_KEY *yk = 0;
	ykp_errno = 0;
	yk_errno = 0;
    int res =0;
    YKP_CONFIG *cfg = ykp_create_config();
    YK_STATUS *st = ykds_alloc();
    
    if (yk_init() && (yk = yk_open_first_key())) {
        if (check_firmware(yk, 0)) {
            if (!yk_get_status(yk, st)) 
            {
                printf("failed");
            }
            struct config_st *ycfg = (struct config_st *) ykp_core_config(cfg);
            ycfg->tktFlags = 0;
            ycfg->cfgFlags = 0;
            ycfg->extFlags = 0;
            
            ykp_configure_for(cfg, 2, st);
            ykp_set_tktflag_CHAL_RESP(cfg, true);
            ykp_set_cfgflag_CHAL_HMAC(cfg, true);
            ykp_set_cfgflag_HMAC_LT64(cfg, true);
            ykp_set_cfgflag_CHAL_BTN_TRIG(cfg, false);
            res = ykp_HMAC_key_from_hex(cfg, "0000000000000000000000000000000000000000");
            if (yk_write_config(yk, ykp_core_config(cfg), ykp_config_num(cfg), NULL))
            {
                printf("success");
            } else {
                printf("failure");
            }
            free(cfg);
            free(st);
        } else {
            //return @"incorrect firmware version";
        }
	} else {
        //return @"unable to open key";
    }
    
	if (yk && !yk_close_key(yk)) {
        //return @"close failed";
	}
    
    if(!yk_release()) {
        //return @"release failed";
    }
    
}

@end
