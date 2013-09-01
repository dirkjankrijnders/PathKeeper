// 
//  PKTrackMO.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKTrackMO.h"

#import "AEGPSRecieverMO.h"
#import "PKWaypointMO.h"
#import "PKTrackCategory.h"
#import "PKStyleMO.h"
#import "RMPath.h"
#import "RMMapView.h"

@implementation PKTrackMO 

@dynamic name;
@dynamic startDate;
@dynamic stopDate;
@dynamic readOn;
@dynamic length;
@dynamic GPSReciever;
@dynamic points;
@dynamic categories;

- (NSArray*) sortDescriptors
{
	NSSortDescriptor* sd1 = [[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES] autorelease];
	NSSortDescriptor* sd2 = [[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES] autorelease];
	return [NSArray arrayWithObjects:sd1, sd2, nil];
};

- (NSBezierPath*) path
{
	NSBezierPath* path = [NSBezierPath bezierPath];
	NSPoint p;
	bool first = true;
	
	NSArray* wpts = [[NSArray arrayWithArray:[self valueForKey:@"points"]] sortedArrayUsingDescriptors:[self sortDescriptors]];
	for (NSManagedObject* waypoint in wpts)
	{
		
		p.x = [[waypoint valueForKeyPath:@"longitude"] floatValue];// - 5.2 ) * 100;
		p.y = [[waypoint valueForKeyPath:@"latitude"]  floatValue]; // - 51.0) * 100;
		if (first) {
			first = false;
			[path moveToPoint:p];
		} else 
			[path lineToPoint:p];
	}
	return path;
};

- (NSArray*) sortedPoints
{
    return [[self points] sortedArrayUsingDescriptors:[self sortDescriptors]];
//	return [[NSArray arrayWithArray:[self valueForKey:@"points"]] sortedArrayUsingDescriptors:[self sortDescriptors]];
};

- (void) addDistance:(double)d {
	[self setLength:[NSNumber numberWithDouble:(d/1000 + [[self length] doubleValue])]];
};

- (void) recalculateStatistics:(id)sender
{
	[self setLength:[NSNumber numberWithDouble:0.0]];
	PKWaypointMO* lastTrackWaypoint = nil;
	for (PKWaypointMO* point in [[[self points] allObjects] sortedArrayUsingDescriptors:[self sortDescriptors]])
	{
		[point setSpeed:[NSNumber numberWithInt:0]];
		if (lastTrackWaypoint != nil)
		{
			double d = [point distanceFromTrackWaypoint:lastTrackWaypoint];
			double timeInSec = [[lastTrackWaypoint date] timeIntervalSinceDate:[point date]];
			
			[self addDistance:d];
			[point setSpeed:[[[NSNumber alloc] initWithDouble:(-d / timeInSec * 3.6)] autorelease]];
			[point setPreviousPoint:lastTrackWaypoint];
			[lastTrackWaypoint setNextPoint:point];
		}
		lastTrackWaypoint = point;
	}
	//	[[(NSOperationQueue*) [NSApp delegate] opController] addOperation:[]]
}

- (NSNumber*) averageSpeed
{
	double timeInSec = [[self stopDate] timeIntervalSinceDate:[self startDate]];
	NSNumber* avgSpeed = [[[NSNumber alloc] initWithDouble:[[self length] doubleValue] / timeInSec * 3600] autorelease];	
	return avgSpeed;
};

- (BOOL) isEqualToTrack:(PKTrackMO*)otherTrack
{
	BOOL result = true;
	
	if ([[self points] count] != [[otherTrack points] count]) // Same number of points
	{
		result = false;
	}
	if (![[self startDate] isEqualToDate:[otherTrack startDate]]) // Same start date
	{	
		result = false;
	}
	
	if (![[self stopDate] isEqualToDate:[otherTrack stopDate]]) // Same stop date
	{
		result = false;
	}
	if (result)
		NSLog(@"%@ <=> %@ are equal: %@\n%@", [self name], [otherTrack name], self, otherTrack);
	
	return result;
};

- (void) mergeWithTrack:(PKTrackMO*) otherTrack
{
	[self setName:[[self name] stringByAppendingString:[otherTrack name]]];
	[self setStartDate:[[self startDate] earlierDate:[otherTrack startDate]]];
	[self setStopDate:[[self stopDate] laterDate:[otherTrack stopDate]]];
	NSUInteger orderOffset = [[self points] count] + 1;
	NSSet* points = [otherTrack points];
	[self addPoints:points];
	[otherTrack removePoints:points];
	for (PKWaypointMO* point in points)
		[point setOrder:[NSNumber numberWithInt:([[point order] intValue] + orderOffset)]];
		
	NSSet* cats = [otherTrack categories];
	[otherTrack removeCategories:cats];
	[self addCategories:cats];
	
	[[self managedObjectContext] deleteObject:otherTrack];
	[self recalculateStatistics:nil];
};

- (void) reorderWaypointsByDate
{
	NSUInteger order = 0;
	NSArray* sd = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES] autorelease]];
	for (PKWaypointMO* point in [[[self points] allObjects] sortedArrayUsingDescriptors:sd])
	{
		[point setOrder:[NSNumber numberWithInt:order]];
		order++;
	}
	[self recalculateStatistics:self];
};

- (void) splitAtWaypoint:(PKWaypointMO*) waypoint
{
	NSEntityDescription* trackEntity = [NSEntityDescription entityForName:@"Track"
												   inManagedObjectContext:[self managedObjectContext]];
	PKTrackMO* newTrack = [[PKTrackMO alloc] initWithEntity:trackEntity 
							 insertIntoManagedObjectContext:[self managedObjectContext]];
	NSArray* allWaypoints = [self sortedPoints];
	NSUInteger indexOfSplitWaypoint = [allWaypoints indexOfObject:waypoint];
	NSRange affectedWaypointsRange = NSMakeRange(indexOfSplitWaypoint, [allWaypoints count] - indexOfSplitWaypoint);
	NSArray* affectedWaypoints = [allWaypoints subarrayWithRange:affectedWaypointsRange];
	[newTrack setName:[NSString stringWithFormat:@"Split off of %@", [self name]]];
	[newTrack addPoints:[NSSet setWithArray:affectedWaypoints]];
	[self removePoints:[NSSet setWithArray:affectedWaypoints]];
	[newTrack setReadOn:[self readOn]];
	[newTrack setGPSReciever:[self GPSReciever]];
	[newTrack setStartDate:[[affectedWaypoints objectAtIndex:0] date]];
	[newTrack setStopDate:[[affectedWaypoints objectAtIndex:([affectedWaypoints count] -1)] date]];
	[self setStopDate:[[allWaypoints objectAtIndex:(indexOfSplitWaypoint -1)] date]];
	[newTrack setCategories:[self categories]];
	[newTrack recalculateStatistics:self];
	[self recalculateStatistics:self];
};

#pragma mark KML Export methods

- (NSXMLElement*) asKMLNodeWithPoints:(BOOL)withPoints
{
	NSMutableString* coordinates = [[NSMutableString alloc] init];
	
	for (PKWaypointMO* wp in [[[self points] allObjects] sortedArrayUsingDescriptors:[self sortDescriptors]])
		[coordinates appendFormat:@"%@,%@,%@ ",[wp longitude],[wp latitude],[wp height]];
	
	NSXMLElement* trackElement = [[[NSXMLElement alloc] initWithName:@"Placemark"] autorelease];
	NSXMLElement* nameElement = [[NSXMLElement alloc] initWithName:@"name" stringValue:[self name]];
	NSXMLElement* lineStringElement = [[NSXMLElement alloc] initWithName:@"LineString"];
	NSXMLElement* coorElement = [[NSXMLElement alloc] initWithName:@"coordinates" stringValue:coordinates];
	NSXMLElement* lineStyleElement = [[NSXMLElement alloc] initWithName:@"styleUrl" stringValue:[self KMLStyle]];
	NSXMLElement* timeSpanElement = [[NSXMLElement alloc] initWithName:@"TimeSpan"];
	NSXMLElement* tsBeginElement = [[NSXMLElement alloc] initWithName:@"begin" stringValue:[[self startDate] descriptionWithCalendarFormat:@"%Y-%m-%dT%H:%M:%SZ" timeZone:[NSTimeZone timeZoneWithName:@"ZULU"] locale:nil]];
	NSXMLElement* tsEndElement = [[NSXMLElement alloc] initWithName:@"end" stringValue:[[self stopDate] descriptionWithCalendarFormat:@"%Y-%m-%dT%H:%M:%SZ" timeZone:[NSTimeZone timeZoneWithName:@"ZULU"] locale:nil]];
	
	[timeSpanElement addChild:tsBeginElement];
	[timeSpanElement addChild:tsEndElement];
	[trackElement addChild:timeSpanElement];
	[trackElement addChild:nameElement];
	[lineStringElement addChild:coorElement];
	[trackElement addChild:lineStringElement];
	[trackElement addChild:lineStyleElement];
	
	[nameElement release];
	[coorElement release];
	[lineStringElement release];
	[coordinates release];
	[lineStyleElement release];
	[timeSpanElement release];
	[tsBeginElement release];
	[tsEndElement release];
	return trackElement;
};

- (NSXMLElement*) asKMLFileAtPath:(NSString*)filePath templateKMLPath:(NSURL*)templateKML
{
	NSString* filename = [NSString stringWithFormat:@"%@-%@.kml", [self name], [self startDate]];
	NSXMLElement* kmlRootElement = [[[NSXMLElement alloc] initWithName:@"kml"] autorelease];
	NSXMLElement* documentNode = [[[NSXMLElement alloc] initWithName:@"Document"] autorelease];
	[kmlRootElement addChild:documentNode];
	[kmlRootElement addAttribute:[NSXMLNode attributeWithName:@"xmlns" stringValue:@"http://earth.google.com/kml/2.2"]];
	
	NSXMLElement* fileNetworkLink = [[[NSXMLElement alloc] initWithName:@"NetworkLink"] autorelease];
	NSXMLElement* fileLink = [[[NSXMLElement alloc] initWithName:@"Link"] autorelease];
	NSXMLElement* fileHRef = [[[NSXMLElement alloc] initWithName:@"href" stringValue:filename] autorelease];
	NSXMLElement* fileNetworkLinkName = [[[NSXMLElement alloc] initWithName:@"name" stringValue:[self name]] autorelease];
	[fileLink addChild:fileHRef];
	[fileNetworkLink addChild:fileLink];
	[fileNetworkLink addChild:fileNetworkLinkName];

	
	/* Create XML file */
	NSXMLDocument* trackDoc = [[NSXMLDocument alloc] initWithRootElement:kmlRootElement];

//	NSString * style = [NSString stringWithString:@"#lineStyle"];
	for (PKTrackCategory* cat in [self categories])
	{
		if ([cat style])
			//			NSLog(@"cat style: %@",[cat style]);
			[documentNode addChild:[[cat style] asKMLNode]];
	};
//	[documentNode addChild:[[self categor] asKMLNode]];
	[documentNode addChild:[self asKMLNodeWithPoints:YES]];

	/* Write out the KML Document */
	NSData* xmlData = [trackDoc XMLData];
	NSError* error;
	
	// if (![xmlData writeToFile:[googleEarthASPath stringByAppendingPathComponent:@"myplaces.kml"] atomically:YES]) {
	if (![xmlData writeToFile:[filePath stringByAppendingPathComponent:filename] options:NSAtomicWrite error:&error]) {
        NSBeep();
        NSLog(@"Could not write document out: %@", error);
    }
	[trackDoc release];
	return fileNetworkLink;
};

- (NSString*) KMLStyle
{
	NSString * style = @"#lineStyle";
	for (PKTrackCategory* cat in [self categories])
	{
		if ([cat style])
			//			NSLog(@"cat style: %@",[cat style]);
			style = [[cat style] id];
	};
	return style;
};

- (NSColor*) colour
{
	NSColor * style = [NSColor blackColor];
	for (PKTrackCategory* cat in [self categories])
	{
		if ([cat style])
			//			NSLog(@"cat style: %@",[cat style]);
			style = [[cat style] colour];
	};
	return [style colorUsingColorSpaceName:@"NSDeviceRGBColorSpace"];
};

#pragma mark Outline view citizen

-(int) numberOfChildren
{
	return 0;
};

- (NSString*) displayName
{
	return [self name];
}

-(bool) isItemExpandable
{
	return NO;
}


@end
