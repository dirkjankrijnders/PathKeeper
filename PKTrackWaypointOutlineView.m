//
//  PKTrackWaypointOutlineView.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKTrackWaypointOutlineView.h"
#import "PKTrackMO.h"
#import "PKWaypointMO.h"

@implementation PKTrackWaypointOutlineView


# pragma mark Context menu
- (IBAction) deleteWaypoints:(id)sender
{
	PKWaypointMO* item;
	unsigned current_index = [[self selectedRowIndexes] firstIndex];
    while (current_index != NSNotFound)
    {
        item = [self itemAtRow:current_index];
		[[item track] removePointsObject:item];
	    current_index = [[self selectedRowIndexes] indexGreaterThanIndex: current_index];
    }
	[self reloadData];
};

- (IBAction) splitTrack:(id)sender
{
	PKWaypointMO* item;
	PKTrackMO* track;
	unsigned current_index = [[self selectedRowIndexes] firstIndex];
	item = [self itemAtRow:current_index];
	track = [self parentForItem:item];
	[track splitAtWaypoint:item];
	[self reloadData];
};

- (NSMenu* ) menu
{
	if (_menu == nil)
	{
		_menu = [[NSMenu alloc] initWithTitle:@"Waypoint view context menu"];
		[_menu addItemWithTitle:@"Delete" action:@selector(deleteWaypoints:) keyEquivalent:@""];
		splitItem = [_menu addItemWithTitle:@"Split track here" action:@selector(splitTrack:) keyEquivalent:@""];
	};
	
	if ([[self selectedRowIndexes] count] > 1)
		[splitItem setEnabled:NO];
	else
		[splitItem setEnabled:YES];
	
	return _menu;
};

- (NSMenu *)menuForEvent:(NSEvent *)theEvent {
	//Find which row is under the cursor
	[[self window] makeFirstResponder:self];
	NSPoint menuPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	int row = [self rowAtPoint:menuPoint];
	
	/* If the item is not selectable don't show the menu */
	if (![[self delegate] outlineView:self shouldSelectItem:[self itemAtRow:row]])
		return nil;
	
	/* Update the table selection before showing menu
	 Preserves the selection if the row under the mouse is selected (to allow for
	 multiple items to be selected), otherwise selects the row under the mouse */
	BOOL currentRowIsSelected = [[self selectedRowIndexes] containsIndex:row];
	if (!currentRowIsSelected)
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    
	
	if ([self numberOfSelectedRows] <=0)
	{
        //No rows are selected, so the table should be displayed with all items disabled
		NSMenu* tableViewMenu = [[self menu] copy];
		int i;
		for (i=0;i<[tableViewMenu numberOfItems];i++)
			[[tableViewMenu itemAtIndex:i] setEnabled:NO];
		return [tableViewMenu autorelease];
	}
	else
		return [self menu];	
};

@end
