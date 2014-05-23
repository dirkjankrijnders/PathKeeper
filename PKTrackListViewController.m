//
//  PKTrackListView.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKTrackListViewController.h"
#import "PathKeeper_AppDelegate.h"

@implementation PKTrackListViewController

@synthesize filterPredicate;

- (void) awakeFromNib
{
	NSSortDescriptor * sd = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
	[trackListArrayController setSortDescriptors:[NSArray arrayWithObject:sd]];
	[sd release];
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(searchFieldChanged:) name:@"searchFieldContentsChanged" object:nil];
	
	[self setFilterPredicate:nil];
	[(pathKeeper_AppDelegate*)[NSApp delegate] setTrackListController:trackListArrayController];
};

- (void) tableViewSelectionDidChange:(NSNotification *)notification
{
	if ([[trackListArrayController selectedObjects] count] > 0)
	{
		NSArray* items = [trackListArrayController selectedObjects];
		NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
		NSDictionary* d = [NSDictionary dictionaryWithObject:items
													  forKey:@"track"];
		[nc postNotificationName:@"trackSelectionChanged" object:self userInfo:d];
	}
};

- (void)searchFieldChanged:(NSNotification*)notification
{
	if ([[[notification userInfo] valueForKey:@"value"] compare:0] == NSOrderedSame)
		[self setFilterPredicate:nil];
	else
		[self setFilterPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", [[notification userInfo] valueForKey:@"value"]]];
};

@end
