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

@interface LevelSelectLayer : CCLayer {}

- (void)playWorldOne;
- (void)playWorldTwo;
- (void)playWorldThree;
- (void)playWorldFour;

- (void)backButtonAction:(id)sender;
- (void)playButtonAction:(id)sender;

@end

