// 
//  PSTileManager.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PSTileManager.h"
#import "PSTileGroup.h"
#import "pathKeeper_AppDelegate.h"

@implementation PSTileManager 

@dynamic tileSizeY;
@dynamic tileSizeX;
@dynamic name;
@dynamic tileGroups;
@synthesize delegate;

- (NSManagedObjectContext*) tileMOC
{
	if (tileMOC == nil)
		tileMOC = [(pathKeeper_AppDelegate*)[NSApp delegate] tileManagedObjectContext];
	
	return tileMOC;
};

- (PSTileGroup*) groupForLevel:(NSInteger)aLevel
{
	NSSet* groups = [self tileGroups];
	PSTileGroup* storeGroup = nil;
	
	for (PSTileGroup* group in groups)
	{
		if ([[group level] integerValue] == aLevel)
			storeGroup = group;
	}
	
	if (storeGroup == nil)
	{
		storeGroup = [NSEntityDescription insertNewObjectForEntityForName:@"PSTileGroup" inManagedObjectContext:[self tileMOC]];
		[storeGroup setLevel:[NSNumber numberWithInt:aLevel]];
		[storeGroup setTileManager:self];
		[self addTileGroupsObject:storeGroup];
	}
	return storeGroup;
}

- (PSTileMO*) addTile:(NSImage*)aTileImage atLevel:(NSInteger)aLevel forX:(NSInteger)aX andY:(NSInteger)aY
{
//	PSTileGroup* storeGroup = ;
	
	PSTileMO* tile = [NSEntityDescription insertNewObjectForEntityForName:@"PSTile" inManagedObjectContext:[self tileMOC]];
	[tile setImage:aTileImage];
	[[self groupForLevel:aLevel] addOrReplaceTile:tile forX:aX andY:aY];
	return tile;
};

- (PSTileMO*) tileAtLevel:(NSInteger)aLevel forX:(NSInteger)aX andY:(NSInteger)aY
{
	return [[self groupForLevel:aLevel] tileForX:aX andY:aY];
};
@end
