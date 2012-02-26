//
//  PSTileMO.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PSTileMO : NSManagedObject {
	NSImage* imageData;
}
@property (retain) NSString * imageHash;
@property (retain) NSDate * lastPing;
@property (retain) NSNumber * positionX;
@property (retain) NSNumber * positionY;
@property (retain) NSNumber * sizeX;
@property (retain) NSNumber * sizeY;
@property (retain) NSSet* properties;

- (void) setImage:(NSImage*)aImage;
- (NSImage*) image;

- (NSMutableString*) cacheLocation;

- (void)draw;

- (void)setPropertyForKey:(NSString*)aKey value:(NSNumber*)aValue;
- (NSNumber*)propertyForKey:(NSString*)aKey;
@end

// coalesce these into one @interface PSTileMO (CoreDataGeneratedAccessors) section
@interface PSTileMO (CoreDataGeneratedAccessors)
@property (retain) NSSet* child;
@property (retain) PSTileMO * parent;
@property (retain) NSManagedObject * tileGroup;
- (void)addChildObject:(PSTileMO *)value;
- (void)removeChildObject:(PSTileMO *)value;
- (void)addChild:(NSSet *)value;
- (void)removeChild:(NSSet *)value;
- (void)addPropertiesObject:(NSManagedObject *)value;
- (void)removePropertiesObject:(NSManagedObject *)value;
- (void)addProperties:(NSSet *)value;
- (void)removeProperties:(NSSet *)value;

@end

