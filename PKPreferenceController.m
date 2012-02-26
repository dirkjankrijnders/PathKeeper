//
//  PKPreferenceController.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKPreferenceController.h"
#import "PKGeneralPrefPanel.h"
#import "PKStylesPrefPanel.h"
#import "PKCategoriesPrefPanel.h"
#import "PKPluginsPrefPanel.h"


@implementation PKPreferenceController

@synthesize currentViewController = mCurrentViewController;
//@synthesize currentWindowController = mCurrentWindowController;

- (id) init
{
	if (![super initWithWindowNibName:@"preferencePanel"])
		return nil;
	
	return self;
};

- (IBAction) switchPreferenceView:(id)sender
{
	NSLog(@"Preference switch view: %i", [sender tag]);
	[self removeViewController:[self currentViewController]];
	// remove current view from hierarchy
	[[[self currentViewController] view] removeFromSuperview];
	
	// release current view controller
	[self setCurrentViewController:nil];
	
	NSView * newView = nil;
	switch ([sender tag])
	{
		case 0:
			newView = [self _switchToGeneralView];
			break;
		case 1:
			newView = [self _switchToStylesView];
			break;
		case 2:
			 newView = [self _switchToCategoriesView];
			 break;
		case 3:
			newView = [self _switchToPluginsView];
			break;
	}
	
	[newView setFrame:[[[self window] contentView] bounds]];
	
	[newView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	[[[self window] contentView] addSubview:newView];
};

- (NSArray*)toolbarSelectableItemIdentifiers:(NSToolbar*)toolbar
{
    NSMutableArray* selectables = [NSMutableArray array];
    for( NSToolbarItem* item in [toolbar items] ) {
		[selectables addObject:[item itemIdentifier]];
    }
	return selectables;
}

- (NSView*) _switchToGeneralView
{
	XSViewController* ViewController = [[[PKGeneralPrefPanel alloc] initWithNibName:@"generalPrefPanel" bundle:nil windowController:self] autorelease];
//	[self addChild:ViewController];
	[self setCurrentViewController:ViewController];
//	[ViewController setRepresentedObject:[self representedObject]];
	return [ViewController view];
}

- (NSView*) _switchToStylesView
{
	XSViewController* ViewController = [[[PKStylesPrefPanel alloc] initWithNibName:@"stylesPrefPanel" bundle:nil windowController:self] autorelease];
//	[self addChild:ViewController];
	[self setCurrentViewController:ViewController];
//	[ViewController setRepresentedObject:[self representedObject]];
	return [ViewController view];
};

- (NSView*) _switchToCategoriesView
{
	PKCategoriesPrefPanel* ViewController = [[[PKCategoriesPrefPanel alloc] initWithNibName:@"categoriesPrefPanel" bundle:nil windowController:self] autorelease];
	//	[self addChild:ViewController];
	[self setCurrentViewController:ViewController];
	//	[ViewController setRepresentedObject:[self representedObject]];
	return [ViewController view];
};

- (NSView*) _switchToPluginsView
{
	PKCategoriesPrefPanel* ViewController = [[[PKCategoriesPrefPanel alloc] initWithNibName:@"pluginsPrefPanel" bundle:nil windowController:self] autorelease];
	//	[self addChild:ViewController];
	[self setCurrentViewController:ViewController];
	//	[ViewController setRepresentedObject:[self representedObject]];
	return [ViewController view];
};

@end
