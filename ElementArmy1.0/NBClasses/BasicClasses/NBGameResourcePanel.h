//
//  NBGameResourcePanel.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 21/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBDataManager.h"

@interface NBGameResourcePanel : CCLayer

+(id)getGamePanel;
-(void)updateResourceInfo;

@property (nonatomic, retain) CCSprite* background;
@property (nonatomic, retain) CCSprite* energyInfoPanel;
@property (nonatomic, retain) CCSprite* goldInfoPanel;
@property (nonatomic, retain) CCSprite* elementalGemInfoPanel;
@property (nonatomic, retain) CCSprite* energyIcon;
@property (nonatomic, retain) CCSprite* goldIcon;
@property (nonatomic, retain) CCSprite* elementalGemIcon;
@property (nonatomic, retain) CCLabelTTF* energyInfo;
@property (nonatomic, retain) CCLabelTTF* goldInfo;
@property (nonatomic, retain) CCLabelTTF* elementalGemInfo;

@property (nonatomic, assign) int currentEnergy;
@property (nonatomic, assign) int currentGold;
@property (nonatomic, assign) int currentElementalgem;

@property (nonatomic, retain) NBDataManager* dataManager;

@end
