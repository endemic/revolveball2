//
//  CreditsScene.m
//  RevolveBall
//
//  Created by Nathan Demick on 3/31/11.
//  Copyright 2011 Ganbaru Games. All rights reserved.
//

#import "CreditsScene.h"
#import "TitleScene.h"
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"
#import "GameData.h"


@implementation CreditsScene
- (id)init
{
	if ((self = [super init]))
	{
		[self addChild:[CreditsLayer node]];
	}
	return self;
}
@end

@implementation CreditsLayer

- (id)init
{
	if ((self = [super init]))
	{
		// < Back
		// Thanks for playing!
		// You are a Revolve Ball Master!
		// Try to get even faster times on your favorite levels.
		// Created by Nathan Demick
		// (more games)
		
		// This string gets appended onto all image filenames based on whether the game is on iPad or not
		NSString *hdSuffix;
		if ([GameData sharedGameData].isTablet) hdSuffix = @"-hd";
		else hdSuffix = @"";
		
		// Get window size
		CGSize windowSize = [CCDirector sharedDirector].winSize;
		
		// Add background to layer
		CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"background-0%@.png", hdSuffix]];
		[background setPosition:ccp(windowSize.width / 2, windowSize.height / 2)];
		[background.texture setAliasTexParameters];
		[self addChild:background z:0];
		
		// Add "back" button
		CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:[NSString stringWithFormat:@"back-button%@.png", hdSuffix] selectedImage:[NSString stringWithFormat:@"back-button-selected%@.png", hdSuffix] target:self selector:@selector(backButtonAction:)];
		CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
		[backButtonMenu setPosition:ccp(backButton.contentSize.width / 1.5, windowSize.height - backButton.contentSize.height)];
		[self addChild:backButtonMenu];
		
		CCLabelBMFont *worldTitle = [CCLabelBMFont labelWithString:@"Thanks\nfor playing!" fntFile:[NSString stringWithFormat:@"yoster-32%@.fnt", hdSuffix]];
		[worldTitle setPosition:ccp(windowSize.width / 2, windowSize.height / 1.3)];
		[self addChild:worldTitle];
		
		// Add instructional text
		CCLabelBMFont *instructions = [CCLabelBMFont labelWithString:@"You are a Revolve Ball master!\nTry to get even faster times\non your favorite levels.\n\nGame created by Nathan Demick" fntFile:[NSString stringWithFormat:@"yoster-16%@.fnt", hdSuffix]];
		[instructions setPosition:ccp(windowSize.width / 2, worldTitle.position.y - instructions.contentSize.height * 1.5)];
		[self addChild:instructions];
	}
	return self;
}

- (void)backButtonAction:(id)sender
{
	// Play SFX
	[[SimpleAudioEngine sharedEngine] playEffect:@"button-press.caf"];
	
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[TitleScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}
@end