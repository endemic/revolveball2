//
//  GameData.h
//  Revolve Ball
//
//  Created by Nathan Demick on 10/15/10.
//  Copyright 2010 Ganbaru Games. All rights reserved.
//
// Serializes certain game variables on exit then restores them on game load
// Taken from http://stackoverflow.com/questions/2670815/game-state-singleton-cocos2d-initwithencoder-always-returns-null

#import "cocos2d.h"
#import "SynthesizeSingleton.h"

@interface GameData : NSObject <NSCoding> 
{
	// The current level
	int currentWorld, currentLevel;
	
	
	// Boolean that's set to "true" if game is running on iPad!
	bool isTablet;
	
	/** Below aren't currently used **/
	// Variable we check to see if player quit in the middle of a level
	bool restoreLevel;
	
	// Time remaining
	int secondsLeft;
	
	// Placeholder
	int bestTime;
	
	bool paused;
}

@property (readwrite, nonatomic) int currentWorld;
@property (readwrite, nonatomic) int currentLevel;
@property (nonatomic) bool restoreLevel;
@property (readwrite, nonatomic) int bestTime;
@property (readwrite, nonatomic) int secondsLeft;
@property (nonatomic) bool paused;
@property (nonatomic) bool isTablet;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(GameData);

+ (void)loadState;
+ (void)saveState;

@end
