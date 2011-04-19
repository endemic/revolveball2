//
//  GameScene.h
//  Ballgame
//
//  Created by Nathan Demick on 10/15/10.
//  Copyright 2010 Ganbaru Games. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import <vector>	// Easy data structure to store Box2D bodies

@interface GameScene : CCScene {}

@end

@interface GameLayer : CCLayer 
{
	// Box2D
	b2World *world;
	MyContactListener *contactListener;
	
	// Player
	CCSprite *ball;
	
	// Map
	CCTMXTiledMap *map;
	CCTMXLayer *border;
	
	// Vectors of Box2D bodies that can be toggled off/on in a level
	std::vector<b2Body *> toggleBlockGroup;
	std::vector<b2Body *> toggleSwitchGroup;
	
	// Flag for whether or not the toggle block switch can be thrown
	bool toggleSwitchTimeout;
	
	// Vars for rotational touch controls
	float previousAngle, currentAngle, touchEndedAngle;
	
	// For time limit
	int secondsLeft;
	CCLabelBMFont *timerLabel;
	
	// For countdown at start of level
	int countdownTime;
	
	// Determines whether or not user input is taken
	BOOL levelComplete;
	
	// Pretty self-explanatory
	BOOL paused;
	
	// Base size of Box2D objects; doubles on iPad/iPhone 4 Retina Display
	int ptmRatio;
}
- (void)winGame;	// Win/loss actions
- (void)loseGame;
- (void)loseTime:(int)seconds;	// Method to subtract from countdown timer & display a label w/ lost time
- (void)gainTime:(int)seconds;
- (void)blockHubEntrances;	// Used in hub level; checks player progress and inserts barriers to prevent access to higher levels
- (void)createParticleEmitterAt:(CGPoint)position;
@end
