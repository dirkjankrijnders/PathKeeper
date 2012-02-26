//
//  PKWaypoint.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
@class PKTrackMO;

@interface PKWaypointMO :  NSManagedObject  
{
}

@property (retain) NSDate * date;
@property (retain) NSNumber * latitude;
@property (retain) NSNumber * longitude;
@property (retain) NSNumber * height;
@property (retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * order;

@property (retain) PKWaypointMO * nextPoint;
@property (retain) PKWaypointMO * previousPoint;
@property (retain) PKTrackMO * track;

- (double) distanceFromTrackWaypoint:(PKWaypointMO*)fromTrackWaypoint;
- (double) speedFromTrackWaypoint:(PKWaypointMO*)fromTrackWaypoint;

@end


