//
//  ZETAppDelegate.m
//  totpyk
//
//  Created by Stephen Lombardo on 12/30/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import "ZETAppDelegate.h"

@implementation ZETAppDelegate

@synthesize menuController = _menuController;
- (void)dealloc
{
    [_menuController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.menuController = [[ZETMenuController alloc] init] release];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    self.menuController = nil;
    return NSTerminateNow;
}

@end
