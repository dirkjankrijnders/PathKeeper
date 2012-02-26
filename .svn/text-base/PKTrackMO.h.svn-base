//
//  PKTrackMO.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 7/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class AEGPSRecieverMO;
@class PKWaypointMO;
@class PKTrackCategory;
@class RMPath;
@class RMMapView;

#define kPKTrackType			@"kPKTrackType"


@interface PKTrackMO :  NSManagedObject  
{
	double		dist;
}

@property (retain) NSString * name;
@property (retain) NSDate * startDate;
@property (retain) NSDate * stopDate;
@property (retain) NSDate * readOn;
@property (retain) NSNumber * length;
@property (retain) AEGPSRecieverMO * GPSReciever;
@property (retain) NSSet* points;
@property (retain) NSSet* categories;

- (NSNumber*) averageSpeed;
- (NSBezierPath*) path;
- (NSArray*) sortedPoints;

- (void) addDistance:(double)d;
- (void) recalculateStatistics:(id)sender;
- (NSXMLElement*) asKMLNodeWithPoints:(BOOL)withPoints;
- (NSXMLElement*) asKMLFileAtPath:(NSString*)filePath  templateKMLPath:(NSURL*)templateKML;
- (NSString*) KMLStyle;

- (NSColor*) colour;

- (BOOL) isEqualToTrack:(PKTrackMO*)otherTrack;
- (void) mergeWithTrack:(PKTrackMO*) otherTrack;
- (void) splitAtWaypoint:(PKWaypointMO*) waypoint;
- (void) reorderWaypointsByDate;

@end


@interface PKTrackMO (CoreDataGeneratedAccessors)
- (void)addPointsObject:(PKWaypointMO *)value;
- (void)removePointsObject:(PKWaypointMO *)value;
- (void)addPoints:(NSSet *)value;
- (void)removePoints:(NSSet *)value;

- (void)addCategoriesObject:(PKTrackCategory *)value;
- (void)removeCategoriesObject:(PKTrackCategory *)value;
- (void)addCategories:(NSSet *)value;
- (void)removeCategories:(NSSet *)value;
@end

