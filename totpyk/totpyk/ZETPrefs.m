//
//  ZETPrefs.m
//  totpyk
//
//  Created by Stephen Lombardo on 1/31/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import "ZETPrefs.h"
#import "LaunchAtLoginController.h"

@implementation ZETPrefs

- (NSInteger) timeStep {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kTimeStep];
}

- (void) setTimeStep:(NSInteger)value {
    if(value > 0 && value <= 3600) {
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:kTimeStep];
    }
}

- (NSInteger) digits {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kDigits];
}

- (void) setDigits:(NSInteger)value {
    if(value > 0 && value < 9) {
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:kDigits];
    }
}

- (NSInteger) keySlot {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kKeySlot];
}

- (void) setKeySlot:(NSInteger)value {
    if(value > 0 && value < 3) {
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:kKeySlot];
    }
}

- (SGKeyCombo *) hotKeyCombo {
    id plistCombo = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalHotKey];
    if(!plistCombo) {
        return plistCombo;
    }
    return [[[SGKeyCombo alloc] initWithPlistRepresentation:plistCombo] autorelease];
}

- (void) setHotKeyCombo:(SGKeyCombo *)value {
    [[NSUserDefaults standardUserDefaults] setObject:[value plistRepresentation] forKey:kGlobalHotKey];
}

- (BOOL) launchAtLogin {
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    BOOL launch = [launchController launchAtLogin];
    [launchController release];
    return launch;
}

- (void) setLaunchAtLogin:(BOOL)value {
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    [launchController setLaunchAtLogin:value];
    [launchController release];
}

@end
