//
//  PKPreferenceController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSWindowController.h"

@interface PKPreferenceController : XSWindowController {
	XSViewController *					mCurrentViewController;
//	XSWindowController *				mCurrentWindowController;

}

@property (retain) XSViewController *  currentViewController;
//@property (retain) XSWindowController * currentWindowController;

- (NSArray*) toolbarSelectableItemIdentifiers:(NSToolbar*)toolbar;
- (IBAction) switchPreferenceView:(id)sender;

- (NSView*) _switchToGeneralView;
- (NSView*) _switchToStylesView;
- (NSView*) _switchToCategoriesView;
- (NSView*) _switchToPluginsView;

@end
