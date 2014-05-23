//
//  NSColorHexValue.m
//  PathKeeper
//
//  Created by Dirkjan Krijnders on 10/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSColorHexValue.h"

@implementation NSColor(NSColorHexadecimalValue)

-(NSString *)hexadecimalValueWithAlpha:(BOOL)withAlpha
{
	float redFloatValue, greenFloatValue, blueFloatValue, alphaFloatValue;
	int redIntValue, greenIntValue, blueIntValue, alphaIntValue;
	NSString *redHexValue, *greenHexValue, *blueHexValue, *alphaHexValue;
	
	//Convert the NSColor to the RGB color space before we can access its components
	NSColor *convertedColor=[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	if(convertedColor)
	{
		// Get the red, green, and blue components of the color
		[convertedColor getRed:(CGFloat*)&redFloatValue green:(CGFloat*)&greenFloatValue blue:(CGFloat*)&blueFloatValue alpha:(CGFloat*)&alphaFloatValue];
		
		// Convert the components to numbers (unsigned decimal integer) between 0 and 255
		redIntValue=redFloatValue*255.99999f;
		greenIntValue=greenFloatValue*255.99999f;
		blueIntValue=blueFloatValue*255.99999f;
		alphaIntValue = alphaFloatValue*255.99999f;
		
		// Convert the numbers to hex strings
		redHexValue=[NSString stringWithFormat:@"%02x", redIntValue];
		greenHexValue=[NSString stringWithFormat:@"%02x", greenIntValue];
		blueHexValue=[NSString stringWithFormat:@"%02x", blueIntValue];
		alphaHexValue=[NSString stringWithFormat:@"%02x", alphaIntValue];

		if (withAlpha)
			// Concatenate the alpha, red, green, and blue components' hex strings together with a "#"
			return [NSString stringWithFormat:@"#%@%@%@%@", alphaHexValue, redHexValue, greenHexValue, blueHexValue];
		else
			// Concatenate the red, green, and blue components' hex strings together with a "#"
			return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
	}
	return nil;
}

@end
