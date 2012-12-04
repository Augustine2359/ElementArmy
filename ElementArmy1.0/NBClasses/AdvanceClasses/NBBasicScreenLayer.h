//
//  NBBasicScreenLayer.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 21/11/12.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@interface NBBasicScreenLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene*)scene;
+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault;
+(CCScene*)loadCurrentScene;
+(void)setDefaultScreen:(CCScene*)scene;
+(void)setCurrentScreen:(CCScene*)scene;
+(void)resetMenuIndex;

-(void)setLayerColor:(ccColor4B)color;
-(void)displayLayerTitle:(NSString*)title;
-(void)changeToScene:(NSString*)layerClassName;
-(void)changeToScene:(NSString*)layerClassName transitionWithDuration:(float)duration;
-(void)addStandardMenuString:(NSString*)menuTitle withSelector:(SEL)selectedMethod;
-(void)setCurrentBackgroundWithFileName:(NSString*)fileName stretchToScreen:(BOOL)stretch;

@property (nonatomic, retain) CCLabelTTF* layerTitle;
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) CCSpriteBatchNode* characterSpritesBatchNode;
@property (nonatomic, retain) NSString* nextScene;
@property (nonatomic, retain) CCSprite* background;

@end
