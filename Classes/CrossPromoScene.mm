//
//  CrossPromoScene.m
//  RevolveBall
//
//  Created by Nathan Demick on 2/17/11.
//  Copyright 2011 Ganbaru Games. All rights reserved.
//

#import "CrossPromoScene.h"
#import "GameData.h"

@implementation CrossPromoScene

- (id)init
{
	if ((self = [super init]))
	{
		[self addChild:[CrossPromoLayer node] z:0];
	}
	return self;
}

@end

@implementation CrossPromoLayer

- (id)init
{
	if ((self = [super init]))
	{
		CGSize windowSize = [CCDirector sharedDirector].winSize;
		
		// Add a background for testing purposes
		NSMutableString *backgroundFile = [NSMutableString stringWithFormat:@"title-background"];
		
		// Check if running on iPad
		if ([GameData sharedGameData].isTablet) [backgroundFile appendString:@"-hd"];
		
		// Append file extension
		[backgroundFile appendString:@".png"];
		
		CCSprite *background = [CCSprite spriteWithFile:backgroundFile];
		[background setPosition:ccp(windowSize.width / 2, windowSize.height / 2)];
		[self addChild:background z:0];
		
		CGRect webFrame = CGRectMake(10, 140, 300, 300);
		promotionContent = [[UIWebView alloc] initWithFrame:webFrame];
		
		//promotionContent.backgroundColor = [UIColor whiteColor];	// White BG
		[promotionContent setBackgroundColor:[UIColor clearColor]];	// Transparent BG
		
		// Add to OpenGL view
		[[[CCDirector sharedDirector] openGLView] addSubview:promotionContent];
		
		// Load content
		[promotionContent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ganbarugames.com/promotions/?source=nonogram_madness"]]];
		
		// Remove from view
		//[promotionContent removeFromSuperView];
	}
	return self;
}

- (void)dealloc
{
	[promotionContent release];
	
	[super dealloc];
}
@end