//
//  PKTrackMapViewController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"

@class RMMapView;
@class RMPath;

@interface PKTrackMapViewController : XSViewController {
	IBOutlet RMMapView* trackView;
	NSMutableArray* paths;
}

- (NSSet*) currentTracks;
- (IBAction) zoomOut:(id)sender;
- (IBAction) zoomIn:(id)sender;
- (IBAction) moveEast:(id)sender;
- (IBAction) moveSouth:(id)sender;
- (IBAction) moveWest:(id)sender;
- (IBAction) moveNorth:(id)sender;


@end
