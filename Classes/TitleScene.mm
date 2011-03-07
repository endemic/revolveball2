//
//  TitleScene.m
//  Ballgame
//
//  Created by Nathan Demick on 10/14/10.
//  Copyright 2010 Ganbaru Games. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"
#import "GameData.h"

#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

@implementation TitleScene
- (id)init
{
	if ((self = [super init]))
	{
		[self addChild:[TitleLayer node] z:0];
	}
	return self;
}
@end

@implementation TitleLayer
- (id)init
{
	if ((self = [super init]))
	{
		[self setIsTouchEnabled:YES];
		
		CGSize windowSize = [CCDirector sharedDirector].winSize;
		
		// This string gets appended onto all image filenames based on whether the game is on iPad or not
		NSString *hdSuffix;
		if ([GameData sharedGameData].isTablet) hdSuffix = @"-hd";
		else hdSuffix = @"";
		
		CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"title-background%@.png", hdSuffix]];
		[background setPosition:ccp(windowSize.width / 2, windowSize.height / 2)];
		[self addChild:background z:0];
		
		// Add button which takes us to game scene
		CCMenuItem *startButton = [CCMenuItemImage itemFromNormalImage:[NSString stringWithFormat:@"start-button%@.png", hdSuffix] selectedImage:[NSString stringWithFormat:@"start-button-selected%@.png", hdSuffix] target:self selector:@selector(startGame:)];

		CCMenu *titleMenu = [CCMenu menuWithItems:startButton, nil];
		[titleMenu setPosition:ccp(windowSize.width / 2, windowSize.height / 10)];
		[self addChild:titleMenu z:1];

		// Set audio mixer rate to lower level
		[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
		
		// Preload SFX
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"button-press.caf"];
	}
	return self;
}

- (void)startGame:(id)sender
{
	// Load "hub" level
	[GameData sharedGameData].currentWorld = 0;
	[GameData sharedGameData].currentLevel = 0;
	
	// Play SFX
	[[SimpleAudioEngine sharedEngine] playEffect:@"button-press.caf"];
	
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}
@end