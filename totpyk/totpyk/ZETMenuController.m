//
//  ZETMenuController.m
//  totpyk
//
//  Created by Stephen Lombardo on 12/31/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "ZETMenuController.h"
#include <ApplicationServices/ApplicationServices.h>

/*
#define kVK_Command 0x37
#define kVK_ANSI_V 0x09
*/

@implementation ZETMenuController
@synthesize statusMenu, statusItem;

- (id)init
{
    self = [super init];
    if (self) {
        statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
        statusItem.highlightMode = YES;
        statusItem.title = @"blarf";
        statusItem.enabled = YES;
        statusItem.image = [NSImage imageNamed:@"Menu"];
        statusItem.alternateImage = [NSImage imageNamed:@"MenuHighlighted"];
        if([NSBundle loadNibNamed:@"ZETMenuController" owner:self]) {
            statusItem.menu = self.statusMenu;
        }
    }
    
    return self;
}

- (IBAction)insert:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    NSMutableDictionary *saved = [NSMutableDictionary dictionary];
    for (NSString *type in [pb types]) {
        NSData *data = [pb dataForType:type];
        if (data) {
            [saved setObject:data forKey:type]; 
        }
    }
    
    [pb clearContents];
    
    // set the new data into the pasteboard
    [pb setString:@"This is a test!" forType:NSStringPboardType];
    
    // post virtual keyboard events for command-v to paste in current location
    // http://classicteck.com/rbarticles/mackeyboard.php
    // /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
    // see also AXUIElement.h, CGKeyCode
    AXUIElementRef axSystemWideElement = AXUIElementCreateSystemWide();
    AXError err;
    
    err = AXUIElementPostKeyboardEvent(axSystemWideElement, 0, kVK_Command, YES);
    err = AXUIElementPostKeyboardEvent(axSystemWideElement, 0, kVK_ANSI_V, YES);
    err = AXUIElementPostKeyboardEvent(axSystemWideElement, 0, kVK_ANSI_V, NO);
    err = AXUIElementPostKeyboardEvent(axSystemWideElement, 0, kVK_Command, NO);
    
    usleep(100000);// sleep for a bit to give the paste time to process
    // clear OTP from clipboard
    
    [pb clearContents];
    
    for (NSString *type in [saved keyEnumerator]) {
        [pb setData:[saved objectForKey:type] forType:type];
    }
    
}

- (void) insertHotKey:(id)sender {
    usleep(1000000);
    [self insert:sender];
}


- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    [statusItem release];
    [statusMenu release];
    [super dealloc];
}

@end
