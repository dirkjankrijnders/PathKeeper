//
//  PKDetailViewController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"
#import "XSWindowController.h"

@interface PKDetailViewController : XSViewController {
	IBOutlet NSView*					contentView;
	IBOutlet NSSegmentedControl*		segmentedControl;

	XSViewController *					mCurrentViewController;
	XSWindowController *				mCurrentWindowController;
}

@property (retain) XSViewController *  currentViewController;
@property (retain) XSWindowController * currentWindowController;

- (IBAction) selectView:(id)sender;

- (NSView*) _switchToWaypointView;
- (NSView*) _switchToTrackMapView;
- (NSView*) _switchToOverviewView;
- (NSView*) _switchToGraphView;

@end
