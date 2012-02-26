//
//  PKGraphView.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 2/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKGraphView.h"
#import "CPDateFormatter.h"
#import "PKDateToNumberTransformer.h"
#import "PKGraphInteractionLayer.h"


@implementation PKGraphView

@synthesize linePlot, graph;


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

		// Create graph
		graph = [[CPTXYGraph alloc] initWithFrame:NSRectToCGRect(frame) xScaleType:CPTScaleTypeLinear yScaleType:CPTScaleTypeLinear];
		graph.frame = NSRectToCGRect(frame);

		
		// Plot area
		CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithGenericGray:0.6] endingColor:[CPTColor colorWithGenericGray:0.9]];
		gradient.angle = 90.0;
		graph.plotArea.fill = [CPTFill fillWithGradient:gradient]; 

		[self setLayer:graph];
		[self setWantsLayer:YES];

		[graph release];
		
		graph.paddingTop = 20.;
		graph.paddingLeft = 60.0;
		graph.paddingRight = 20.0;
		graph.paddingBottom = 60.0;

		// Setup plot space
		CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
		plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
		plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
		
		// Axes
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
		
		CPTLineStyle *majorLineStyle = [CPTLineStyle lineStyle];
		majorLineStyle.lineCap = kCGLineCapRound;
		majorLineStyle.lineColor = [CPTColor blackColor];
		majorLineStyle.lineWidth = 2.0f;
		
		CPTLineStyle *minorLineStyle = [CPTLineStyle lineStyle];
		minorLineStyle.lineColor = [CPTColor blackColor];
		minorLineStyle.lineWidth = 2.0f;
		
		axisSet.xAxis.majorIntervalLength = [[NSDecimalNumber numberWithFloat:500.f] decimalValue];
		axisSet.xAxis.constantCoordinateValue = [[NSDecimalNumber decimalNumberWithString:@"0.0"] decimalValue];
		axisSet.xAxis.minorTicksPerInterval = 0;
		axisSet.xAxis.majorTickLineStyle = majorLineStyle;
		axisSet.xAxis.minorTickLineStyle = minorLineStyle;
		axisSet.xAxis.axisLineStyle = majorLineStyle;
		axisSet.xAxis.minorTickLength = 7.0f;
		[axisSet.xAxis setTitle:@"Date / Time"];
		axisSet.xAxis.titleOffset = 30.0f;
//		axisSet.xAxis.titleLocation = CPDecimalFromString(@"1197379500");
		axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
		CPDateFormatter* dateFormatter = [[[CPDateFormatter alloc] init] autorelease];;
		axisSet.xAxis.labelFormatter = dateFormatter;
		[dateFormatter.dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		axisSet.yAxis.majorIntervalLength = [[NSDecimalNumber numberWithFloat:10.0] decimalValue];
		axisSet.yAxis.minorTicksPerInterval = 5;
		axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
		axisSet.yAxis.constantCoordinateValue = [[NSDecimalNumber decimalNumberWithString:@"0.0"] decimalValue];
		axisSet.yAxis.majorTickLineStyle = majorLineStyle;
		axisSet.yAxis.minorTickLineStyle = minorLineStyle;
		axisSet.yAxis.axisLineStyle = majorLineStyle;
		axisSet.yAxis.minorTickLength = 7.0f;
		[axisSet.yAxis setTitle:@"Speed [km/h]"];
		axisSet.yAxis.titleOffset = 40.0f;
		
		plotSpace.allowsUserInteraction = YES;
		[self setHostedLayer:[PKGraphInteractionLayer layer]];
		[(PKGraphInteractionLayer*)[self hostedLayer] setPlotSpace:plotSpace];
    }
    return self;
}

- (void) setFrame:(NSRect)rect
{
	[super setFrame:rect];
	[graph setFrame:NSRectToCGRect(rect)];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
}

- (void) setStartTime:(NSDate*)startTime andStopTime:(NSDate*)stopTime
{
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	axisSet.yAxis.constantCoordinateValue = [[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromFloat([startTime timeIntervalSince1970])] decimalValue];
	axisSet.xAxis.labelingOrigin = [[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromFloat([startTime timeIntervalSince1970])] decimalValue];
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([startTime timeIntervalSince1970]) length:CPTDecimalFromFloat([stopTime timeIntervalSinceDate:startTime])];
	NSLog(@"Set xRange to %@", plotSpace.xRange);
	NSDecimal titleLocation, temp;
	titleLocation = CPTDecimalFromFloat(0.5f);
	temp = plotSpace.xRange.length;
	NSDecimalMultiply(&titleLocation, &titleLocation, &temp , NSRoundPlain);
	temp = plotSpace.xRange.location;
	NSDecimalAdd(&titleLocation, &temp, &titleLocation, NSRoundPlain);
	axisSet.xAxis.titleLocation = titleLocation;

	[graph setNeedsDisplay];
	
//	[self setHostedLayer:[CPLayer layer]];
}

- (void) setYMax:(float)max
{
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(max)];
	NSLog(@"Set yRange to %@", plotSpace.yRange);
	NSDecimal titleLocation, temp;
	titleLocation = CPTDecimalFromFloat(0.5f);
	temp = plotSpace.yRange.length;
	NSDecimalMultiply(&titleLocation, &titleLocation, &temp , NSRoundPlain);
	CPTXYAxisSet *axisSet = (CPTXYAxisSet*) graph.axisSet;
	axisSet.yAxis.titleLocation = titleLocation;

	[graph setNeedsDisplay];
	
}

- (void) addLinePlotForTrack:(NSArrayController*)track {
	[self addLinePlotForTrack:track withColor:[[CPTColor blueColor] colorWithAlphaComponent:1]];
};

- (void) addLinePlotForTrack:(NSArrayController*)track withColor:(CPTColor*)lineColor {
	self.linePlot = [[[CPTScatterPlot alloc] init] autorelease];
	linePlot.identifier = @"test-plot";
	linePlot.dataLineStyle.lineWidth = 2.f;
	linePlot.dataLineStyle.lineCap = kCGLineCapRound;
	linePlot.dataLineStyle.lineJoin = kCGLineJoinRound;
	linePlot.dataLineStyle.lineColor = [[CPTColor blueColor] colorWithAlphaComponent:1]; //[[CPColor redColor] colorWithAlphaComponent:0.7]lineColor;
	[graph addPlot:linePlot];
	[linePlot bind:CPTScatterPlotBindingXValues toObject:track withKeyPath:@"arrangedObjects.date" options:[NSDictionary dictionaryWithObject:@"PKDateToNumberTransformer" forKey:@"NSValueTransformerNameBindingOption"]];
	[linePlot bind:CPTScatterPlotBindingYValues toObject:track withKeyPath:@"arrangedObjects.speed" options:nil];
}

- (void) removeLinePlotForTrack:(NSArrayController*)track
{
	[graph removePlotWithIdentifier:track];
}

@end
