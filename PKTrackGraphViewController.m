//
//  PKTrackSpeedViewController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKTrackGraphViewController.h"
#import "PKTrackMO.h"
#import "PKWaypointMO.h"


@implementation PKTrackGraphViewController

@synthesize pointControllers;

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle windowController:(XSWindowController *)windowController;
{
	if (![super initWithNibName:name bundle:bundle windowController:windowController])
		return nil;

	self.representedObject = [NSSet set];
	self.pointControllers = [NSMutableArray array];

	// Make sure the view is loaded
	[self view];
	
	return self;
}


- (void) setRepresentedObject:(id)rO
{
	for (NSArrayController* track in self.pointControllers)
		[self removeTrack:track];
		
	if ([rO isKindOfClass:[NSSet class]])
		[super setRepresentedObject:rO];
	else if ([rO isKindOfClass:[NSArray class]])
		[super setRepresentedObject:[NSSet setWithArray:rO]];
	else if ([rO isMemberOfClass:[PKTrackMO class]])
		[super setRepresentedObject:[NSSet setWithObject:rO]];
	else
		[super setRepresentedObject:[NSSet set]];

	self.pointControllers = [NSMutableArray arrayWithCapacity:[[self representedObject] count]];
	for (PKTrackMO* track in [self representedObject])
		[self addTrack:track];
		
	[self updateBounds];
};

- (void) updateBounds
{
	NSDate* maximumDate = [NSDate distantPast];
	NSDate* minimumDate = [NSDate distantFuture];
	
	float maxSpeed = 0;
	for (NSArrayController* track in pointControllers)
	{
		maximumDate = [[track valueForKeyPath:@"arrangedObjects.@max.date"] laterDate:maximumDate];
		minimumDate = [[track valueForKeyPath:@"arrangedObjects.@min.date"] earlierDate:minimumDate];
		maxSpeed = ([[track valueForKeyPath:@"arrangedObjects.@max.speed"] floatValue] > maxSpeed ? [[track valueForKeyPath:@"arrangedObjects.@max.speed"] floatValue] : maxSpeed);
	}
	NSLog(@"Track from %@ to %@, maxSpeed: %f", minimumDate, maximumDate, maxSpeed);
	[graphView setStartTime:minimumDate andStopTime:maximumDate];
	[graphView setYMax:maxSpeed];
};

- (void) addTrack:(PKTrackMO*)track 
{
	if (track != nil) {
		NSArrayController* ac = [[NSArrayController alloc] init];
		[ac setManagedObjectContext:[[NSApp delegate] managedObjectContext]];
		[ac setEntityName:@"PKTrackMO"];
		[ac setContent:[track points]];
		[ac setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES] autorelease]]];
		[self.pointControllers addObject:ac];
		NSColor* color_ = [[track colour] colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
		NSLog(@"%@", color_);
		CGColorRef color = CPTCreateCGColorFromNSColor(color_);
		[graphView addLinePlotForTrack:ac withColor:[CPTColor colorWithCGColor:color]];
		[ac release];
	}
};

- (void) removeTrack:(NSArrayController*)track
{
	[graphView removeLinePlotForTrack:track];
}

@end
