//
//  PKExportPluginManager.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKExportPluginManager.h"


@implementation PKExportPluginManager

@synthesize loadedPlugins;

+ (id)shared;
{
	static PKExportPluginManager *sharedInstance;
	if (!sharedInstance) {
		sharedInstance = [[PKExportPluginManager alloc] init];
	}
	return sharedInstance;
}

- (id)init
{
	if (!(self = [super init])) return nil;
	NSError *error;
	//Find the plugins
	NSFileManager *fileManager = [NSFileManager defaultManager];

	NSArray *plugins = [fileManager contentsOfDirectoryAtPath:[self applicationSupportFolder] error:&error];
	if (![plugins count]) {
		NSLog(@"%@:%s No plugins found in %@", [self class], _cmd, [self applicationSupportFolder]);
		return self;
	}
	
	//Load all of the plugins
	NSMutableArray *loadArray = [NSMutableArray array];
	for (NSString *pluginPath in plugins) {
		if (![pluginPath hasSuffix:@".bundle"]) 
			continue;
		
		NSBundle *pluginBundle = [NSBundle bundleWithPath:pluginPath];
		if ( !pluginBundle ) {
			NSLog(@"Plugin not a valid bundle: %@", pluginPath);
			continue;
		}
		
		Class principalClass = [pluginBundle principalClass];
		if (![principalClass conformsToProtocol:@protocol(PKExportPluginProtocol)]) {
			NSLog(@"Invalid plug-in, does not conform to the PKExportPluginProtocol: %@", pluginPath);
			continue;
		}
		id<PKExportPluginProtocol> plugin = [[principalClass alloc] init];
		[loadArray addObject:plugin];
		NSLog(@"Plug-in Loaded: %@ from: %@", [plugin name], pluginPath);
		[plugin release], plugin = nil;
	}
	[self setLoadedPlugins:loadArray];
	
	return self;
}

- (NSArray*)pluginModels;
{
	NSMutableArray *array = [NSMutableArray array];
	for (id<PKExportPluginProtocol> plugin in [self loadedPlugins]) {
		[array addObject:[plugin managedObjectModel]];
	}
	return array;
}

- (NSArray*)modelConfigurations;
{
	NSMutableArray *array = [NSMutableArray array];
	for (id<PKExportPluginProtocol> plugin in [self loadedPlugins]) {
		[array addObject:[plugin modelConfigurationName]];
	}
	return array;
}

- (NSString*)applicationSupportFolder 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] :NSTemporaryDirectory();
	return [basePath stringByAppendingPathComponent:@"PathKeeper/PKPlugins"];
}

@end
