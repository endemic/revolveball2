//
//  GameCenterManager.h
//  RevolveBall
//
//  Created by Nathan Demick on 4/17/11.
//  Copyright 2011 Ganbaru Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "SynthesizeSingleton.h"

@interface GameCenterManager : NSObject <NSCoding, GKLeaderboardViewControllerDelegate>
{
	BOOL hasGameCenter;
	NSMutableArray *unsentScores;
	UIViewController *myViewController;
}

@property (readwrite) BOOL hasGameCenter;
@property (readwrite, retain) NSMutableArray *unsentScores;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(GameCenterManager);

- (BOOL)isGameCenterAPIAvailable;
- (void)authenticateLocalPlayer;
- (void)reportScore:(int64_t)score forCategory:(NSString *)category;
- (void)showLeaderboardForCategory:(NSString *)category;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

+ (void)loadState;
+ (void)saveState;

@end
