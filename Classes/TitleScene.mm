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

#import "Appirater.h"
#import "GameCenterManager.h"

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
		
		CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"background-0%@.png", hdSuffix]];
		[background setPosition:ccp(windowSize.width / 2, windowSize.height / 2)];
		[self addChild:background z:0];
		
		
		CCSprite *logo = [CCSprite spriteWithFile:[NSString stringWithFormat:@"logo%@.png", hdSuffix]];
		[logo setPosition:ccp(windowSize.width / 2, windowSize.height - logo.contentSize.height / 1.5)];
		[self addChild:logo z:0];
		
		// Add button which takes us to game scene
		CCMenuItem *startButton = [CCMenuItemImage itemFromNormalImage:[NSString stringWithFormat:@"start-button%@.png", hdSuffix] selectedImage:[NSString stringWithFormat:@"start-button-selected%@.png", hdSuffix] target:self selector:@selector(startGame:)];
		CCMenu *titleMenu = [CCMenu menuWithItems:startButton, nil];
		[titleMenu setPosition:ccp(windowSize.width / 2, windowSize.height / 8)];
		[self addChild:titleMenu z:1];
		
		// Add copyright text
		CCLabelBMFont *copyright = [CCLabelBMFont labelWithString:@"(c)2011 Ganbaru Games" fntFile:[NSString stringWithFormat:@"munro-small-20%@.fnt", hdSuffix]];
		[copyright setPosition:ccp(windowSize.width / 2, copyright.contentSize.height)];
		[self addChild:copyright];
				
		[self preloadAudio];
		
		//[self performSelectorInBackground:@selector(preloadAudio) withObject:nil];
		
		// Try to authenticate local player; API check is built in
		[[GameCenterManager sharedGameCenterManager] authenticateLocalPlayer];
		
		// If the player has completed the game, prompt them to rate the game
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"completedGame"] == YES)
			[Appirater userDidSignificantEvent:YES];
	}
	return self;
}

- (void)preloadAudio
{
	// Info about running this method in background: http://stackoverflow.com/questions/2441856/iphone-sdk-leaking-memory-with-performselectorinbackground
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// Set audio mixer rate to lower level
	[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
	
	// Preload some SFX
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"button-press.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"spike-hit.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"wall-hit.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"wall-break.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"peg-hit.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"time-pickup.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"toggle.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"boost.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"level-complete.caf"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"level-fail.caf"];
	
	// Preload music - eventually do this based on the "world" that is selected
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"level-select.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"gameplay.mp3"];
	
	// Set BGM volume
	//NSLog(@"Current background music volume: %f", [[SimpleAudioEngine sharedEngine] backgroundMusicVolume]);
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.75];
	
	//[pool release];
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