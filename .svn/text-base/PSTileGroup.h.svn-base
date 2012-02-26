//
//  PSTileGroup.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class PSTileMO;

@interface PSTileGroup :  NSManagedObject  
{
}

@property (retain) NSNumber * level;
@property (retain) NSSet* tiles;
@property (retain) NSManagedObject * tileManager;

- (void) addOrReplaceTile:(PSTileMO*)aTile forX:(NSInteger)aX andY:(NSInteger)aY;
- (PSTileMO*) tileForX:(NSInteger)aX andY:(NSInteger)aY;

@end

@interface PSTileGroup (CoreDataGeneratedAccessors)
- (void)addTilesObject:(PSTileMO *)value;
- (void)removeTilesObject:(PSTileMO *)value;
- (void)addTiles:(NSSet *)value;
- (void)removeTiles:(NSSet *)value;

@end

