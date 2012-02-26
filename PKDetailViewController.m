//
//  PKDetailViewController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKDetailViewController.h"
#import "PKWaypointViewController.h"
#import "PKTrackMapViewController.h"
//#import "PKGPSSelectionViewController.h"
#import "PKTrackOverviewViewController.h"
#import "PKTrackGraphViewController.h"

@implementation PKDetailViewController

@synthesize currentViewController = mCurrentViewController;
@synthesize currentWindowController = mCurrentWindowController;

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle windowController:(XSWindowController *)windowController;
{
	if (![super initWithNibName:name bundle:bundle windowController:windowController])
		return nil;
	PKWaypointViewController* waypointViewController = [[[PKWaypointViewController alloc] initWithNibName:@"waypointView" bundle:nil windowController:windowController] autorelease];
	[self addChild:waypointViewController];
	[self setCurrentViewController:waypointViewController];	
	[self setCurrentWindowController:windowController];
	
	return self;
};

- (void) loadView 
{
	[super loadView];

	NSView* waypointView = [[self.children objectAtIndex:0] view];
	[waypointView setFrame:[contentView bounds]];
	
	[waypointView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[contentView addSubview:waypointView];
//	[contentView setWantsLayer:YES];
	[segmentedControl setSelectedSegment:0];
}

- (void) setRepresentedObject:(id)rO
{
	[super setRepresentedObject:rO];
	for (XSViewController* childView in [self children])
		[childView setRepresentedObject:rO];

};

- (IBAction) selectView:(id)sender
{
	[self removeChild:[self currentViewController]];
	// remove current view from hierarchy
	NSView* oldView = [[self currentViewController] view];
	[oldView removeFromSuperview];
	
	// release current view controller
	[self setCurrentViewController:nil];
	
	NSView * newView = nil;
	switch ([sender selectedSegment])
	{
		case 0:
			newView = [self _switchToWaypointView];
			break;
		case 1:
			newView = [self _switchToTrackMapView];
			break;
		case 2:
			newView = [self _switchToOverviewView];
			break;
		case 3:
			newView = [self _switchToGraphView];
			break;
	}
//	[newView setWantsLayer:YES];
//	[newView setAlphaValue:0.0f];
	[newView setFrame:[contentView bounds]];

	[newView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];

	[contentView addSubview:newView];
//	[[oldView animator] setAlphaValue:0.0f];
//	[[newView animator] setAlphaValue:1.0f];
}

- (NSView*) _switchToWaypointView
{
	PKWaypointViewController* waypointViewController = [[[PKWaypointViewController alloc] initWithNibName:@"waypointView" bundle:nil windowController:[self currentWindowController]] autorelease];
	[self addChild:waypointViewController];
	[self setCurrentViewController:waypointViewController];
	[waypointViewController setRepresentedObject:[self representedObject]];
	return [waypointViewController view];
}

- (NSView*) _switchToTrackMapView
{
	PKTrackMapViewController* trackMapViewController = [[[PKTrackMapViewController alloc] initWithNibName:@"trackMapView" bundle:nil windowController:[self currentWindowController]] autorelease];
	[self addChild:trackMapViewController];
	[self setCurrentViewController:trackMapViewController];
	[trackMapViewController setRepresentedObject:[self representedObject]];
	return [trackMapViewController view];
}

- (NSView*) _switchToOverviewView
{
	PKTrackOverviewViewController* overviewViewController = [[[PKTrackOverviewViewController alloc] initWithNibName:@"trackOverviewView" bundle:nil windowController:[self currentWindowController]] autorelease];
	[self addChild:overviewViewController];
	[self setCurrentViewController:overviewViewController];
	[overviewViewController setRepresentedObject:[self representedObject]];
	return [overviewViewController view];
}

- (NSView*) _switchToGraphView
{
	PKTrackGraphViewController* overviewViewController = [[[PKTrackGraphViewController alloc] initWithNibName:@"trackSpeedView" bundle:nil windowController:[self currentWindowController]] autorelease];
	[self addChild:overviewViewController];
	[self setCurrentViewController:overviewViewController];
	[overviewViewController setRepresentedObject:[self representedObject]];
	return [overviewViewController view];
}

@end
