//
//  ZETPrefs.h
//  totpyk
//
//  Created by Stephen Lombardo on 1/31/12.
//  Copyright (c) 2012 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGKeyCombo.h"

#define kGlobalHotKey @"GlobalHotKey"
#define kTimeStep @"TimeStep"
#define kDigits @"Digits"
#define kKeySlot @"KeySlot"
#define kTypeReturnKey @"TypeReturnKey"

@interface ZETPrefs : NSObject

@property (nonatomic) NSInteger timeStep;
@property (nonatomic) NSInteger digits;
@property (nonatomic) NSInteger keySlot;
@property (nonatomic) BOOL launchAtLogin;
@property (nonatomic) BOOL typeReturnKey;
@property (nonatomic, assign) SGKeyCombo *hotKeyCombo;

@end
