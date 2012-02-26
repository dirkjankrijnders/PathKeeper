//
//  PKTrackOutlineRoot.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKOutlineRoot.h"


@implementation PKOutlineRoot

@synthesize displayName;
@synthesize arrayController;

- (int) numberOfChildren
{
	NSLog(@"PKOutlineRoot, ac: %@, numberOfChildren: %i", arrayController, [[arrayController arrangedObjects] count]);  
	return [[arrayController arrangedObjects] count] ;
};

- (id) childAtIndex:(int)index
{
	NSLog(@"Requested index: %i, returning: %@", index, [[arrayController arrangedObjects] objectAtIndex:index]);
	return [[arrayController arrangedObjects] objectAtIndex:index];
}

- (bool) isItemExpandable
{
	return YES;
};

@end
