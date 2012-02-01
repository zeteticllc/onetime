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

- (void) setTimeStep:(NSInteger)timeStep {
    [[NSUserDefaults standardUserDefaults] setInteger:timeStep forKey:kTimeStep];
}

- (BOOL) validateTimeStep:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) return NO;
    
    NSInteger value = [*ioValue integerValue];
    
    if(value > 0 && value < 3600) return YES;
    
    *outError = [NSError errorWithDomain:@"ZETDomain" 
                                    code:100 
                                userInfo:[NSMutableDictionary 
                                          dictionaryWithObject:@"Digits must be between 1 and 3600"
                                          forKey:NSLocalizedDescriptionKey]];
    
    return NO;
}


- (NSInteger) digits {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kDigits];
}

- (void) setDigits:(NSInteger)digits {
    [[NSUserDefaults standardUserDefaults] setInteger:digits forKey:kDigits];
}

- (BOOL) validateDigits:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) return NO;
    
    NSInteger value = [*ioValue integerValue];
    
    if(value > 0 && value < 9) return YES;
    
    *outError = [NSError errorWithDomain:@"ZETDomain" 
                                    code:100 
                                userInfo:[NSMutableDictionary 
                                          dictionaryWithObject:@"Digits must be between 1 and 8"
                                          forKey:NSLocalizedDescriptionKey]];
    
    return NO;
}

- (NSInteger) keySlot {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kKeySlot];
}

- (void) setKeySlot:(NSInteger)keySlot {
    if(keySlot > 0 && keySlot < 3) {
        [[NSUserDefaults standardUserDefaults] setInteger:keySlot forKey:kKeySlot];
    }
}

- (BOOL) validateKeySlot:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) return NO;
    
    NSInteger value = [*ioValue integerValue];
    
    if(value > 0 && value < 3) return YES;
    
    *outError = [NSError errorWithDomain:@"ZETDomain" 
                                    code:100 
                                userInfo:[NSMutableDictionary 
                                          dictionaryWithObject:@"Digits must be either 1 or 2"
                                          forKey:NSLocalizedDescriptionKey]];
    
    return NO;
}

- (SGKeyCombo *) hotKeyCombo {
    id plistCombo = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalHotKey];
    if(!plistCombo) {
        return plistCombo;
    }
    return [[[SGKeyCombo alloc] initWithPlistRepresentation:plistCombo] autorelease];
}

- (void) setHotKeyCombo:(SGKeyCombo *)hotKeyCombo {
    [[NSUserDefaults standardUserDefaults] setObject:[hotKeyCombo plistRepresentation] forKey:kGlobalHotKey];
}

- (BOOL) launchAtLogin {
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    BOOL launch = [launchController launchAtLogin];
    [launchController release];
    return launch;
}

- (void) setLaunchAtLogin:(BOOL)launchAtLogin {
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    [launchController setLaunchAtLogin:launchAtLogin];
    [launchController release];
}

@end
