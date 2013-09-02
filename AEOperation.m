//
//  AEOperation.m
//  AtlasExplorer
//
//  Created by Dirkjan Krijnders on 2/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AEOperation.h"


@implementation AEOperation

@synthesize title;
@synthesize url;
@synthesize MOContext;

- (id) initWithURL:(NSURL*)aFile andMOContext:(NSManagedObjectContext*)aMOContext {
	if ( self = [super init] ){
		self.url = aFile;
		self.MOContext = aMOContext;
		self.title = [url absoluteString];
		NSLog(@"%@", self.MOContext);
	//	NSLog(@"%@", [self.MOContext managedObjectModel]);
	}
	NSLog(@"AEImporter created with %@", url);
	return self;
};

- (void) handleError:(NSError *)err {
    NSLog(@"%@", err);
}
@end
