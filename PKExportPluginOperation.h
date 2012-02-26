//
//  PKExportPluginOperation.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AEOperation.h"
#import "PKPlugins/PKExportPluginProtocol.h"

@interface PKExportPluginOperation : AEOperation {
	NSArray* trackObjectIDs;
	NSObject<PKExportPluginProtocol>* plugin;
}

@property (retain, nonatomic) NSArray* trackObjectIDs;
@property (retain, nonatomic) NSObject<PKExportPluginProtocol>* plugin;
@end
