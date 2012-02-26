/*
 *  JDKTempDirectory.c
 *  PathKeeper
 *
 *  Created by Dirkjan Krijnders on 1/2/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "JDKTempDirectory.h"

NSString* uniqueTemporaryDirectory()
{
	NSString *tempDirectoryTemplate =
	[NSTemporaryDirectory() stringByAppendingPathComponent:@"myapptempdirectory.XXXXXX"];
	const char *tempDirectoryTemplateCString =
	[tempDirectoryTemplate fileSystemRepresentation];
	char *tempDirectoryNameCString =
	(char *)malloc(strlen(tempDirectoryTemplateCString) + 1);
	strcpy(tempDirectoryNameCString, tempDirectoryTemplateCString);
	
	char *result = mkdtemp(tempDirectoryNameCString);
	if (!result)
	{
		// handle directory creation failure
	}
	
	NSString *tempDirectoryPath =
	[[NSFileManager defaultManager]
	 stringWithFileSystemRepresentation:tempDirectoryNameCString
	 length:strlen(result)];
	free(tempDirectoryNameCString);
	return tempDirectoryPath;
}