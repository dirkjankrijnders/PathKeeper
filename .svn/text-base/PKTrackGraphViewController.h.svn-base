//
//  PKTrackSpeedViewController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"
#import <CorePlot/CorePlot.h>
#import "PKGraphView.h"

@class PKTrackMO;

@interface PKTrackGraphViewController : XSViewController {
	IBOutlet PKGraphView* graphView;
	
	NSMutableArray* pointControllers;
}

@property (nonatomic, readwrite, retain) NSMutableArray *pointControllers;

- (void) addTrack:(PKTrackMO*)track;
- (void) updateBounds;

@end
