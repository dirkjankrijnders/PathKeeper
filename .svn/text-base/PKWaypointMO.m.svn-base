// 
//  PKWaypoint.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKWaypointMO.h"
#import "AEConverter.h"
#import "PKTrackMO.h"

@implementation PKWaypointMO

@dynamic date;
@dynamic latitude;
@dynamic longitude;
@dynamic nextPoint;
@dynamic previousPoint;
@dynamic speed;
@dynamic height;
@dynamic track;
@dynamic order;

- (double) distanceFromTrackWaypoint:(PKWaypointMO*)fromTrackWaypoint {
	NSPoint fromLL = { [fromTrackWaypoint.longitude floatValue],  [fromTrackWaypoint.latitude floatValue]};
	NSPoint toLL = { [self.longitude floatValue],  [self.latitude floatValue]};
	return [[AEConverter distanceFrom:fromLL To:toLL] doubleValue];
}

- (double) speedFromTrackWaypoint:(PKWaypointMO*)fromTrackWaypoint{
	double distance = [self distanceFromTrackWaypoint:fromTrackWaypoint];
	double timeInterval = [self.date timeIntervalSinceDate:fromTrackWaypoint.date];
	return distance/timeInterval * 3.6;
}
@end
