//
//  NBStorySet1.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 14/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBStorySet1 : CCLayer

-(void)startStory;
-(void)setupParentLayer:(id)layer withSelector:(SEL)selector;

//HUD
@property (nonatomic, retain) CCMenu* menu;
@property (nonatomic, retain) CCMenuItemLabel* skipButton;
@property (nonatomic, retain) id parentLayer;
@property (nonatomic, assign) SEL parentSelector;
@property (nonatomic, retain) CCLabelTTF* finishRollLabel;

//Narratives
@property (nonatomic, retain) CCLabelTTF* narrative1;

//Actors
@property (nonatomic, retain) CCSprite* metalActor1;
@property (nonatomic, retain) CCSprite* metalActor2;
@property (nonatomic, retain) CCSprite* metalActor3;
@property (nonatomic, retain) CCSprite* metalActor4;
@property (nonatomic, retain) CCSprite* metalActor5;

//Environments
@property (nonatomic, retain) CCSprite* normalSky;

@end
