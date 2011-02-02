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
		// DEBUG
		// Set world/level
		[GameData sharedGameData].currentWorld = 1;
		[GameData sharedGameData].currentLevel = 1;
		
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
		
		// Enable touches
		[self setIsTouchEnabled:YES];
		
		// Decide which background to display
		// Create string to reference background image
		NSMutableString *backgroundFile = [NSMutableString stringWithFormat:@"background-%i", [GameData sharedGameData].currentWorld];
		
		// If running on iPad, append "-hd" suffix
		if ([GameData sharedGameData].isTablet) [backgroundFile appendString:@"-hd"];
		
		// Append file format suffix
		[backgroundFile appendString:@".png"];
		
		// Add background to layer
		CCSprite *background = [CCSprite spriteWithFile:backgroundFile];
		[background setPosition:ccp(windowSize.width / 2, windowSize.height / 2)];
		[background.texture setAliasTexParameters];
		[self addChild:background z:0];
		
		// Add "back" button
		CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"back-button.png" selectedImage:@"back-button-selected.png" target:self selector:@selector(backButtonAction:)];
		CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
		[backButtonMenu setPosition:ccp(backButton.contentSize.width / 1.5, windowSize.height - backButton.contentSize.height)];
		[self addChild:backButtonMenu];
		
		// Add "play" button
		CCMenu *playButtonMenu = [CCMenu menuWithItems:[CCMenuItemImage itemFromNormalImage:@"start-button.png" selectedImage:@"start-button-selected.png" disabledImage:@"start-button-disabled.png" target:self selector:@selector(playButtonAction:)], nil];
		[playButtonMenu setPosition:ccp(windowSize.width / 2, windowSize.height / 10)];
		[self addChild:playButtonMenu];
		
		// Add large "world title" text
		NSString *worldTitleString;
		switch ([GameData sharedGameData].currentWorld) 
		{
			case 1: worldTitleString = @"Sky"; break;
			case 2: worldTitleString = @"Forest"; break;
			case 3: worldTitleString = @"Mountains"; break;
			case 4: worldTitleString = @"Caves"; break;
		}
		
		CCLabelBMFont *worldTitle = [CCLabelBMFont labelWithString:worldTitleString fntFile:@"yoster-48.fnt"];
		[worldTitle setPosition:ccp(windowSize.width / 2, windowSize.height / 1.333)];
		[self addChild:worldTitle];
		
		levelIcons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 10; i++)
		{
			// Create level icon sprite
			CCSprite *s = [CCSprite spriteWithFile:@"level-icon.png"];
			
			// Add number to level icon
			CCLabelBMFont *num = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", i + 1] fntFile:@"yoster-16.fnt"];
			[num setPosition:ccp(20, 10)];
			[s addChild:num];
			
			// Place level icon sprite in scene
			switch (i) 
			{
				case 0: [s setPosition:ccp(s.contentSize.width, 290)]; break;
				case 1: [s setPosition:ccp(s.contentSize.width, 226)]; break;
				case 2: [s setPosition:ccp(s.contentSize.width * 3, 290)]; break;
				case 3: [s setPosition:ccp(s.contentSize.width * 3, 226)]; break;
				case 4: [s setPosition:ccp(s.contentSize.width * 5, 290)]; break;
				case 5: [s setPosition:ccp(s.contentSize.width * 5, 226)]; break;
				case 6: [s setPosition:ccp(s.contentSize.width * 7, 290)]; break;
				case 7: [s setPosition:ccp(s.contentSize.width * 7, 226)]; break;
				case 8: [s setPosition:ccp(s.contentSize.width * 9, 290)]; break;
				case 9: [s setPosition:ccp(s.contentSize.width * 9, 226)]; break;
			}
			[self addChild:s];
			
			// Add level icon sprite to NSMutableArray
			[levelIcons addObject:s];
		}
		
		// Add rotating "ball" graphic to represent current level choice
		ball = [CCSprite spriteWithFile:@"ball.png"];
		[self addChild:ball z:1];
		
		// Set ball's position
		CCSprite *currentLevelIcon = [levelIcons objectAtIndex:[GameData sharedGameData].currentLevel - 1];
		[ball setPosition:ccp(currentLevelIcon.position.x, currentLevelIcon.position.y)];
		
		// Tell ball to spin for-evah!
		[ball setScale:0.8];
		[ball runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:360.0]]];
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

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if (touch)
	{
		// Get window size
		CGSize windowSize = [CCDirector sharedDirector].winSize;
		 
		// Convert location
		CGPoint touchPoint = [touch locationInView:[touch view]];
		
		// Cycle through level icons and determine a touch
		for (uint i = 0; i < [levelIcons count]; i++)
		{
			CCSprite *icon = [levelIcons objectAtIndex:i];
			CGRect iconRect = CGRectMake(icon.position.x, icon.position.y, icon.contentSize.width, icon.contentSize.height);
			
			if (CGRectContainsPoint(iconRect, touchPoint))
			{
				NSLog(@"Checking if (%f, %f) is near (%f, %f)", touchPoint.x, touchPoint.y, icon.position.x, icon.position.y);
				
				// Move ball icon over the appropriate icon
				[ball setPosition:icon.position];
				
				// Set level
				[GameData sharedGameData].currentLevel = i + 1;
			}
		}
	}
}

- (void)dealloc
{
	[levelIcons release];
	[super dealloc];
}
@end