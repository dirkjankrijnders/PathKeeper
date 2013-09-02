//
//  PKTrackMO+RM.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKTrackMO+RM.h"
#import "PKWaypointMO.h"

#import "RMFoundation.h"
#import "RMLatLong.h"
#import "RMMapContents.h"
#import "RMProjection.h"
#import "RMPath.h"

@implementation PKTrackMO(RouteMe)

- (NSArray*) RMProjectedPointsArrayForMapContents:(RMMapContents*)contents
{
	NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:[[self points] count]];
	RMProjectedPoint mercator;
	RMLatLong rmpoint;
	for (PKWaypointMO* point in [self sortedPoints])
	{
		rmpoint.latitude = [[point latitude] floatValue];
		rmpoint.longitude = [[point longitude] floatValue];
		mercator = [[contents projection] latLongToPoint:rmpoint];
		[array addObject:[NSValue value:&mercator withObjCType:@encode(RMProjectedPoint)]];
	}
	return [array autorelease];
};

-(RMPath*) RMPathForContents:(RMMapContents*)contents
{
	RMPath* path = [[RMPath alloc] initWithContents:contents];
    RMProjectedPoint mercator;
    for (NSValue* point in [self RMProjectedPointsArrayForMapContents:contents]) {
        [point getValue:&mercator];
        [path addLineToXY:mercator];
    }
         //    [path setLatLongPoints:[self RMProjectedPointsArrayForMapContents:contents]];
	return [path autorelease];
}

@end
