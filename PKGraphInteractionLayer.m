//
//  PKGraphInteractionLayer.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKGraphInteractionLayer.h"


@implementation PKGraphInteractionLayer

@synthesize plotSpace;

NSString* PK_POINT_INTERACTION_WINDOW_NIB = @"pointInteractionWindow";

- (id) init
{
	self = [super init];
	if (self != nil) {
		dateTransformer = [[PKDateToNumberTransformer alloc] init];
		pointInteractionWindow = [[NSWindowController alloc] initWithWindowNibName:PK_POINT_INTERACTION_WINDOW_NIB owner:self];
	}
	return self;
}

- (void) dealloc
{
	[dateTransformer release];
	[super dealloc];
}

- (void) pointingDeviceDownAtPoint:(CGPoint)point
{
	NSDecimal plotPoint[2];
	[plotSpace plotPoint:plotPoint forPlotAreaViewPoint:point];
	double speedFloat = CPTDecimalDoubleValue(plotPoint[1]);
	NSString* speedString = [NSString stringWithFormat:@"%f", speedFloat];
	NSLog(@"Mouse down! at %@, %@", 
		  [dateTransformer reverseTransformedValue:[NSNumber numberWithInteger:CPTDecimalIntegerValue(plotPoint[0])]],
		  speedString);
	[[pointInteractionWindow window] makeKeyAndOrderFront:self];
	[time setStringValue:[NSString stringWithFormat:@"%@", [dateTransformer reverseTransformedValue:[NSNumber numberWithInteger:CPTDecimalIntegerValue(plotPoint[0])]]]];
	[speedField setStringValue:@"test"];
	[speedField setStringValue:speedString];
}

@end
