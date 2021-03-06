//
//  PKSourceOutlineViewController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKSourceOutlineViewController.h"
#import "PKOutlineRoot.h"
//#import "PKTrackLibraryItem.h"
//#import "PKSmartLibraryItem.h"
#import "SmartGroup.h"
#import "PKTrackMO.h"
#import "pathKeeper_AppDelegate.h"

#define kPKSmartLibraryItemType @"kPKSmartLibraryItemType"

@implementation PKSourceOutlineViewController

@synthesize importedGroup;
@synthesize libraryGroup;
@synthesize canRemoveGroup;
@synthesize filterPredicate;

#pragma mark init/dealloc

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle windowController:(XSWindowController *)windowController
{
	if (![super initWithNibName:name bundle:bundle windowController:windowController])
	{
		return nil;
	}

	[sourceOutlineView registerForDraggedTypes:[NSArray arrayWithObjects:kPKSmartLibraryItemType, kPKTrackType, nil]];
	
//	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//	[nc addObserver:self selector:@selector(SmartLibraryItemAdded:) name:@"NSManagedObjectContextObjectsDidChangeNotification" object:[[NSApp delegate] managedObjectContext]];

	// Make sure the user can't undo the addition of the "temporary" smartgroups Library and Imported
	[self setupImportedGroup];
	[self setupLibraryGroup];
    NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
	[context processPendingChanges];
	[[context undoManager] removeAllActions];
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(searchFieldChanged:) name:@"searchFieldContentsChanged" object:nil];
	
	[self setFilterPredicate:nil];
	
	return self;
};


-(void) dealloc
{
	//	[libraryController release];
	[super dealloc];
};

- (void) viewDidLoad
{
	NSArrayController* tc = [(pathKeeper_AppDelegate*)[NSApp delegate] trackController];
	[tc bind:@"contentSet" toObject:libraryController withKeyPath:@"selection.tracks" options:nil];
	
}
#pragma mark  Setup Defaults group

- (void) setupImportedGroup
{
    
    // ensure there is a default "Library" group in the store
    NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
    id inMemoryStore = [(pathKeeper_AppDelegate*)[NSApp delegate] inMemoryStore];
    
    // create a new one and save it
    importedGroup = [[NSEntityDescription insertNewObjectForEntityForName:@"ManualGroup" inManagedObjectContext:context] retain];
    [importedGroup setName: @"Imported Tracks"];
//    [importedGroup setGroupImageName:@"image_group_shared"];
    [context assignObject:importedGroup toPersistentStore:inMemoryStore];
//    [importedGroup setPredicate:[NSPredicate predicateWithValue:YES]];
	
    // Save it
    [context save:nil];    
//    [[importedGroup fetchRequest] setAffectedStores:[NSArray arrayWithObject:inMemoryStore]];
}


/**
 Initializes the "Library" group in the display.  This item is a "Smart" 
 group that is stored in an in_memory store (the library never needs to be saved since
 it should always be available and you can't edit its predicate)
 */

- (void) setupLibraryGroup
{
	
    // ensure there is a default "Library" group in the store
    NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
    id inMemoryStore = [[NSApp delegate] inMemoryStore];
	
    // create a new one and save it
    libraryGroup = [[NSEntityDescription insertNewObjectForEntityForName:@"SmartGroup" inManagedObjectContext:context] retain];
    [libraryGroup setName: @"Library"];
    [libraryGroup setGroupImageName:@"image_group_library"];
//    [libraryGroup setValue:[NSNumber numberWithInt:9] forKeyPath:@"priority"];
	[libraryGroup setOrder:[NSNumber numberWithInt:1]];
    [context assignObject:libraryGroup toPersistentStore:inMemoryStore];
    [libraryGroup setPredicate:[NSPredicate predicateWithValue:YES]];
	
    // Save it
	NSError* error = nil;
	[context save:&error];
    if (error)
		NSLog(@"Fout? : %@", error);
    [[libraryGroup fetchRequest] setAffectedStores:[NSArray arrayWithObject:[[NSApp delegate] primaryStore]]];
}

- (void) checkSmartLibraryItems
{
	NSError* err;
//	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"parent == nil"];
	NSManagedObjectContext* moc = [[NSApp delegate] managedObjectContext];
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:moc]];
//	[request setPredicate:predicate];
	NSArray* items = [moc executeFetchRequest:request error:&err];
	NSSortDescriptor* sortByOrder = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES]; 
	
	NSInteger ii = 1;
	for (PKSmartLibraryItem* item in [items sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByOrder]])
	{
		[item setOrder:[NSNumber numberWithInt:ii]];
		ii++; ii++; //Leave "gaps" to allow for reordering"
	};
	[request release];
	[sortByOrder release];
};

- (NSArray*) SmartLibraryItemSortDescriptor
{
	return [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES] autorelease]]; 
};

#pragma mark Group management

- (IBAction) addNewSmartGroup:(id)sender
{
	NSManagedObjectContext* context = [[NSApp delegate] managedObjectContext];
	
	SmartGroup* newGroup = [NSEntityDescription insertNewObjectForEntityForName:@"SmartGroup" inManagedObjectContext:context];
	[newGroup setName:@"New smartgroup"];
	[newGroup setPredicate:[NSPredicate predicateWithFormat:@"categories.name contains \"\""]];
}

- (IBAction) addNewManualGroup:(id)sender
{
	NSManagedObjectContext* context = [[NSApp delegate] managedObjectContext];
	
	SmartGroup* newGroup = [NSEntityDescription insertNewObjectForEntityForName:@"ManualGroup" inManagedObjectContext:context];
	[newGroup setName:@"New group"];
}

- (IBAction) removeGroup:(id)sender
{
	NSManagedObjectContext* context = [[NSApp delegate] managedObjectContext];
	
	id group = [[libraryController selectedObjects] lastObject];
    if ((group != [self libraryGroup]) && (group != [self importedGroup])) {
        [context deleteObject:group];
    } else {
        NSBeep();   
    }	
};

- (BOOL) updateCanRemoveGroup
{
	BOOL ret = true;
	
	return ret;
};

#pragma mark Predicate sheet management

- (NSWindow*) predicateEditorSheet
{
	return predicateEditorSheet;
};

- (IBAction) startPredicateEditorSheet:(id)sender
{
	tempPKSmartLibraryItem = [sender representedObject];
	[itemTitleField setStringValue:[[sender representedObject] name]];
	if (![[sender representedObject] predicate])
	{
		[sender setPredicate:[NSPredicate predicateWithFormat:@"\"\" in categories.name"]];
	};
	[predicateEditor setObjectValue:[[sender representedObject] predicate]];
	[NSApp beginSheet:predicateEditorSheet 
	   modalForWindow:[(XSWindowController*)[self windowController] window]
		modalDelegate:self
	   didEndSelector:@selector(doneEditingPredicate:returnCode:contextInfo:)
		  contextInfo:NULL];
};

- (IBAction) endPredicateEditorSheet:(id)sender
{
	[tempPKSmartLibraryItem setPredicate:[predicateEditor predicate]];
	[tempPKSmartLibraryItem setName:[itemTitleField stringValue]];
	[NSApp endSheet:predicateEditorSheet];
};


- (void) doneEditingPredicate:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[predicateEditorSheet orderOut:sheet];
};


- (BOOL) outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	return YES;
};

- (void) outlineViewSelectionDidChange:(NSNotification *)notification
{
	Group* selectedGroup = [[sourceOutlineView itemAtRow:[sourceOutlineView selectedRow]] representedObject];

	[self setCanRemoveGroup:((selectedGroup != importedGroup) && (selectedGroup != libraryGroup))];
};

#pragma mark drag 'n drop

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[[[items objectAtIndex:0] representedObject] objectID] URIRepresentation]];
	[pboard declareTypes:[NSArray arrayWithObject:kPKSmartLibraryItemType] owner:self];
    [pboard setData:data forType:kPKSmartLibraryItemType];
	return YES;
};

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    // Add code here to validate the drop

    return NSDragOperationEvery;
};

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index
{
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:kPKSmartLibraryItemType];
    NSURL* MOUrl = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	NSManagedObjectContext* moc = [[NSApp delegate] managedObjectContext];
	NSManagedObjectID *moID = [[moc persistentStoreCoordinator]
							   managedObjectIDForURIRepresentation:MOUrl];
	// assume moID non-nil...

	PKSmartLibraryItem *mo = (PKSmartLibraryItem*) [moc objectWithID:moID];

	[mo setOrder:[NSNumber numberWithInt:(index * 2)]];
    // Move the specified row to its new location...
	
	[self checkSmartLibraryItems];
	[libraryController rearrangeObjects];

	return YES;
}

#pragma mark Search
- (void)searchFieldChanged:(NSNotification*)notification
{
	[self setFilterPredicate:[NSPredicate predicateWithFormat:@"name like[c] %@", [[notification userInfo] valueForKey:@"value"]]];
	NSLog(@"Should update filterPredicate: %@", filterPredicate);
};


@end
