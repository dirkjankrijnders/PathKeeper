//
//  PSTileManager.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class PSTileGroup;
@class PSTileMO;

@interface PSTileManager :  NSManagedObject  
{
	NSManagedObjectContext* tileMOC;
	id delegate;
}

@property (retain) NSNumber * tileSizeY;
@property (retain) NSNumber * tileSizeX;
@property (retain) NSString * name;
@property (retain) NSSet* tileGroups;
@property (assign) id delegate;

- (NSManagedObjectContext*) tileMOC;
- (PSTileMO*) addTile:(NSImage*)aTileImage atLevel:(NSInteger)aLevel forX:(NSInteger)aX andY:(NSInteger)aY;
- (PSTileMO*) tileAtLevel:(NSInteger)aLevel forX:(NSInteger)aX andY:(NSInteger)aY;

@end

@interface PSTileManager (CoreDataGeneratedAccessors)
- (void)addTileGroupsObject:(PSTileGroup *)value;
- (void)removeTileGroupsObject:(PSTileGroup *)value;
- (void)addTileGroups:(NSSet *)value;
- (void)removeTileGroups:(NSSet *)value;

@end

