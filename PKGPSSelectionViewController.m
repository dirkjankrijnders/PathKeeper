//
//  PKOverviewViewController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKGPSSelectionViewController.h"
#import "AEGPSRecieverMO.h"
#import "PKTrackMO.h"

#import "pathKeeper_AppDelegate.h"

@implementation PKGPSSelectionViewController
- (void) loadView
{
	[super loadView];
	[self fixGPSRecieverDropDown];
	[oGPSRecieversController addObserver:self forKeyPath:@"arrangedObjects" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
	[[(pathKeeper_AppDelegate*)[NSApp delegate] trackController] addObserver:self forKeyPath:@"selection" options:NSKeyValueObservingOptionNew context:NULL];
	[oGPSRecieverSelector setAutoenablesItems:false];
};

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
	NSLog(@"Recieved notification");
	[self fixGPSRecieverDropDown];
};

- (void) fixGPSRecieverDropDown
{
	int i;
	for (i = 2; i < [oGPSRecieverSelector numberOfItems]; i++ )
	{
		[oGPSRecieverSelector removeItemAtIndex:i];
	};
	NSManagedObjectContext *moc = [[NSApp delegate] managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"GPSReciever" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	NSError* error =  nil;
	NSArray *recievers = [moc executeFetchRequest:request error:&error];	
	for (AEGPSRecieverMO* rec in recievers)
	{
		[oGPSRecieverSelector addItemWithTitle:rec.Name];
		[[oGPSRecieverSelector itemWithTitle:rec.Name] bind:@"title" toObject:rec withKeyPath:@"Name" options:nil];
		[[oGPSRecieverSelector itemWithTitle:rec.Name] setAction:@selector(selectReciever:)];
		[[oGPSRecieverSelector itemWithTitle:rec.Name] setTarget:self];		
	}
	NSArray* recieversOfSelectedTracks = [[[NSApp delegate] trackController] selectedObjects];
	if ([recieversOfSelectedTracks count] == 1)
	{
		AEGPSRecieverMO* selectedReciever = [[recieversOfSelectedTracks objectAtIndex:0] GPSReciever];
		if (selectedReciever != nil)
			[oGPSRecieverSelector selectItemWithTitle:[selectedReciever Name]]; 
	} else {
		[oGPSRecieverSelector addItemWithTitle:@"Multiple selection"];
		[[oGPSRecieverSelector itemWithTitle:@"Multiple selection"] setEnabled:false];
		[oGPSRecieverSelector selectItemWithTitle:@"Multiple selection"];
	};
	
};

- (void)selectReciever:(id)sender
{
	NSManagedObjectContext *moc = [[NSApp delegate] managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"GPSReciever" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	NSError* error =  nil;
	NSPredicate* namePredicate = [NSPredicate predicateWithFormat:@"Name == %@", [sender title]];
	[request setPredicate:namePredicate];
	NSArray *recievers = [moc executeFetchRequest:request error:&error];
	AEGPSRecieverMO* selectedReciever = [recievers objectAtIndex:0];
	NSLog(@"Select reciever: %@", selectedReciever);
	for (PKTrackMO* track in [[[NSApp delegate] trackController] selectedObjects])
		[track setGPSReciever:selectedReciever];
}

-(void)dealloc
{
	[[[NSApp delegate] trackController] removeObserver:self forKeyPath:@"selection"];
	[super dealloc];
}

@end
