//
//  LevelSelectScene.m
//  Revolve Ball
//
//  Created by Nathan Demick on 12/2/10.
//  Copyright 2010 Ganbaru Games. All rights reserved.
//

#import "LevelSelectScene.h"
#import "GameScene.h"
#import "GameData.h"

#define COCOS2D_DEBUG 1

@implementation LevelSelectScene

- (id)init
{
	if ((self = [super init]))
	{
		[self addChild:[LevelSelectLayer node]];
	}
	return self;
}

@end

@implementation LevelSelectLayer

- (id)init
{
	if ((self = [super init]))
	{
		/*
		 PSEUDO-CODE
		 
		 * Check singleton to determine which background to display [DONE]
		 * Check user defaults to determine which levels have already been completed
		 * Draw "bridges" after levels that have already been completed
		 * Player can move between levels by tapping level icon - up to currently completed level + 1
		 * Selecting a level also updates singleton level counter
		 * Player can return to world select by tapping "back" button [DONE]
		 * Player can play selected level by tapping "play" button [DONE]
		 * When a level is complete, draw the "bridge" to the next level
		 * After 10th level is complete, "continue" button takes player back to world select scene
		 * Gate that blocks next world disappears, arrow appears showing player where to go next
		 */
		
		// Get window size
		CGSize windowSize = [CCDirector sharedDirector].winSize;
		
		// Decide which background to display
		// Create string to reference background image
		NSMutableString *backgroundFile = [NSMutableString stringWithFormat:@"background-%i", [GameData sharedGameData].currentWorld];
		
		// If running on iPad, append "-hd" suffix
		if ([GameData sharedGameData].isTablet) [backgroundFile appendString:@"-hd"];
		
		// Append file format suffix
		[backgroundFile appendString:@".png"];
		
		// Add background to layer
		CCSprite *background = [CCSprite spriteWithFile:backgroundFile];
		[background setPosition:ccp(winSize.width / 2, winSize.height / 2)];
		[background.texture setAliasTexParameters];
		[self addChild:background z:0];
		
		// Add "back" button
		CCMenu *backButtonMenu = [CCMenu menuWithItems:[CCMenuItemImage itemFromNormalImage:@"back-button.png" selectedImage:@"back-button-selected.png" target:self selector:@selector(backButtonAction:)], nil];
		[backButtonMenu setPosition:ccp(windowSize.width / 2, windowSize.height / 6)];
		[self addChild:backButtonMenu];
		
		// Add "play" button
		CCMenu *playButtonMenu = [CCMenu menuWithItems:[CCMenuItemImage itemFromNormalImage:@"play-button.png" selectedImage:@"play-button-selected.png" disabledImage:@"play-button-disabled.png" target:self selector:@selector(playButtonAction:)],nil];
		[playButtonMenu setPosition:ccp(windowSize.width / 2, windowSize.height / 6)];
		[self addChild:playButtonMenu];
		
	}
	return self;
}

- (void)backButtonAction:(id)sender
{
	// Load "hub" level
	[GameData sharedGameData].currentWorld = 0;
	[GameData sharedGameData].currentLevel = 0;
	
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}

- (void)playButtonAction:(id)sender
{
	// Load current level stored in singleton variables
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}

- (void)playWorldOne
{
	// Set world/level
	[GameData sharedGameData].currentWorld = 1;
	[GameData sharedGameData].currentLevel = 1;
	
	// Transition to gameplay scene
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}

- (void)playWorldTwo
{
	// Set world/level
	[GameData sharedGameData].currentWorld = 2;
	[GameData sharedGameData].currentLevel = 1;
	
	// Transition to gameplay scene
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}

- (void)playWorldThree
{
	// Set world/level
	[GameData sharedGameData].currentWorld = 3;
	[GameData sharedGameData].currentLevel = 1;
	
	// Transition to gameplay scene
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}

- (void)playWorldFour
{
	// Set world/level
	[GameData sharedGameData].currentWorld = 4;
	[GameData sharedGameData].currentLevel = 1;
	
	// Transition to gameplay scene
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}
@end