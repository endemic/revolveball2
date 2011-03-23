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

#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

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
		if (![GameData sharedGameData].currentWorld) [GameData sharedGameData].currentWorld = 1;
		if (![GameData sharedGameData].currentLevel) [GameData sharedGameData].currentLevel = 1;
		
		/*
		 PSEUDO-CODE
		 
		 * Check singleton to determine which background to display [DONE]
		 * Check user defaults to determine which levels have already been completed [DONE]
		 * Draw "bridges" after levels that have already been completed [DONE]
		 * Player can move between levels by tapping level icon - up to currently completed level + 1 [DONE]
		 * Selecting a level also updates singleton level counter [DONE]
		 * Player can return to world select by tapping "back" button [DONE]
		 * Player can play selected level by tapping "play" button [DONE]
		 * When a level is complete, draw the "bridge" to the next level [DONE]
		 * After 10th level is complete, "continue" button takes player back to world select scene [DONE]
		 * Gate that blocks next world disappears, arrow appears showing player where to go next [DONE]
		 */
		
		// Get window size
		CGSize windowSize = [CCDirector sharedDirector].winSize;
		
		// Enable touches
		[self setIsTouchEnabled:YES];
		
		// This string gets appended onto all image filenames based on whether the game is on iPad or not
		NSString *hdSuffix;
		if ([GameData sharedGameData].isTablet) hdSuffix = @"-hd";
		else hdSuffix = @"";
		
		// Add background to layer
		CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"background-%i%@.png", [GameData sharedGameData].currentWorld, hdSuffix]];
		[background setPosition:ccp(windowSize.width / 2, windowSize.height / 2)];
		[background.texture setAliasTexParameters];
		[self addChild:background z:0];
		
		// Add "back" button
		CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:[NSString stringWithFormat:@"back-button%@.png", hdSuffix] selectedImage:[NSString stringWithFormat:@"back-button-selected%@.png", hdSuffix] target:self selector:@selector(backButtonAction:)];
		CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
		[backButtonMenu setPosition:ccp(backButton.contentSize.width / 1.5, windowSize.height - backButton.contentSize.height)];
		[self addChild:backButtonMenu];
		
		// Add "play" button
		CCMenuItemImage *playButton = [CCMenuItemImage itemFromNormalImage:[NSString stringWithFormat:@"start-button%@.png", hdSuffix] selectedImage:[NSString stringWithFormat:@"start-button-selected%@.png", hdSuffix] target:self selector:@selector(playButtonAction:)];
		CCMenu *playButtonMenu = [CCMenu menuWithItems:playButton, nil];
		[playButtonMenu setPosition:ccp(windowSize.width / 2, windowSize.height / 10)];
		[self addChild:playButtonMenu];
		
		// Add large "world title" text
		NSString *worldTitleString;
		switch ([GameData sharedGameData].currentWorld) 
		{
//			case 1: worldTitleString = @"Sky"; break;
//			case 2: worldTitleString = @"Forest"; break;
//			case 3: worldTitleString = @"Mountains"; break;
//			case 4: worldTitleString = @"Caves"; break;
			case 1: worldTitleString = @"World 1"; break;
			case 2: worldTitleString = @"World 2"; break;
			case 3: worldTitleString = @"World 3"; break;
			case 4: worldTitleString = @"World 4"; break;
		}
		
		CCLabelBMFont *worldTitle = [CCLabelBMFont labelWithString:worldTitleString fntFile:[NSString stringWithFormat:@"yoster-48%@.fnt", hdSuffix]];
		[worldTitle setPosition:ccp(windowSize.width / 2, windowSize.height / 1.3)];
		[self addChild:worldTitle];
		
		// Add instructional text
		CCLabelBMFont *instructions = [CCLabelBMFont labelWithString:@"Tap to select a level" fntFile:[NSString stringWithFormat:@"yoster-24%@.fnt", hdSuffix]];
		[instructions setPosition:ccp(windowSize.width / 2, worldTitle.position.y - instructions.contentSize.height * 1.5)];
		[self addChild:instructions];
		
		// Create level icon objects
		levelIcons = [[NSMutableArray alloc] init];
		int levelsPerWorld = 10;
		for (int i = 0; i < levelsPerWorld; i++)
		{
			// Create level icon sprite
			CCSprite *s = [CCSprite spriteWithFile:[NSString stringWithFormat:@"level-icon%@.png", hdSuffix]];
			
			// Add number to level icon
			CCLabelBMFont *num = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", i + 1] fntFile:[NSString stringWithFormat:@"munro-small-20%@.fnt", hdSuffix]];
			
			// Attempt to position the number based on sprite/label widths
			[num setPosition:ccp(s.contentSize.width - num.contentSize.width, s.contentSize.height - num.contentSize.height / 1.2)];
			[s addChild:num];
			
			// Some default positioning variables
			int levelIconYPos = windowSize.height * 0.6;
			int levelIconXPos = windowSize.width / 2;
			
			// Place level icon sprite in scene
			switch (i) 
			{
				// old Y values - 290, 226
				
				case 0: [s setPosition:ccp(levelIconXPos - s.contentSize.width * 4, levelIconYPos)]; break;
				case 1: [s setPosition:ccp(levelIconXPos - s.contentSize.width * 4, levelIconYPos - s.contentSize.width * 2)]; break;
				
				case 2: [s setPosition:ccp(levelIconXPos - s.contentSize.width * 2, levelIconYPos - s.contentSize.width * 2)]; break;
				case 3: [s setPosition:ccp(levelIconXPos - s.contentSize.width * 2, levelIconYPos)]; break;
				
				case 4: [s setPosition:ccp(levelIconXPos, levelIconYPos)]; break;
				case 5: [s setPosition:ccp(levelIconXPos, levelIconYPos - s.contentSize.width * 2)]; break;
				
				case 6: [s setPosition:ccp(levelIconXPos + s.contentSize.width * 2, levelIconYPos - s.contentSize.width * 2)]; break;
				case 7: [s setPosition:ccp(levelIconXPos + s.contentSize.width * 2, levelIconYPos)]; break;
				
				case 8: [s setPosition:ccp(levelIconXPos + s.contentSize.width * 4, levelIconYPos)]; break;
				case 9: [s setPosition:ccp(levelIconXPos + s.contentSize.width * 4, levelIconYPos - s.contentSize.width * 2)]; break;
			}
			[self addChild:s z:2];
			
			// Add level icon sprite to NSMutableArray
			[levelIcons addObject:s];
		}
		
		// Draw "bridges" between completed levels
		[self drawBridges];
		
		// Add rotating "ball" graphic to represent current level choice
		ball = [CCSprite spriteWithFile:[NSString stringWithFormat:@"ball%@.png", hdSuffix]];
		[self addChild:ball z:3];
		
		// Set ball's position
		int currentLevelIndex = [GameData sharedGameData].currentLevel - 1;
		CCSprite *currentLevelIcon = [levelIcons objectAtIndex:currentLevelIndex];
		[ball setPosition:ccp(currentLevelIcon.position.x, currentLevelIcon.position.y)];
		
		// Tell ball to spin for-evah!
		[ball setScale:0.8];
		[ball runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:360.0]]];
		
		// Add descriptive labels that show level info, such as title, best time, etc.
		levelTitle = [CCLabelBMFont labelWithString:@"Level Name" fntFile:[NSString stringWithFormat:@"yoster-24%@.fnt", hdSuffix]];
		[levelTitle setPosition:ccp(windowSize.width / 2, windowSize.height / 3)];
		[self addChild:levelTitle];
		
		levelBestTime = [CCLabelBMFont labelWithString:@"Best Time: --:--" fntFile:[NSString stringWithFormat:@"yoster-24%@.fnt", hdSuffix]];
		// Set the position based on the label above it
		[levelBestTime setPosition:ccp(windowSize.width / 2, levelTitle.position.y - levelBestTime.contentSize.height)];
		[self addChild:levelBestTime];
		
		levelTimeLimit = [CCLabelBMFont labelWithString:@"Limit: --:--" fntFile:[NSString stringWithFormat:@"yoster-24%@.fnt", hdSuffix]];
		// Set the position based on the label above it
		[levelTimeLimit setPosition:ccp(windowSize.width / 2, levelBestTime.position.y - levelTimeLimit.contentSize.height)];
		[self addChild:levelTimeLimit];
		
		// Update level info labels that we just created
		[self displayLevelInfo];
	}
	return self;
}

- (void)backButtonAction:(id)sender
{
	// Play SFX
	[[SimpleAudioEngine sharedEngine] playEffect:@"button-press.caf"];
	
	// Load "hub" level
	[GameData sharedGameData].currentWorld = 0;
	[GameData sharedGameData].currentLevel = 0;
	
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
}

- (void)playButtonAction:(id)sender
{
	// Play SFX
	[[SimpleAudioEngine sharedEngine] playEffect:@"button-press.caf"];
	
	// Load current level stored in singleton variables
	CCTransitionRotoZoom *transition = [CCTransitionRotoZoom transitionWithDuration:1.0 scene:[GameScene node]];
	[[CCDirector sharedDirector] replaceScene:transition];
	
	// Stop the BGM
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)moveLevelSelectCursor:(int)destination
{
	/* Holy shit, this is crufty */
	
	int currentLevelIndex = [GameData sharedGameData].currentLevel - 1;
	
	CCSprite *one = [levelIcons objectAtIndex:0];
	CCSprite *two = [levelIcons objectAtIndex:1];
	CCSprite *three = [levelIcons objectAtIndex:2];
	CCSprite *four = [levelIcons objectAtIndex:3];
	CCSprite *five = [levelIcons objectAtIndex:4];
	CCSprite *six = [levelIcons objectAtIndex:5];
	CCSprite *seven = [levelIcons objectAtIndex:6];
	CCSprite *eight = [levelIcons objectAtIndex:7];
	CCSprite *nine = [levelIcons objectAtIndex:8];
	CCSprite *ten = [levelIcons objectAtIndex:9];
	
	NSArray *actions = [NSArray arrayWithObjects:
						[CCMoveTo actionWithDuration:0.3 position:one.position],
						[CCMoveTo actionWithDuration:0.3 position:two.position],
						[CCMoveTo actionWithDuration:0.3 position:three.position],
						[CCMoveTo actionWithDuration:0.3 position:four.position],
						[CCMoveTo actionWithDuration:0.3 position:five.position],
						[CCMoveTo actionWithDuration:0.3 position:six.position],
						[CCMoveTo actionWithDuration:0.3 position:seven.position],
						[CCMoveTo actionWithDuration:0.3 position:eight.position],
						[CCMoveTo actionWithDuration:0.3 position:nine.position],
						[CCMoveTo actionWithDuration:0.3 position:ten.position],
						nil];
	
	CCSequence *seq = nil;
	
	if (currentLevelIndex < destination)
		for (int i = currentLevelIndex + 1; i <= destination; i++)
		{
			if (!seq) 
				seq = [actions objectAtIndex:i];
			else 
				seq = [CCSequence actionOne:seq two:[actions objectAtIndex:i]];
				
		}
	else if (currentLevelIndex > destination)
		for (int i = currentLevelIndex - 1; i >= destination; i--)
		{
			if (!seq) 
				seq = [actions objectAtIndex:i];
			else 
				seq = [CCSequence actionOne:seq two:[actions objectAtIndex:i]];
			
		}
	
	if (seq)
		[ball runAction:seq];
}

/* Draw "bridges" between level icons to indicate that the player can move between them */
- (void)drawBridges
{
	// This string gets appended onto all image filenames based on whether the game is on iPad or not
	NSString *hdSuffix;
	if ([GameData sharedGameData].isTablet) hdSuffix = @"-hd";
	else hdSuffix = @"";
	
	// Cycle through level icons to determine which can have bridges drawn
	for (uint i = 0; i < [levelIcons count] - 1; i++)
	{
		int currentLevelIndex = (([GameData sharedGameData].currentWorld - 1) * 10) + i;
		//int previousLevelIndex = currentLevelIndex - 1 > -1 ? currentLevelIndex - 1 : 0;
		
		// Check to see if the player has completed the current level
		NSMutableArray *levelData = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"levelData"]];
		NSDictionary *d = [levelData objectAtIndex:currentLevelIndex];
		
		// If so, draw a bridge
		if ([[d objectForKey:@"complete"] boolValue])
		{
			CCSprite *icon = [levelIcons objectAtIndex:i];
			CCSprite *b = [CCSprite spriteWithFile:[NSString stringWithFormat:@"level-connector%@.png", hdSuffix]];
			if (i % 2)	// Odd, means horizontal
			{
				[b setPosition:ccp(icon.position.x + b.contentSize.width / 2, icon.position.y)];
			}
			else
			{
				// Sprite is horizontal, so rotate to make vertical
				[b setRotation:90.0];
				
				// The offset direction switches every other time
				if (i == 0 || i == 4 || i == 8)
					[b setPosition:ccp(icon.position.x, icon.position.y - b.contentSize.width / 2)];
				else
					[b setPosition:ccp(icon.position.x, icon.position.y + b.contentSize.width / 2)];
			}
			[self addChild:b z:1];
		}
	}
}

/* Updates labels that show best time/level title/etc. */
- (void)displayLevelInfo
{
	// Create string that is equal to map filename
	NSMutableString *mapFile = [NSMutableString stringWithFormat:@"%i-%i", [GameData sharedGameData].currentWorld, [GameData sharedGameData].currentLevel];
	
	// Append file format suffix
	[mapFile appendString:@".tmx"];
	
	// Create map obj so we can get its' name + time limit
	CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:mapFile];
	
	int minutes, seconds;
	int currentLevelIndex = (([GameData sharedGameData].currentWorld - 1) * 10) + ([GameData sharedGameData].currentLevel - 1);
	
	// Get data structure that holds completion times for levels
	NSMutableArray *levelData = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"levelData"]];
	
	// Populate "best time" field
	int bestTimeInSeconds = [[[levelData objectAtIndex:currentLevelIndex] objectForKey:@"bestTime"] intValue];
	minutes = floor(bestTimeInSeconds / 60);
	seconds = bestTimeInSeconds % 60;
	
	// If the level is complete, display the best time... otherwise, just show "--:--"
	if ([[[levelData objectAtIndex:currentLevelIndex] objectForKey:@"complete"] boolValue])
		[levelBestTime setString:[NSString stringWithFormat:@"Best Time: %02d:%02d", minutes, seconds]];
	else
		[levelBestTime setString:@"Best Time: --:--"];
	
	
	// Populate time limit field
	if ([map propertyNamed:@"time"])
	{
		int timeLimitInSeconds = [[map propertyNamed:@"time"] intValue];
		minutes = floor(timeLimitInSeconds / 60);
		seconds = timeLimitInSeconds % 60;
		
		[levelTimeLimit setString:[NSString stringWithFormat:@"Limit: %02d:%02d", minutes, seconds]];
	}
	
	// Set the map name field
	if ([map propertyNamed:@"name"])
		[levelTitle setString:[map propertyNamed:@"name"]];
	else
		[levelTitle setString:[NSString stringWithFormat:@"Level %i", [GameData sharedGameData].currentLevel]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
			
			// Additional padding around the hit box
			int padding = 16;
			
			// CGRect origin is upper left, so offset the center
			CGRect iconRect = CGRectMake(icon.position.x - (icon.contentSize.width / 2) - (padding / 2), windowSize.height - icon.position.y - (icon.contentSize.height / 2) - (padding / 2), icon.contentSize.width + padding, icon.contentSize.height + padding);
			
			//NSLog(@"iconRect: %@", NSStringFromCGRect(iconRect));
			
			if (CGRectContainsPoint(iconRect, touchPoint))
			{
				int currentLevelIndex = (([GameData sharedGameData].currentWorld - 1) * 10) + i;
				int previousLevelIndex = currentLevelIndex - 1 > -1 ? currentLevelIndex - 1 : 0;
				
				// Check to see if the player has completed the previous level
				NSMutableArray *levelData = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"levelData"]];
				NSDictionary *d = [levelData objectAtIndex:previousLevelIndex];
				
				// If the level is complete and the ball isn't moving already, move to the tapped location
				if ([[d objectForKey:@"complete"] boolValue]/* && [ball numberOfRunningActions] < 1*/)
				{
					// Move ball icon over the appropriate icon
					[self moveLevelSelectCursor:i];
					
					// Set level
					[GameData sharedGameData].currentLevel = i + 1;
					
					// Update level info labels
					[self displayLevelInfo];
					
					// Play SFX
					[[SimpleAudioEngine sharedEngine] playEffect:@"button-press.caf"];
				}
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