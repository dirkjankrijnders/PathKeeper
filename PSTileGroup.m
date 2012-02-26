// 
//  PSTileGroup.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PSTileGroup.h"

#import "PSTileMO.h"

@implementation PSTileGroup 

@dynamic level;
@dynamic tiles;
@dynamic tileManager;

- (void) addOrReplaceTile:(PSTileMO*)aTile forX:(NSInteger)aX andY:(NSInteger)aY
{
	[aTile setPositionX:[NSNumber numberWithInt:aX]];
	[aTile setPositionY:[NSNumber numberWithInt:aY]];
	[aTile setTileGroup:self];
	NSLog(@"aTile: %@", aTile);
	NSPredicate* location = [NSPredicate predicateWithFormat:@"positionX == %i AND positionY == %i", aX, aY];
	NSSet* existingTile = [[self tiles] filteredSetUsingPredicate:location];
	if ([existingTile count] != 0)
		[self removeTiles:existingTile];

	[self addTilesObject:aTile];
}

- (PSTileMO*) tileForX:(NSInteger)aX andY:(NSInteger)aY
{
	NSPredicate* location = [NSPredicate predicateWithFormat:@"positionX == %i AND positionY == %i", aX, aY];
	NSSet* existingTile = [[self tiles] filteredSetUsingPredicate:location];
	NSLog(@"tileForX,Y: %@",existingTile);
	
	return [existingTile anyObject];
}
@end
