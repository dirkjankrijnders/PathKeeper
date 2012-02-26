//
//  PKTrackListView.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "XSViewController.h"

@interface PKTrackListViewController : XSViewController {
	IBOutlet NSArrayController* trackListArrayController;
	NSPredicate* filterPredicate;
}

- (void)searchFieldChanged:(NSNotification*)notification;

@property (retain, nonatomic) NSPredicate* filterPredicate;

@end
