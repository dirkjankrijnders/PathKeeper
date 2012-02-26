//
//  PKLibraryOutlineView.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKLibraryOutlineView.h"
#define kPKSmartLibraryItemType @"kPKSmartLibraryItemType"

@implementation PKLibraryOutlineView

- (void) awakeFromNib
{
	[self registerForDraggedTypes:[NSArray arrayWithObjects:kPKSmartLibraryItemType, nil]];
	_menu = nil;
	_PredicateEditSheetCont = nil;
};

- (NSMenu* ) menu
{
	if (_menu == nil)
	{
		_menu = [[NSMenu alloc] initWithTitle:@"Table view context menu"];
		[_menu addItemWithTitle:@"Edit" action:@selector(editPredicate:) keyEquivalent:@""];
	};
	return _menu;
};

- (NSWindow*) PredicateEditSheet
{
	if (!_PredicateEditSheetCont)
		_PredicateEditSheetCont = [[NSWindowController alloc] initWithWindowNibName:@"TrackListPredicateEditor" owner:self];

	return [_PredicateEditSheetCont window];
};
		
- (IBAction) editPredicate:(id)sender
{
	NSInteger row = [self selectedRow];
	[[self delegate] startPredicateEditorSheet:[self itemAtRow:row]];
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
		[self selectRow:row byExtendingSelection:NO];
	
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
	[_PredicateEditSheetCont release];
	[super dealloc];
};
@end
