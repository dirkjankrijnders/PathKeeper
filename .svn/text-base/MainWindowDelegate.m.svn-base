//
//  MainWindowDelegate.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 4/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainWindowDelegate.h"


@implementation MainWindowDelegate

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
	return [self undoManager];
}

- (NSUndoManager*)undoManager
{
	return [[[NSApp delegate] managedObjectContext] undoManager];
}

@end
