//
//  PKGraphView.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>


@interface PKGraphView : CPTGraphHostingView {
	CPTXYGraph *graph;
	CPTScatterPlot *linePlot;
}

@property (nonatomic, readwrite, retain) CPTScatterPlot* linePlot;
@property (nonatomic, readwrite, retain) CPTXYGraph* graph;

- (void) setStartTime:(NSDate*)startTime andStopTime:(NSDate*)stopTime;
- (void) setYMax:(float)max;

- (void) addLinePlotForTrack:(NSArrayController*)track;
- (void) addLinePlotForTrack:(NSArrayController*)track withColor:(CPTColor*)lineColor;

@end
