//
//  PKGraphInteractionLayer.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "PKDateToNumberTransformer.h"


@interface PKGraphInteractionLayer : CPTLayer {
	CPTPlotSpace* plotSpace;
	PKDateToNumberTransformer* dateTransformer;
	NSWindowController* pointInteractionWindow;
	
	IBOutlet NSTextField* time;
	IBOutlet NSTextField* speedField;
	IBOutlet NSTextField* longitude;
	IBOutlet NSTextField* latitude;
}

- (void) pointingDeviceDownAtPoint:(CGPoint)point;

@property (assign) CPTPlotSpace* plotSpace;

@end
