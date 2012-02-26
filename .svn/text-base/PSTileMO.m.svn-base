//
//  PSTileMO.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 8/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PSTileMO.h"
#import "NSData_AMDigest.h"

@implementation PSTileMO
@dynamic imageHash;
@dynamic lastPing;
@dynamic positionX;
@dynamic positionY;
@dynamic sizeX;
@dynamic sizeY;
@dynamic properties;

- (id) init
{
	self = [super init];
	if (self)
	{
		imageData = nil;
	}
	return self;
}

- (NSMutableString*) cacheLocation
{
	NSMutableString* path = [NSMutableString stringWithString:[[NSApp delegate] applicationSupportFolder]];
	[path appendString:@"/tileCache"];
	return path;
}

- (void) setImage:(NSImage*)image
{
	NSMutableString* path = [self cacheLocation];
	NSData *newImageData = [image  TIFFRepresentation];
	NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:newImageData];
	NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
	newImageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
	
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:path isDirectory:NULL] ) {
		[fileManager createDirectoryAtPath:path attributes:nil];
	};
	NSMutableString* filePath = [NSMutableString stringWithString:path];
	[filePath appendString:@"/tmp.png" ];
	[newImageData writeToFile:filePath atomically: YES];
	
	NSError* error = nil;
	NSPipe* pipe = [NSPipe pipe];
	NSTask* md5Task = [[NSTask alloc] init];
	[md5Task setLaunchPath:@"/sbin/md5"];
	[md5Task setArguments:[NSArray arrayWithObject:filePath]];
	[md5Task setStandardOutput:pipe];
	[md5Task launch];
	[md5Task waitUntilExit];
	NSString* result = [[NSString alloc] initWithData:[[pipe fileHandleForReading] readDataToEndOfFile] encoding:NSASCIIStringEncoding]; 
	NSString* md5Hash = [NSString stringWithString:[result substringFromIndex:[result length] - 32]]; 
	[fileManager moveItemAtPath:filePath toPath:[NSString stringWithFormat:@"%@/%@.png", path, md5Hash] error:&error];
//	NSString* md5Hash = [[NSString alloc] initWithData:[newImageData md5Digest] encoding:NSASCIIStringEncoding];
	NSLog(@"Result: %@", md5Hash);
//	[newImageData writeToFile:[NSString stringWithFormat:@"%@/%@.png", path, md5Hash] atomically: YES];
	[self setImageHash:md5Hash];
	[self setSizeX:[NSNumber numberWithInt:0]];
	[self setSizeY:[NSNumber numberWithInt:0]];
	[self setPositionX:[NSNumber numberWithInt:0]];
	[self setPositionY:[NSNumber numberWithInt:0]];
	[self setLastPing:[NSDate date]];
};

- (NSImage*) image
{
	if (imageData == nil)
	{
		NSMutableString* filename = [self cacheLocation];
		[filename appendString:@"/"];
		[filename appendString:[self imageHash]];
		[filename appendString:@".png"];
		
		imageData = [[NSImage alloc] initWithContentsOfFile:filename];
	}
	return imageData;
};

- (void)setPropertyForKey:(NSString*)aKey value:(NSNumber*)aValue
{
};

- (NSNumber*)propertyForKey:(NSString*)aKey
{
};

- (void)draw
{
	[[self image] compositeToPoint:NSMakePoint([self.positionX floatValue], [self.positionY floatValue]) operation:NSCompositeCopy];
};

- (void) dealloc
{
	[imageData release];
	[super dealloc];
};

@end
