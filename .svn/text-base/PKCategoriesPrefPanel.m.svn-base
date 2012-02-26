//
//  PKCategoriesPrefPanel.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PKCategoriesPrefPanel.h"


@implementation PKCategoriesPrefPanel

-(void) awakeFromNib
{
	NSLog(@"Awake from Nib! changed!");
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(comboBoxSelectionDidChange:) name:@"NSComboBoxSelectionDidChangeNotification" object:styleComboBox];
	NSLog(@"Registered with notification center");
	
};

#pragma mark ComboBox delegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{         
	NSLog(@"Combobox selection changed!");
	// User entered a known category name
	
	NSEnumerator *e = [[styleArrayController arrangedObjects] objectEnumerator];
	id styleObject;
	
	while ( (styleObject = [e nextObject]) ) {
		NSLog(@"%@ =? %@", [styleObject valueForKey:@"name"], [styleComboBox objectValueOfSelectedItem]);
		if ([[styleObject valueForKey:@"name"] isEqualToString:[styleComboBox objectValueOfSelectedItem]])
		{
			unsigned int selectionIndex = [categoryArrayController selectionIndex];            
			
			NSManagedObject *category =  [[categoryArrayController arrangedObjects] objectAtIndex:selectionIndex];
			NSLog(@"Adding style %@ to %@", styleObject, category);
			[category setValue:styleObject forKey:@"style"];
			
			break;
		}
	}
}

@end
