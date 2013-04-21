//
//  NBStorySet2.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 19/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBFlashingScreen.h"

#define STORY_SPEED 2

@interface NBStorySet2 : CCLayer

-(void)startStory;
-(void)setupParentLayer:(id)layer withSelector:(SEL)selector;
-(void)onFlashingCompleted;

//HUD
@property (nonatomic, retain) CCMenu* menu;
@property (nonatomic, retain) CCMenuItemLabel* skipButton;
@property (nonatomic, retain) id parentLayer;
@property (nonatomic, assign) SEL parentSelector;
@property (nonatomic, retain) CCLabelTTF* finishRollLabel;

//Narratives
@property (nonatomic, retain) CCLabelTTF* narrative1;

//Environments
@property (nonatomic, retain) CCSprite* storyBackgroundImage1;
@property (nonatomic, retain) CCSprite* storyBackgroundImage2;
@property (nonatomic, retain) NBFlashingScreen* flashingScreen;

@end
