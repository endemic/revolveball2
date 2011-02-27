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
		
		// Add background
		NSMutableString *backgroundFile = [NSMutableString stringWithFormat:@"title-background"];
		
		// Check if running on iPad
		if ([GameData sharedGameData].isTablet) [backgroundFile appendString:@"-hd"];
		
		// Append file extension
		[backgroundFile appendString:@".png"];
		
		CCSprite *background = [CCSprite spriteWithFile:backgroundFile];
		[background setPosition:ccp(windowSize.width / 2, windowSize.height / 2)];
		[self addChild:background z:0];
		
		// Add button which takes us to game scene
		CCMenuItem *startButton = [CCMenuItemImage itemFromNormalImage:@"start-button.png" selectedImage:@"start-button.png" target:self selector:@selector(startGame:)];
		CCMenu *titleMenu = [CCMenu menuWithItems:startButton, nil];
		[titleMenu setPosition:ccp(windowSize.width / 2, windowSize.height / 10)];
		[self addChild:titleMenu z:1];
		
		// Check if running on iPad
		if ([GameData sharedGameData].isTablet)
			[startButton setScale:2.0];
		
		// Set audio mixer rate to lower level
		[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"button-press.caf"];
		
		// Run animation which moves background
//		[background runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
//																 [CCDelayTime actionWithDuration:1.0],
//																 [CCMoveTo actionWithDuration:15.0 position:ccp(0, 240)], 
//																 [CCDelayTime actionWithDuration:1.0],
//																 [CCMoveTo actionWithDuration:15.0 position:ccp(320, 240)], 
//																 nil]]];
	}
	return self;
}

- (void)startGame:(id)sender
{
	// Load "hub" level
	[GameData sharedGameData].currentWorld = 0;
	[GameData sharedGameData].currentLevel = 0;
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"button-press.caf"];
	
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}
@end