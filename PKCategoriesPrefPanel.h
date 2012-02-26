//
//  PKCategoriesPrefPanel.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XSViewController.h"

@interface PKCategoriesPrefPanel : XSViewController {
	IBOutlet NSArrayController *		categoryArrayController;
	IBOutlet NSArrayController *		styleArrayController;
	IBOutlet NSComboBox *				styleComboBox;
}

@end
