//
//  PKMainWindowController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSWindowController.h"

@class PKMainViewController;

@interface PKMainWindowController : XSWindowController {	
	NSManagedObjectContext* managedObjectContext;

	IBOutlet NSSplitView *		oMainSplitView;
	
	IBOutlet NSTableColumn*		oNameColumn;
	
	PKMainViewController* mainViewController;
}

@property (retain) NSManagedObjectContext* managedObjectContext;
@property (assign) PKMainViewController* mainViewController;
- (NSArrayController*) trackController;

- (IBAction) add:(id)sender;
- (IBAction) remove:(id)sender;
- (IBAction) fetch:(id)sender;

@end
