//
//  coreDataApplication_AppDelegate.h
//  coreDataApplication
//
//  Created by Dirkjan Krijnders on 7/27/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GPXImportOperation;
@class PKMainWindowController; 
@class PKPreferenceController;
@class PKImportGPSFilesSheetController;

@interface pathKeeper_AppDelegate : NSObject 
{
    NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;

    NSPersistentStoreCoordinator *tilePersistentStoreCoordinator;
    NSManagedObjectModel *tileManagedObjectModel;
    NSManagedObjectContext *tileManagedObjectContext;

	NSPersistentStore* inMemoryStore;
	NSPersistentStore* primaryStore;
//	GPXImportOperation* GPXImporter;
	NSOperationQueue* opController;
	
	IBOutlet NSArrayController* mTrackController; 
	IBOutlet NSArrayController* mMapSourceController;
	NSArrayController* trackListController;
	PKMainWindowController* mMainWindowController;
	
	NSMutableArray* mMapSources;
	NSSortDescriptor* mTrackSortDescriptor;
	
	PKPreferenceController* preferenceController;
	
	IBOutlet NSMenuItem* exportMenuItem;
	PKImportGPSFilesSheetController* _searchAndImportController;
}

@property (retain) NSSortDescriptor* trackSortDescriptor;
@property (retain) NSPersistentStore* primaryStore;
@property (retain, nonatomic) NSArrayController* trackListController;

- (NSString *)applicationSupportFolder;

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (NSPersistentStoreCoordinator *)tilePersistentStoreCoordinator;
- (NSManagedObjectModel *)tileManagedObjectModel;
- (NSManagedObjectContext *) tileManagedObjectContext;

- (NSArrayController*) trackController;
- (NSArrayController*) mapSourceController;
- (NSOperationQueue*) opController;

- (NSPersistentStore*) inMemoryStore;

- (IBAction) saveAction:(id)sender;
- (IBAction) openGPXFile:(id)sender;
- (IBAction) searchAndImport:(id)sender;
- (IBAction) exportToMyPlaces:(id)sender;
- (IBAction) saveGraph:(id)sender;
- (IBAction) print:(id)sender;

- (IBAction) showPreferencePanel:(id)sender;

@end
