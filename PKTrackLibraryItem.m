//
//  PKTrackLibraryItem.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKTrackLibraryItem.h"


@implementation PKTrackLibraryItem

@synthesize displayName;
@synthesize filterPredicate;

- (id) initWithName:(NSString*)name andPredicate:(NSPredicate*)predicate
{
	[super init];
	
	[name retain];
	displayName = name;
	
	[predicate retain];
	filterPredicate = predicate;
	return self;
}



- (void) dealloc
{
	[displayName release];
	[filterPredicate release];
	[super dealloc];
}

#pragma mark Outline view citizen

-(int) numberOfChildren
{
	return 0;
};

/*- (NSString*) displayName
{
	return [self displayName];
}*/

-(bool) isItemExpandable
{
	return NO;
}

@end
