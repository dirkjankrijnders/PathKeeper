//
//  PKTrackLibraryItem.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PKTrackLibraryItem : NSObject {
	NSString* displayName;
	NSPredicate* filterPredicate;
}

- (id) initWithName:(NSString*)name andPredicate:(NSPredicate*)predicate;

@property (retain) NSString* displayName;
@property (retain) NSPredicate* filterPredicate;


@end
