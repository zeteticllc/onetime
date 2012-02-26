//
//  ZETMenuController.h
//  OneTimeTests
//
//  Created by Stephen Lombardo on 12/30/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZETPrefsController.h"

@interface ZETMenuController : NSObject {
@private
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    ZETPrefsController *prefsController;
}

@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) ZETPrefsController *prefsController;


- (IBAction)insert:(id)sender;
- (void)insertHotKey:(id)sender;
- (IBAction)showPrefWindow:(id)sender;
- (IBAction)showAboutWindow:(id)sender;

@end
