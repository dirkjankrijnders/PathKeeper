//
//  PKMainViewController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKMainViewController.h"
#import "PKDetailViewController.h"
#import "PKSourceOutlineViewController.h"
#import "PKTrackListViewController.h"

@implementation PKMainViewController

@synthesize detailViewController;

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle windowController:(XSWindowController *)windowController;
{
	if (![super initWithNibName:name bundle:bundle windowController:windowController])
		return nil;
	
	PKSourceOutlineViewController* sourceView = [[[PKSourceOutlineViewController alloc] initWithNibName:@"sourceOutlineView" bundle:nil windowController:windowController] autorelease];
	detailViewController = [[[PKDetailViewController alloc] initWithNibName:@"detailView" bundle:nil windowController:windowController] autorelease];
	PKTrackListViewController* trackListViewController = [[[PKTrackListViewController alloc] initWithNibName:@"trackListView" bundle:nil windowController:windowController] autorelease];

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(trackSelectionChanged:) name:@"trackSelectionChanged" object:nil];
	
	[self addChild:detailViewController];
	[self addChild:sourceView];
	[self addChild:trackListViewController];
	return self;
};

- (void) trackSelectionChanged:(NSNotification*)n
{
	for (XSViewController* childView in [self children])
		[childView setRepresentedObject:[[n userInfo] objectForKey:@"track"]];
};

- (void) awakeFromNib 
{
/*	for ( NSTableColumn* tc in [oTableView tableColumns] )
	{
		[tc bind:@"value" toObject:[[NSApp delegate] trackController] withKeyPath:[NSString stringWithFormat:@"arrangedObjects.%@", [tc identifier]] options:nil];
	}*/
//	self.view.subviews = [NSArray arrayWithObjects:[[self.children objectAtIndex:0] view],[[self.children objectAtIndex:1] view],nil];
	NSView* detailView = [[self.children objectAtIndex:0] view];
	NSView * aSplitViewRightView = [[self.view subviews] objectAtIndex:1];

	NSView * aSplitViewRightBottomView = [[[[aSplitViewRightView subviews]  objectAtIndex:0] subviews] objectAtIndex:1];
	[detailView setFrame:[aSplitViewRightBottomView bounds]];
//	NSLog(@"Frame: %@", NSStringFromRect([oRightView frame]));
	[detailView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[aSplitViewRightBottomView addSubview:detailView];

	NSView* trackListView = [[self.children objectAtIndex:2] view];
	NSView* aSplitViewRightTopView = [[[[aSplitViewRightView subviews]  objectAtIndex:0] subviews] objectAtIndex:0];

	[trackListView setFrame:[aSplitViewRightTopView bounds]];
	//	NSLog(@"Frame: %@", NSStringFromRect([oRightView frame]));
	[trackListView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[aSplitViewRightTopView addSubview:trackListView];
	
	
	NSView* trackView = [[self.children objectAtIndex:1] view];
	NSView * aSplitViewLeftView = [[self.view subviews] objectAtIndex:0];
	[trackView setFrame:[aSplitViewLeftView bounds]];
	//	NSLog(@"Frame: %@", NSStringFromRect([oRightView frame]));
	[trackView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[aSplitViewLeftView addSubview:trackView];
	
}
@end
