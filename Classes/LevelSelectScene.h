//
//  LevelSelectScene.h
//  Revolve Ball
//
//  Created by Nathan Demick on 12/2/10.
//  Copyright 2010 Ganbaru Games. All rights reserved.
//

#import "cocos2d.h"

@interface LevelSelectScene : CCScene {}
@end

@interface LevelSelectLayer : CCLayer 
{
	// A collection of icons that represent levels
	NSMutableArray *levelIcons;
	
	// Rotating ball icon which represents current level selection
	CCSprite *ball;
}


- (void)backButtonAction:(id)sender;
- (void)playButtonAction:(id)sender;

@end

