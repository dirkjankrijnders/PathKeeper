//
//  PKMapSourceController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PSTileManager.h"
#import "PSTileMO.h"
#import "AEConverter.h"

@interface PKMapSourceController : NSObject {
	PSTileManager*	tileManager;
	NSString*		displayName;
	NSString*		tileManagerName;
	id				delegate;
	NSUInteger		pixelsPerTile;
}

@property (retain) NSString* tileManagerName; 
@property (retain) NSString* displayName;
@property (assign) id delegate;
@property (assign) NSUInteger pixelsPerTile;

+ (NSArray*) scaleArray;

- (NSPoint) pointAtLevel:(NSInteger)level forLL:(NSPoint)LL;
- (NSPoint) LLAtLevel:(NSInteger)level forX:(NSInteger)col andY:(NSInteger)row; 

- (PSTileMO*) tileForLL:(NSPoint)LL atZoomLevel:(NSInteger)level;
- (PSTileMO*) downloadTileAtLevel:(NSInteger)level forX:(NSInteger)col andY:(NSInteger)row atPoint:(NSPoint)LL;

- (NSSet*) tilesInRect:(NSRect)mapRect atZoomLevel:(NSInteger)level;
@end
