//
//  coreDataApplication_AppDelegate.m
//  coreDataApplication
//
//  Created by Dirkjan Krijnders on 7/27/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

#import "pathKeeper_AppDelegate.h"
#import "GPXImportOperation.h"
#import "PKKMLExport-perTrack.h"
#import "PKMainWindowController.h"
#import "PKMainViewController.h"
//#import "PKMapSourceController.h"
#import "PKPreferenceController.h"
#import "PKImportGPSFilesSheetController.h"
#import "PKExportPluginManager.h"
#import "PKExportPluginOperation.h"
#import "PKTrackGraphViewController.h"
#import "PKDetailViewController.h"
#import "NSError+CoreDataDebug.h"

@implementation pathKeeper_AppDelegate

@synthesize trackSortDescriptor = mTrackSortDescriptor;
@synthesize primaryStore;
@synthesize trackListController;
/**
 Returns the support folder for the application, used to store the Core Data
 store file.  This code uses a folder named "coreDataApplication" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportFolder {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"pathKeeper"];
}


/**
 Creates, retains, and returns the managed object model for the application 
 by merging all of the models found in the application bundle.
 */

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	//    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	//	NSLog(@"%@", [[NSBundle bundleForClass:[self class]] pathForResource:@"MyDocument" ofType:@"mom"]);
	NSURL* modelURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"MyDocument" ofType:@"mom"]];
	//	NSLog(@"ModelURL: %@", modelURL);
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSManagedObjectModel *)tileManagedObjectModel {
	
    if (tileManagedObjectModel != nil) {
        return tileManagedObjectModel;
    }
	
    // tileManagedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	NSURL* modelURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"PSTileManager" ofType:@"mom"]];
	NSLog(@"ModelURL: %@", modelURL);
	tileManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return tileManagedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The folder for the store is created, 
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
        //[fileManager createDirectoryAtPath:applicationSupportFolder attributes:nil];
        [fileManager createDirectoryAtURL:[NSURL URLWithString:applicationSupportFolder] withIntermediateDirectories:YES attributes:nil error:&error];
    }
	
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"pathKeeperLibrary.sql"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSMutableDictionary *persistentStoreOptions;
	persistentStoreOptions = [[NSMutableDictionary alloc] init];
	[persistentStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:persistentStoreOptions error:&error]){
        [[NSApplication sharedApplication] presentError:error];
    }    
	[self setPrimaryStore:[[persistentStoreCoordinator persistentStores] objectAtIndex:0]];
	
	[persistentStoreOptions release];
    return persistentStoreCoordinator;
}

- (NSPersistentStoreCoordinator *) tilePersistentStoreCoordinator {
	
    if (tilePersistentStoreCoordinator != nil) {
        return tilePersistentStoreCoordinator;
    }
	
    NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
        [fileManager createDirectoryAtURL:[NSURL URLWithString:applicationSupportFolder] withIntermediateDirectories:YES attributes:nil error:&error];
    }
	//	NSManagedObjectModel* model = [self tileManagedObjectModel];
	
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"pathKeeperTileLibrary.sql"]];
    tilePersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self tileManagedObjectModel]];
	
	NSMutableDictionary *persistentStoreOptions;
	persistentStoreOptions = [[NSMutableDictionary alloc] init];
	[persistentStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	
    if (![tilePersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:persistentStoreOptions error:&error]){
        [[NSApplication sharedApplication] presentError:error];
    }    
	
	[persistentStoreOptions release];
    return tilePersistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectContext *) tileManagedObjectContext {
	
    if (tileManagedObjectContext != nil) {
        return tileManagedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self tilePersistentStoreCoordinator];
    if (coordinator != nil) {
        tileManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [tileManagedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return tileManagedObjectContext;
}

- (NSPersistentStore*) inMemoryStore
{
	//	return primaryStore;
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if ((inMemoryStore == nil) && (coordinator != nil)) {
        inMemoryStore = [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    }
    
    return inMemoryStore;
};

/**
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.  Any encountered errors
 are presented to the user.
 */

- (IBAction) saveAction:(id)sender {
	
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
		NSLog(@"Error while saving: %@, userinfo: %@", error, [error userInfo]);
        [[NSApplication sharedApplication] presentError:error];
    }
    if (![[self tileManagedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	
    NSError *error;
    int reply = NSTerminateNow;
    
	if ([[[self opController] operations] count] > 0) {
		NSLog(@"Quiting while task are still running!");
		for (AEOperation* op in [[self opController] operations])
			NSLog(@"%@", op);
		reply = NSTerminateCancel;
	}
	
    if (managedObjectContext != nil) {
        if ([managedObjectContext commitEditing]) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
				
                // This error handling simply presents error information in a panel with an 
                // "Ok" button, which does not include any attempt at error recovery (meaning, 
                // attempting to fix the error.)  As a result, this implementation will 
                // present the information to the user and then follow up with a panel asking 
                // if the user wishes to "Quit Anyway", without saving the changes.
				
                // Typically, this process should be altered to include application-specific 
                // recovery steps.  
				
				NSLog(@"Error while saving: %@, userinfo: %@", error, [error userInfo]);
                BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
				
                if (errorResult == YES) {
                    reply = NSTerminateCancel;
                } 
				
                else {
					
                    int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", nil);
                    if (alertReturn == NSAlertAlternateReturn) {
                        reply = NSTerminateCancel;	
                    }
                }
            }
        }
		
		if (tileManagedObjectContext != nil) {
			if ([tileManagedObjectContext commitEditing]) {
				if ([tileManagedObjectContext hasChanges] && ![tileManagedObjectContext save:&error]) {
					
					// This error handling simply presents error information in a panel with an 
					// "Ok" button, which does not include any attempt at error recovery (meaning, 
					// attempting to fix the error.)  As a result, this implementation will 
					// present the information to the user and then follow up with a panel asking 
					// if the user wishes to "Quit Anyway", without saving the changes.
					
					// Typically, this process should be altered to include application-specific 
					// recovery steps.  
					
					BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
					
					if (errorResult == YES) {
						reply = NSTerminateCancel;
					} 
					
					else {
						
						int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", nil);
						if (alertReturn == NSAlertAlternateReturn) {
							reply = NSTerminateCancel;	
						}
					}
				}
			} 
		}
        else {
            reply = NSTerminateCancel;
        }
    }
    
    return reply;
}

#pragma mark Non-template functions

- (NSError *)application:(NSApplication *)theApplication willPresentError:(NSError *)error
{
    // Log the error to the console for debugging
    NSLog(@"Application will present error:\n%@", [error debugDescription]);
    return error;
}

#pragma mark Window management

- (void)awakeFromNib {
	// make the main window controller with main window nib file
	mMainWindowController = [[PKMainWindowController alloc] initWithWindowNibName:@"mainWindow"];
	[[mMainWindowController window] makeMainWindow];
	[[mMainWindowController window] makeKeyAndOrderFront:self];
	window = [mMainWindowController window];
	[mMainWindowController setManagedObjectContext:[self managedObjectContext]];
	// the app controller wants to know if the user closes the main window by hitting cmd-w or with the close button on the window
	// it registers to get notified of this event
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMainWindowWillClose:) name:NSWindowWillCloseNotification object:[mMainWindowController window]];
	NSSortDescriptor* sd = [[[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES] autorelease];
	[[self trackController] setSortDescriptors:[NSArray arrayWithObject:sd]];  
	//	[self setTrackSortDescriptor:sd];
	//	NSWindowController* wc = [[NSWindowController alloc] initWithWindowNibName:@"test"];
	//	[wc showWindow:self];
	_searchAndImportController = nil;
	
	PKExportPluginManager* pluginManager = [PKExportPluginManager shared];
	NSMenu* exportMenu = [exportMenuItem submenu];
	for (id<PKExportPluginProtocol> plugin in [pluginManager loadedPlugins])		
		[exportMenu addItemWithTitle:[plugin name] action:@selector(export:) keyEquivalent:@""]; 
};


- (IBAction)toggleMainWindowOpen:(id)theSender
{
	if(mMainWindowController!=nil)
	{
		NSWindow * aMainWindow = [mMainWindowController window];
		[aMainWindow performClose:self];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:aMainWindow];
		[mMainWindowController release];
		mMainWindowController = nil;
	}
	else
	{
		mMainWindowController = [[PKMainWindowController alloc] initWithWindowNibName:@"mainWindow"];
		[[mMainWindowController window] makeMainWindow];
		[[mMainWindowController window] makeKeyAndOrderFront:self];
		// the app controller wants to know if the user closes the main window by hitting cmd-w or with the close button on the window
		// it registers to get notified of this event
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMainWindowWillClose:) name:NSWindowWillCloseNotification object:[mMainWindowController window]];
		
	}
}

- (void)handleMainWindowWillClose:(NSNotification*)theNotification
{
	// if the window is closed by the user using cmd-w or the close button on the window
	// release the window controller
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:[mMainWindowController window]];
	[mMainWindowController release];
	mMainWindowController = nil;
}

- (BOOL)validateMenuItem:(NSMenuItem*)theMenuItem
{
	if([theMenuItem action] == @selector(toggleMainWindowOpen:))
	{
		// make sure the menu item's state
		// reflects whether the window is open or not
		
		if(mMainWindowController!=nil)
			[theMenuItem setState:1];
		else
			[theMenuItem setState:0];
		return YES;
	}
	if([theMenuItem action] == @selector(openGPXFile:))
		return YES;
	if([theMenuItem action] == @selector(exportToMyPlaces:))
		return YES;
	if([theMenuItem action] == @selector(showPreferencePanel:))
		return YES;
	if([theMenuItem action] == @selector(searchAndImport:))
		return YES;
	if([theMenuItem action] == @selector(export:))
		return YES;
	if([theMenuItem action] == @selector(saveGraph:))
		return YES;
	if([theMenuItem action] == @selector(print:))
		return YES;
	NSLog(@"%@", theMenuItem);
	if ([[theMenuItem title] isEqual: @"New GPS Reciever"])
		return YES;
	
	return NO;
}


- (NSOperationQueue*)opController
{
	if (opController == nil)
		opController = [[NSOperationQueue alloc] init];
	
	return opController;
};


- (NSArrayController*) trackController
{
	//	NSLog(@"App delegate returning trackController: %@", mTrackController);
	return mTrackController;
}

- (NSArrayController*) mapSourceController
{
	return mMapSourceController;
};

- (void) setupMapSources
{
/*	PKMapSourceController* mapSource = [[[PKMapSourceController alloc] init] autorelease];
	[mapSource setPixelsPerTile:(NSUInteger)256];
	[mapSource setDisplayName:@"Openstreetmaps"];
	[mapSource tileForLL:NSMakePoint(52.0, 4.0) atZoomLevel:11];
	[mMapSources addObject:mapSource];*/
};

- (NSMutableArray*) mapSources
{
	if (mMapSources == nil)
	{
		mMapSources = [[NSMutableArray alloc] init];
		[self setupMapSources];
	}
	return mMapSources;
};

- (void) setMapSources:(NSMutableArray*)aMapSources
{
	[mMapSources release];
	mMapSources = aMapSources;
	[mMapSources retain];
};

#pragma mark Menu actions
- (void)saveGraph:(id)sender
{
	PKDetailViewController* detailViewController = [[(PKMainWindowController*)[window windowController] mainViewController] detailViewController];
	if ([[detailViewController currentViewController] isKindOfClass:[PKTrackGraphViewController class]])
	{
		//[detailViewController 
		NSSavePanel *pdfSavingDialog = [NSSavePanel savePanel];
		[pdfSavingDialog setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
		
		if ( [pdfSavingDialog runModal] == NSOKButton )
		{
			NSData *dataForPDF = [[(PKGraphView*)[[detailViewController currentViewController] view] graph] dataForPDFRepresentationOfLayer];
			[dataForPDF writeToURL:[pdfSavingDialog URL] atomically:NO];
		}
	}
}


- (void)print:(id)sender {
	PKDetailViewController* detailViewController = [[(PKMainWindowController*)[window windowController] mainViewController] detailViewController];
	if ([[detailViewController currentViewController] isKindOfClass:[PKTrackGraphViewController class]])
	{
		
		[[NSPrintOperation printOperationWithView:(PKGraphView*)[[detailViewController currentViewController] view]] runOperation];
	}
}

- (void)export:(id)sender
{
	NSLog(@"Export: %@", sender);
	NSMutableArray* trackIDs = [NSMutableArray array];
	for (PKTrackMO* track in [trackListController selectedObjects])
		[trackIDs addObject:[track objectID]];
	
	NSObject<PKExportPluginProtocol>* plugin;
	PKExportPluginManager* pluginManager = [PKExportPluginManager shared];
	for (plugin in [pluginManager loadedPlugins])
	{
		if ([[sender title] compare:[plugin name]] == NSOrderedSame)
			break;
	}
	//	NSLog(@"Plugin: %@ exporting: %@", [plugin name], trackIDs);
	NSManagedObjectContext* MOContext = [self managedObjectContext];
	NSError* error = nil;
	if (![MOContext save:&error])
	{
		NSLog(@"Error while saving: %@", error);
		return;
	}
	
	PKExportPluginOperation* pluginExporter = [[PKExportPluginOperation  alloc] initWithURL:nil andMOContext:MOContext];
	[pluginExporter setPlugin:plugin];
	[pluginExporter setTrackObjectIDs:trackIDs];
	[[self opController] addOperation:pluginExporter];
	[pluginExporter release];
	
}

- (void)openGPXFile:(id)sender
{
	int result;
    NSArray *fileTypes = [NSArray arrayWithObject:@"gpx"];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	
    [oPanel setAllowsMultipleSelection:YES];
    [oPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    [oPanel setAllowedFileTypes:fileTypes];
    result = [oPanel runModal]; //ForDirectory:NSHomeDirectory() file:nil types:fileTypes];
	[[NSNotificationCenter defaultCenter] addObserver:mMainWindowController
											 selector:@selector(updateManagedObjectContext:)
												 name:NSManagedObjectContextDidSaveNotification object:nil];
    if (result == NSOKButton) {
        NSArray *filesToOpen = [oPanel URLs];
        for (NSURL *aFile in filesToOpen) {
			
			NSLog(@"Document MO: %@", [self managedObjectContext]);
			NSManagedObjectContext* MOContext = [self managedObjectContext];
			GPXImportOperation* GPXImporter = [[GPXImportOperation alloc] initWithURL:aFile andMOContext:MOContext];
			[[self opController] addOperation:GPXImporter];
			[GPXImporter autorelease];
		}
    }
}

-(void) exportToMyPlaces:(id)sender
{
	NSManagedObjectContext* MOContext = [self managedObjectContext];
	NSError* error = nil;
	if (![MOContext save:&error])
	{
		NSLog(@"Error while saving: %@", error);
		return;
	}
	
	PKKMLExportPerTrack* KMLExporter = [[PKKMLExportPerTrack  alloc] initWithURL:nil andMOContext:MOContext];
	[[self opController] addOperation:KMLExporter];
	[KMLExporter release];
};

- (IBAction) showPreferencePanel:(id)sender
{
	if (!preferenceController)
		preferenceController = [[PKPreferenceController alloc] init];
	
	[preferenceController showWindow:self];
};

- (void) doneSearchAndImportSheet:(NSWindow*)sheet returnCode:(BOOL)r contextInfo:(id)c
{
};

- (IBAction) searchAndImport:(id)sender
{
	if (!_searchAndImportController)
		_searchAndImportController = [[PKImportGPSFilesSheetController alloc] initWithWindowNibName:@"importGPSFiles"];
	[NSApp beginSheet:[_searchAndImportController window] 
	   modalForWindow:[mMainWindowController window]
		modalDelegate:self
	   didEndSelector:@selector(doneSearchAndImportSheet:returnCode:contextInfo:)
		  contextInfo:NULL];	
}

#pragma mark Deallocation
/**
 Implementation of dealloc, to release the retained variables.
 */

- (void) dealloc {
	[mMapSources release], mMapSources = nil;
	[opController release], opController = nil;
    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}


@end
