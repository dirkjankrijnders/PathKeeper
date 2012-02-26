//
//  PKTracksWaypointController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKTracksWaypointController.h"
#import "PKTrackMO.h"

@implementation PKTracksWaypointController

#pragma mark Data Source methods
- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return (item == nil) ? [[nibOwner representedObject] count]: [[item points] count];	
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	BOOL result;
	if (item == nil)
		result = YES;
	else if ([item isKindOfClass:[PKTrackMO class]])
		result = YES;
	else
		result = NO;
	
    return result;
}



- (id)outlineView:(NSOutlineView *)outlineView
			child:(int)index
		   ofItem:(id)item
{
    return (item == nil) ? [[nibOwner representedObject] objectAtIndex:index] : [[item sortedPoints] objectAtIndex:index];
}


- (id)outlineView:(NSOutlineView *)outlineView
objectValueForTableColumn:(NSTableColumn *)tableColumn
		   byItem:(id)item
{
	id result;
	
	if (item == nil)
		result = @"??";
	else if ([item isKindOfClass:[PKTrackMO class]])
	{
		if ([[tableColumn identifier] isEqualToString:@"date"])
			result = [item name];
		else if ([[tableColumn identifier] isEqualToString:@"longitude"])
			result = [(PKTrackMO*) item length];
		else
			result = @"";
	}
	else
		result = [item valueForKey:[tableColumn identifier]];
	
	return result;
}

#pragma mark Delegate methods
- (BOOL) outlineView:(NSOutlineView*)outlineView
	shouldSelectItem:(id)item
{
	if ([item isKindOfClass:[PKTrackMO class]])
		return NO;
	else
		return YES;
}
	
@end