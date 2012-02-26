//
//  trackMapView.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PKTrackMapViewController;

@interface trackMapView : NSView {
	IBOutlet PKTrackMapViewController*	dataSource;
}

- (NSRect) boundsFromPath:(NSBezierPath*) path;
- (void)handleTrackSelectionChange:(id)arg;

- (NSBezierPath*) scaleMeasure;

@end
