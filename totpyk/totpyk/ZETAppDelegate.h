//
//  ZETAppDelegate.h
//  totpyk
//
//  Created by Stephen Lombardo on 12/30/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SGHotKey.h"
#import "ZETMenuController.h"

@interface ZETAppDelegate : NSObject <NSApplicationDelegate> {
    ZETMenuController *menuController;
    SGHotKey *hotKey;
}

@property (nonatomic, retain) ZETMenuController *menuController;
@property (nonatomic, retain) SGHotKey *hotKey;

@end
