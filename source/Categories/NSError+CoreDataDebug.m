//
//  NSError+CoreDataDebug.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSError+CoreDataDebug.h"


@implementation NSError(CoreDataDebug)

- (NSString *)debugDescription
{
    //  Log the entirety of domain, code, userInfo for debugging.
    //  Operates recursively on underlying errors
    NSMutableDictionary *dictionaryRep = [[self userInfo] mutableCopy];
    [dictionaryRep setObject:[self domain]
                      forKey:@"domain"];
    [dictionaryRep setObject:[NSNumber numberWithInteger:[self code]]
					  forKey:@"code"];
    NSError *underlyingError = [[self userInfo] objectForKey:NSUnderlyingErrorKey];
    NSString *underlyingErrorDescription = [underlyingError debugDescription];
    if (underlyingErrorDescription)
    {
        [dictionaryRep setObject:underlyingErrorDescription
                          forKey:NSUnderlyingErrorKey];
    }
    // Finish up
    NSString *result = [dictionaryRep description];
    [dictionaryRep release];
    return result;
}

@end
