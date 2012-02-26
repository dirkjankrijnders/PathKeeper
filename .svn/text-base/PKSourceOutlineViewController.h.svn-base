//
//  PKSourceOutlineViewController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"

@class PKSmartLibraryItem;
@class Group;
@class SmartGroup;

@interface PKSourceOutlineViewController : XSViewController {
	NSArray*		rootItems;
	IBOutlet NSWindow*		predicateEditorSheet;
	IBOutlet NSPredicateEditor* predicateEditor;
	IBOutlet NSOutlineView*		sourceOutlineView;
	SmartGroup* tempPKSmartLibraryItem;
	SmartGroup* libraryGroup;
	SmartGroup* importedGroup;
	
	IBOutlet NSTextField* itemTitleField;
	
	IBOutlet NSTreeController* libraryController;
	
	IBOutlet BOOL canRemoveGroup;

	NSPredicate* filterPredicate;
}

@property (retain) SmartGroup* libraryGroup;
@property (retain) SmartGroup* importedGroup;
@property (assign) BOOL canRemoveGroup;

// Setup the standard groups
- (void) setupLibraryGroup;
- (void) setupImportedGroup;

// Predicate sheet stuff
- (NSWindow*) predicateEditorSheet;
- (IBAction) startPredicateEditorSheet:(id)sender;
- (IBAction) endPredicateEditorSheet:(id)sender;

// Group management
- (IBAction) addNewSmartGroup:(id)sender;
- (IBAction) addNewManualGroup:(id)sender;
- (IBAction) removeGroup:(id)sender;

- (void)searchFieldChanged:(NSNotification*)notification;

@property (retain, nonatomic) NSPredicate* filterPredicate;

@end
