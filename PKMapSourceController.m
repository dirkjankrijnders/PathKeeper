//
//  PKMapSourceController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKMapSourceController.h"
#import "pathKeeper_AppDelegate.h"

@implementation PKMapSourceController

@synthesize delegate;
@synthesize displayName;
@synthesize tileManagerName;
@synthesize pixelsPerTile;

+ (NSArray*) scaleArray 
{
	NSArray* metersPerPixel = [NSArray arrayWithObjects:[NSNumber numberWithFloat:156412],
							   [NSNumber numberWithFloat:78206],
							   [NSNumber numberWithFloat:39135.758482 ],
							   [NSNumber numberWithFloat:19567.879241 ],
							   [NSNumber numberWithFloat:9783.939621 ],
							   [NSNumber numberWithFloat:4891.969810 ],
							   [NSNumber numberWithFloat:2445.984905 ],
							   [NSNumber numberWithFloat:1222.992453 ],
							   [NSNumber numberWithFloat:611.496226 ],
							   [NSNumber numberWithFloat:305.748113 ], // Zoomlevel 9
							   [NSNumber numberWithFloat:152.874057 ],
							   [NSNumber numberWithFloat:76.437028 ],
							   [NSNumber numberWithFloat:38.218514 ],
							   [NSNumber numberWithFloat:19.109257 ],
							   [NSNumber numberWithFloat:9.554629 ],
							   [NSNumber numberWithFloat:4.777314 ],
							   [NSNumber numberWithFloat:2.388657 ],
							   [NSNumber numberWithFloat:1.194329 ],
							   [NSNumber numberWithFloat:0.597164 ],nil]; // Zoomlevel 18;
	return metersPerPixel;
};

- (PSTileManager*) tileManager
{
	[self setTileManagerName:@"OSM"];
	if (tileManager == nil)
	{
		NSManagedObjectContext* tileMOC = [(pathKeeper_AppDelegate*)[NSApp delegate] tileManagedObjectContext];
		NSPredicate* namePredicate = [NSPredicate predicateWithFormat:@"name like %@", [self tileManagerName]];
		NSLog(@"Predicate: %@", namePredicate);
		NSFetchRequest* request = [[NSFetchRequest alloc] init];
		NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"PSTileManager" inManagedObjectContext:tileMOC];
		[request setEntity:entityDescription];
		[request setPredicate:namePredicate];
		
		NSError* error = nil;
		NSArray* tileManagers = [tileMOC executeFetchRequest:request error:&error];
		if ([tileManagers count] > 0)
			tileManager = [tileManagers objectAtIndex:0];
		else 
		{
			tileManager = [[PSTileManager alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:tileMOC];
			[tileManager setName:[self tileManagerName]];
			[tileManager setTileSizeX:[NSNumber numberWithInt:256]];
			[tileManager setTileSizeY:[NSNumber numberWithInt:256]];
			
		}
		[tileManager setDelegate:self];
		[request release];
	}
	return tileManager;
};

- (PSTileMO*) tileForLL:(NSPoint)LL atZoomLevel:(NSInteger)level
{
//	double metersPerLatitude  = [[AEConverter distanceFrom:NSMakePoint(0.0, 0.0)  To:NSMakePoint(0.0, 90.0) ] floatValue]/ 90.0;
//	double metersPerLongitude = [[AEConverter distanceFrom:NSMakePoint(0.0, LL.y) To:NSMakePoint(90.0, LL.y)] floatValue] / 90.0;
//	NSLog(@"Row: %f %@, %u", LL.y,[AEConverter distanceFrom:NSMakePoint(0.0, 0.0) To:NSMakePoint(0.0, LL.y)], [self pixelsPerTile]);
	NSPoint xy = [self pointAtLevel:level forLL:LL];
//	NSLog(@"As NSI: %i", row);
	PSTileMO* tile = [[self tileManager] tileAtLevel:level forX:xy.x andY:xy.y]; 
	if (tile == nil)
	{
		tile = [self downloadTileAtLevel:level forX:xy.x andY:xy.y atPoint:LL];
		[tile setPropertyForKey:@"longitude" value:[NSNumber numberWithFloat:LL.x]];
		[tile setPropertyForKey:@"latitude" value:[NSNumber numberWithFloat:LL.y]];
	};

	return tile;
};

- (NSPoint) pointAtLevel:(NSInteger)level forLL:(NSPoint)LL
{
	double metersY = [[AEConverter distanceFrom:NSMakePoint(0.0, 0.0) To:NSMakePoint(0.0, LL.y)] doubleValue];
	double metersX = [[AEConverter distanceFrom:NSMakePoint(0.0, LL.y) To:NSMakePoint(LL.x, LL.y)] doubleValue];
	double metersPerPixelAtLevel = [[[PKMapSourceController scaleArray] objectAtIndex:level] doubleValue];
	double ppT = (double) [self pixelsPerTile];
	//	NSLog(@"%f / %f/ %f",  metersY, metersPerPixelAtLevel, ppT);
	//	NSLog(@"%f", floor(metersY / metersPerPixelAtLevel / ppT));
	int row = (int)floor(metersY / metersPerPixelAtLevel / ppT);
	int col = (int)floor(metersX / metersPerPixelAtLevel / ppT);
	return NSMakePoint(col, row);
};

- (NSPoint) LLAtLevel:(NSInteger)level forX:(NSInteger)col andY:(NSInteger)row
{
	double metersToPole = [[AEConverter distanceFrom:NSMakePoint(0.0, 0.0) To:NSMakePoint(0.0, 90.0)] doubleValue];
	double metersPerPixelAtLevel = [[[PKMapSourceController scaleArray] objectAtIndex:level] doubleValue];
	double ppT = (double) [self pixelsPerTile];
	double metersX = col * metersPerPixelAtLevel * ppT;
	double metersY = row * metersPerPixelAtLevel * ppT;
	double latitude  = metersY / metersToPole * 90;
	double metersToDate = [[AEConverter distanceFrom:NSMakePoint(0.0, latitude) To:NSMakePoint(180.0, latitude)] doubleValue];
	double longitude = metersX / metersToDate * 180;
	return NSMakePoint(longitude, latitude);
};

- (PSTileMO*) downloadTileAtLevel:(NSInteger)level forX:(NSInteger)col andY:(NSInteger)row atPoint:(NSPoint)LL
{
//	NSURL* imageURL = [NSURL fileURLWithPath:@"/Users/dirkjan/Downloads/map-2.png"];
//	NSImage* image = [[[NSImage alloc] initWithContentsOfURL:imageURL] autorelease];
//	NSPoint LL = [self LLAtLevel:level forX:col andY:row];
	NSPoint LL2 = LL; //[self LLAtLevel:level	forX:col+1 andY:row+1];
	NSImage* image = [[NSImage alloc] initWithSize:NSMakeSize([self pixelsPerTile], [self pixelsPerTile])];
	NSString* text = [NSString stringWithFormat:@" Tile @ (%lu, %lu)\n=> (%f, %f)x(%f, %f)\nzl: %li", (long)col, (long)row, LL.x, LL.y, LL2.x, LL2.y, (long)level];
	[image lockFocus];
	[text drawAtPoint:NSMakePoint(10.0, 200.0) withAttributes:nil];
	[image unlockFocus];
//	NSLog(@"Dowloaded: %@", image);
	return [[self tileManager] addTile:image atLevel:level forX:col andY:row];
};

#pragma mark Outline view citizen

-(int) numberOfChildren
{
	return 0;
};

-(bool) isItemExpandable
{
	return NO;
}

@end
