//
//  trackMapView.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "trackMapView.h"
#import "PKTrackMO.h"
#import "AEConverter.h"
#import "PKTrackMapViewController.h"
#import "pathKeeper_AppDelegate.h"
#import "RMMapView.h"

@implementation trackMapView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
//		[[[NSApp delegate] trackController] addObserver:self forKeyPath:@"selectedObjects" options:NSKeyValueObservingOptionNew context:NULL];
		
		
    }
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTrackSelectionChange:) name:@"representedObject" object:dataSource];

    return self;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
	NSLog(@"Recieved notification");
	[self drawRect:[self bounds]];
};

- (void)handleTrackSelectionChange:(id)arg
{
	[self setNeedsDisplay:YES];
	NSLog(@"Recieved notification");
}

- (void)drawRect:(NSRect)rect {
//	NSArray* Tracks = [[[NSApp delegate] trackController] selectedObjects];
	NSSet* Tracks = [dataSource currentTracks];
	[[NSColor redColor] set];
	NSMutableArray* paths = [NSMutableArray arrayWithCapacity:[Tracks count]];
	NSRect pathRect = [self boundsFromPath:[[Tracks anyObject] path]];
	CGRect newBounds = *(CGRect*)&pathRect; //NSZeroRect;
	for (PKTrackMO* track in Tracks)
	{
		NSBezierPath* path = [track path];
		pathRect = [self boundsFromPath:path];
	
		newBounds = CGRectUnion(newBounds, *(CGRect*)&pathRect);
		[paths addObject:path];
	}
//	NSRect myBounds = [self boundsFromPath:[paths objectAtIndex:0]];
//	double pixelsPerLongtitude = self.frame.size.width / newBounds.size.width;
//	double pixelsPerLatitude = self.frame.size.height / newBounds.size.height;
//	NSURL* imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://tile.openstreetmap.org/cgi-bin/export?bbox=%f,%f,%f,%f&scale=680000&format=png",newBounds.origin.x,newBounds.origin.y,newBounds.origin.x+newBounds.size.width, newBounds.origin.y+newBounds.size.height]];
	NSRect mapRect =*(NSRect*)&newBounds;
	NSURL* imageURL = [NSURL fileURLWithPath:@"/Users/dirkjan/Downloads/map-2.png"];
	NSImage* backgroundMap = [[[NSImage alloc] initWithContentsOfURL:imageURL] autorelease];
	NSAffineTransform* xform = [NSAffineTransform transform];
	[xform translateXBy:newBounds.origin.x yBy:newBounds.origin.y];
//	[xform scaleXBy:pixelsPerLongtitude yBy:pixelsPerLatitude];
//	[xform concat];
	[self setBounds:*(NSRect*)&newBounds];
	NSLog(@"mapRect: %@", NSStringFromRect( mapRect));
//	mapRect.origin = 
	[backgroundMap drawInRect:mapRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
	
	for (NSBezierPath* path in paths)
	{
	/*	[xform scaleXBy:100 yBy:100];
		[xform translateXBy:-5.19*100 yBy:-52.2*100];
		
		[xform concat];*/
		[path setLineWidth:0.001];
//		[self setBounds:[self boundsFromPath:path]];
		[path stroke];
	}
	[[self scaleMeasure] stroke];
	
}

- (NSBezierPath*) scaleMeasure
{
	NSBezierPath* scaleMeasurePath = [[[NSBezierPath alloc] init] autorelease];
	double pixelsPerLongtitude = self.frame.size.width / self.bounds.size.width;
	double pixelLength = 300.0f;
	NSLog(@"Bounds: %@, frame: %@, ration: %f", NSStringFromRect([self bounds]), NSStringFromRect([self frame]), pixelsPerLongtitude);
	NSPoint leftPoint  = NSMakePoint(self.bounds.origin.x + (10 / pixelsPerLongtitude), self.bounds.origin.y + (100 / pixelsPerLongtitude));
	NSPoint rightPoint = NSMakePoint(self.bounds.origin.x + ((pixelLength + 10) / pixelsPerLongtitude), self.bounds.origin.y + (100 / pixelsPerLongtitude));
	NSNumber*lengthInM = [AEConverter distanceFrom:leftPoint To:rightPoint];
	double MperPixel = [lengthInM doubleValue] / pixelLength;
	AEDistance niceRoundNumber = [AEConverter niceRoundDistanceFor:[lengthInM doubleValue]];
	pixelLength = niceRoundNumber.value * MperPixel;
	rightPoint = NSMakePoint(self.bounds.origin.x + ((pixelLength + 10) / pixelsPerLongtitude), self.bounds.origin.y + (100 / pixelsPerLongtitude));
	[scaleMeasurePath moveToPoint:leftPoint];
	[scaleMeasurePath lineToPoint:rightPoint];
	NSLog(@"Scale length: %@, becomes: %f, unit: %@", lengthInM, niceRoundNumber.value * MperPixel, [AEConverter shortUnitForDistance:niceRoundNumber]);
	[scaleMeasurePath setLineWidth:0.001];
	NSLog(@"%@", NSStringFromRect([scaleMeasurePath bounds]));
//	NSFont* font1= [NSFont fontWithName:@"Helvetica" size:9.0];
	NSString* label = [NSString stringWithFormat:@"%f %@",niceRoundNumber.value, [AEConverter shortUnitForDistance:niceRoundNumber]];
	NSLog(@"%@", label);
	return scaleMeasurePath;
};


- (NSRect) boundsFromPath:(NSBezierPath*) path
{
	NSRect ownFrame = [self frame];
	double ownRatio = ownFrame.size.height / ownFrame.size.width;
	NSRect pathFrame = [path bounds]; 
	double pathRatio = pathFrame.size.height / pathFrame.size.width;
	NSRect returnFrame = pathFrame;
	if (pathRatio > ownRatio) // Widen frame
	{
		returnFrame.size.width = pathFrame.size.height / ownRatio;
	} else {
		returnFrame.size.height = pathFrame.size.width * ownRatio;
	}
	returnFrame.size.width  = 1.2 * returnFrame.size.width;
	returnFrame.size.height = 1.2 * returnFrame.size.height;
	NSPoint ownCenter = {pathFrame.origin.x + (pathFrame.size.width / 2), pathFrame.origin.y + (pathFrame.size.height / 2)};
	returnFrame.origin.x = ownCenter.x - (returnFrame.size.width / 2);
	returnFrame.origin.y = ownCenter.y - (returnFrame.size.height / 2);
	
	return returnFrame;
}

- (void) dealloc
{
	[[(pathKeeper_AppDelegate*)[NSApp delegate] trackController] removeObserver:self forKeyPath:@"selectedObjects"];
	[super dealloc];
};

@end
