//
//  LogoScene.m
//  RevolveBall
//
//  Created by Nathan Demick on 4/19/11.
//  Copyright 2011 Ganbaru Games. All rights reserved.
//

#import "LogoScene.h"
#import "TitleScene.h"
#import "GameData.h"

@implementation LogoScene

+ (id)scene
{
	// Create a generic scene object to attach the layer to
	CCScene *scene = [CCScene node];
	
	// Instantiate the layer
	LogoScene *layer = [LogoScene node];
	
	// Add to generic scene
	[scene addChild:layer];
	
	// Return scene
	return scene;
}

- (id)init
{
	if ((self = [super init]))
	{
		CGSize windowSize = [CCDirector sharedDirector].winSize;
		
		// This string gets appended onto all image filenames based on whether the game is on iPad or not
		NSString *hdSuffix;
		if ([GameData sharedGameData].isTablet) hdSuffix = @"-hd";
		else hdSuffix = @"";
		
		CCSprite *logo = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Default%@.png", hdSuffix]];
		[logo setPosition:ccp(windowSize.width / 2, windowSize.height / 2)];
		[self addChild:logo];
		
		// schedule the transition method
		[self schedule:@selector(nextScene)];
	}
	return self;
}

- (void)nextScene
{
	// Unschedule this method since it's only supposed to run once
	[self unschedule:@selector(nextScene)];
	
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[TitleScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}

- (void)dealloc
{
	[super dealloc];
}

@end
