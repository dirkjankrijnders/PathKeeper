//
//  PKTrackOverviewViewController.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"
#import "PKTrackCategory.h"

@interface PKTrackOverviewViewController : XSViewController {
	IBOutlet NSTokenField* categoriesField;
}

- (IBAction) recalculateTrackStatistics:(id)sender;
- (NSArray *)tokenField:(NSTokenField *)tokenFieldArg 
completionsForSubstring:(NSString *)substring 
		   indexOfToken:(NSInteger)tokenIndex 
	indexOfSelectedItem:(NSInteger *)selectedIndex;

- (id)  tokenField:(NSTokenField *)tokenFieldArg representedObjectForEditingString:(NSString*)tokenString;
-(NSString* ) tokenField:(NSTokenField *)tokenFieldArg displayStringForRepresentedObject:(id)object;
- (IBAction) commitCategoryField:(id)sender;

- (PKTrackCategory*) categoryForString:(NSString*)tokenString;

@end
