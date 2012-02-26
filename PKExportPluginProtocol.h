//
//  PKExportProtocol.h
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PKTrackMO.h"

@protocol PKExportPluginProtocol <NSObject>

- (NSString *) name;
- (NSString*)modelConfigurationName;
- (NSManagedObjectModel*)managedObjectModel;

- (void)shouldBeginExport;
- (void)willBeginExportToPath:(NSString*)path;
- (BOOL)shouldExportTrackAtIndex:(NSUInteger)index;
- (void)exportTrackAtIndex:(NSUInteger)index;
- (BOOL)shouldWriteGPXDataForTrackMO:(PKTrackMO*)track data:(NSData*)gpxData toPath:(NSString *)path forTrackAtIndex:(NSUInteger)index;
- (void)didWriteGPXDataToPath:(NSString *)relativePath forTrackAtIndex:(NSUInteger)index;
- (BOOL)shouldWriteKMLDataForTrackMO:(PKTrackMO*)track data:(NSData*)kmlData toPath:(NSString *)path forTrackAtIndex:(NSUInteger)index;
- (void)didWriteKMLDataToPath:(NSString *)relativePath forTrackAtIndex:(NSUInteger)index;
- (void)didFinishExport;

@end
