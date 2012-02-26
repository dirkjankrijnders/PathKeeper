//
//  PKTestPlugin.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKTestPlugin.h"


@implementation PKTestPlugin

- (NSString*) name
{
	return @"Test plugin";
}

- (NSString*)modelConfigurationName;
{
	return @"TestPlugin";
}

- (NSManagedObjectModel*)managedObjectModel;
{
	if (managedObjectModel) return managedObjectModel;
	
	NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
	NSArray *bundles = [NSArray arrayWithObject:myBundle];
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:bundles] retain];
	return managedObjectModel;
}

- (void)shouldBeginExport
{
}

- (void)willBeginExportToPath:(NSString*)path
{
}

- (BOOL)shouldExportTrackAtIndex:(NSUInteger)index
{
	return YES;
}

- (void)exportTrackAtIndex:(NSUInteger)index
{
	
}

- (BOOL)shouldWriteGPXDataForTrackMO:(PKTrackMO*)track data:(NSData*)gpxData toPath:(NSString *)path forTrackAtIndex:(NSUInteger)index
{
	NSLog(@"Exporting GPX track #: %d: %@", index, track);
	return NO;
}

- (void)didWriteGPXDataToPath:(NSString *)relativePath forTrackAtIndex:(NSUInteger)index
{
	
}

- (BOOL)shouldWriteKMLDataForTrackMO:(PKTrackMO*)track data:(NSData*)kmlData toPath:(NSString *)path forTrackAtIndex:(NSUInteger)index
{
	NSLog(@"Exporting KML track #: %d: %@, returning NO!", index, track);
	return NO;
}

- (void)didWriteKMLDataToPath:(NSString *)relativePath forTrackAtIndex:(NSUInteger)index
{
	
}

- (void)didFinishExport
{
}

@end
