//
//  ZETMenuController.h
//  totpyk
//
//  Created by Stephen Lombardo on 12/30/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZETMenuController : NSObject {
@private
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
}

@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSStatusItem *statusItem;

- (IBAction)insert:(id)sender;

@end
