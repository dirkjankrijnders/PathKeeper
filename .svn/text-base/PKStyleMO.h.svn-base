//
//  PKStyleMO.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@class PKTrackCategory;

@interface PKStyleMO :  NSManagedObject  
{
}

@property (retain) NSString * name;
@property (retain) NSString * id;
@property (retain) NSNumber * linewidth;
@property (retain) NSColor * colour;
@property (retain) NSSet* categories;

- (NSXMLElement*) asKMLNode;


@end

@interface PKStyleMO (CoreDataGeneratedAccessors)
- (void)addCategoriesObject:(PKTrackCategory *)value;
- (void)removeCategoriesObject:(PKTrackCategory *)value;
- (void)addCategories:(NSSet *)value;
- (void)removeCategories:(NSSet *)value;

@end

