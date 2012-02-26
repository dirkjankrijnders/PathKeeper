//
//  PKMainWindowController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKMainWindowController.h"
//#import "PKDetailViewController.h"
#import "PKMainViewController.h"

@implementation PKMainWindowController

@synthesize managedObjectContext;
@synthesize mainViewController;
- (void) windowDidLoad
{
	// Make detail view controller
	// add views to the right side of the split view
	mainViewController = [[[PKMainViewController alloc] initWithNibName:@"mainView" bundle:nil windowController:self] autorelease];
	[self addViewController:mainViewController];
	[mainViewController.view setFrame:[self.window.contentView frame]];
	[mainViewController.view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[self.window.contentView addSubview:mainViewController.view];
	/*	
	// get the left view from the split view
	NSView * aSplitViewRightView = [[oMainSplitView subviews] objectAtIndex:1];
	// get the table view from its view controller
	NSView * aDetailView = [detailViewController view];
	// position the table view
	[aDetailView setFrame:[aSplitViewRightView bounds]];
	// set its autoresizing mask
	
	// add table view to the left subview of the split view
	[aSplitViewRightView addSubview:aDetailView];
	
	// patch the detail view into the responder chain
	NSResponder * aNextResponder = [self nextResponder];
	[self setNextResponder:detailViewController];
	[detailViewController setNextResponder:aNextResponder];

 */
};

- (NSArrayController*) trackController
{
//	NSLog(@"Returning app delegates trackController: %@", [[NSApp delegate] trackController]);
	return [[NSApp delegate] trackController];
};

- (IBAction) add:(id)sender
{
	[[self trackController] add:sender];
};

- (IBAction) remove:(id)sender
{
	[[self trackController] remove:sender];
};

- (IBAction) fetch:(id)sender
{

//	[[self trackController] fetch:sender];
};


-(void) updateManagedObjectContext:(NSNotification*)aNotification
{
	NSLog(@"Revcieved update notification");
	[[self managedObjectContext] mergeChangesFromContextDidSaveNotification:aNotification];
}


@end
