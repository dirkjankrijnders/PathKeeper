//
//  PKTrackListTableView.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKTrackListTableView.h"
#import "PKTrackMO.h"

@implementation PKTrackListTableView

- (void) awakeFromNib
{
	[self registerForDraggedTypes:[NSArray arrayWithObject:kPKTrackType] ];
	_menu = nil;
};

- (NSMenu* ) menu
{
	if (_menu == nil)
	{
		_menu = [[NSMenu alloc] initWithTitle:@"Table view context menu"];
		unichar bs = NSBackspaceCharacter;
		NSString* backspace = [NSString stringWithCharacters:&bs length:1];
		[_menu addItemWithTitle:@"Delete" action:@selector(removeCurrentRow:) keyEquivalent:backspace];
		[_menu addItemWithTitle:@"Merge" action:@selector(mergeSelectedTracks:) keyEquivalent:@""];
		[_menu addItemWithTitle:@"Reorder waypoints by date" action:@selector(reorderSelectedTracks:) keyEquivalent:@""];
	};
	return _menu;
};

- (IBAction) removeCurrentRow:(id)sender
{
//	[[self undoManager] beginUndoGrouping];
	if ([[self selectedRowIndexes] count] > 1)
		[[self undoManager] setActionName:@"Delete Tracks"];
	else
		[[self undoManager] setActionName:@"Delete Track"];

	[trackListArrayController removeObjectsAtArrangedObjectIndexes:[self selectedRowIndexes]];
	
//	[[self undoManager] endUndoGrouping];
			
};

- (IBAction) reorderSelectedTracks:(id)sender
{
	NSArray* tracks = [trackListArrayController selectedObjects];
	for (PKTrackMO* track in tracks)
		[track reorderWaypointsByDate];
}

- (IBAction) mergeSelectedTracks:(id)sender
{
	NSArray* tracks = [trackListArrayController selectedObjects];
	NSMutableIndexSet* indices = [[NSMutableIndexSet alloc] init];
	[indices addIndexes:[self selectedRowIndexes]];
		
	if ([tracks count] < 2)
	{	
		NSLog(@"Cannot merge less then two tracks");
		return;
	}
	
	PKTrackMO* firstTrack = [[trackListArrayController arrangedObjects] objectAtIndex:[indices firstIndex]]; 
	[indices removeIndex:[indices firstIndex]];
	NSArray* otherTracks = [[trackListArrayController arrangedObjects] objectsAtIndexes:indices];
	for (PKTrackMO* otherTrack in otherTracks)
		[firstTrack mergeWithTrack:otherTrack];

	[trackListArrayController removeObjectsAtArrangedObjectIndexes:indices];

	[indices release];
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent {
	//Find which row is under the cursor
	[[self window] makeFirstResponder:self];
	NSPoint menuPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	int row = [self rowAtPoint:menuPoint];
	
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

- (void) dealloc
{
	[_menu release];
	[super dealloc];
};

#pragma mark drap and drop

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
	NSArray* items = [[trackListArrayController arrangedObjects] objectsAtIndexes:rowIndexes];
	NSMutableArray* trackIDs = [NSMutableArray arrayWithCapacity:[items count]];
		
	for (id track in items)
		[trackIDs addObject:[[[track representedObject] objectID] URIRepresentation]];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:trackIDs];
	[pboard declareTypes:[NSArray arrayWithObject:kPKTrackType] owner:self];
    [pboard setData:data forType:kPKTrackType];
	return YES;
};

#pragma mark key handling

- (void)keyDown:(NSEvent *)theEvent {
	unichar keyChar = 0;
	
	// Input handling
	NSString* characters = [theEvent characters];
	if ([characters length] != 1)
		return;
	
	keyChar = [characters characterAtIndex:0];
	// Handles the backspace pressing in the track list table
	if (keyChar == NSBackspaceCharacter || keyChar == NSDeleteCharacter)
	{
		[self removeCurrentRow:nil];
		return;
	}
	
	// Pass the event down the responder chain
	[super keyDown:theEvent];
}

@end
