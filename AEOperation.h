//
//  AEOperation.h
//  AtlasExplorer
//
//  Created by Dirkjan Krijnders on 2/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AEOperation : NSOperation {
	NSString* title;
	NSManagedObjectContext* MOContext;
	NSURL* url;
}

@property (readwrite, copy) NSString* title;
@property (readwrite, retain) NSManagedObjectContext* MOContext;
@property (readwrite, retain) NSURL* url;

- (id) initWithURL:(NSURL*)aFile andMOContext:(NSManagedObjectContext*)aMOContext;

- (void) handleError:(NSError*)err;
@end
