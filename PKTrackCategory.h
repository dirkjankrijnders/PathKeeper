//
//  PKTrackCategory.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 9/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class PKTrackMO;
@class PKStyleMO;

@interface PKTrackCategory :  NSManagedObject  
{
}

@property (retain) NSString * name;
@property (retain) NSNumber * hide;
@property (retain) NSSet* tracks;
@property (retain) PKStyleMO * style;

@end

@interface PKTrackCategory (CoreDataGeneratedAccessors)
- (void)addTracksObject:(PKTrackMO *)value;
- (void)removeTracksObject:(PKTrackMO *)value;
- (void)addTracks:(NSSet *)value;
- (void)removeTracks:(NSSet *)value;

@end

