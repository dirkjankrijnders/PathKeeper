//
//  PKToolbarDelegate.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKToolbarDelegate.h"

#import "pathKeeper_AppDelegate.h"

@implementation PKToolbarDelegate

@dynamic searchFieldContent;

- (IBAction) importGPX:(id)sender
{
	[(pathKeeper_AppDelegate*)[NSApp delegate] openGPXFile:sender];
};

- (IBAction) exportMyPlaces:(id)sender
{
	[(pathKeeper_AppDelegate*)[NSApp delegate] exportToMyPlaces:sender];
};

- (void)setSearchFieldContent:(NSString*)sender
{
	if (sender == nil)
		sender = @"";
	NSDictionary* dict = [NSDictionary dictionaryWithObject:sender forKey:@"value"];
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"searchFieldContentsChanged" object:nil userInfo:dict]];
//	NSLog(@"search filter: %@", [searchField
};

@end
