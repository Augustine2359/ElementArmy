//
//  NBStageInfoPanel.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 22/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBStageData.h"
#import "NBBasicClassData.h"

@interface NBStageInfoPanel : CCLayer
{
    bool reappearFlag;
}

-(id)initOnLayer:(CCLayer*)layer;
-(void)appearWithStageData:(NBStageData*)stageData;
-(void)disappear:(bool)reappear;
-(void)onDisappeared;

@property (nonatomic, retain) CCSprite* background;
@property (nonatomic, retain) CCLabelTTF* levelName;
@property (nonatomic, retain) CCSprite* enemyImage1;
@property (nonatomic, retain) CCSprite* enemyImage2;
@property (nonatomic, retain) CCSprite* enemyImage3;
@property (nonatomic, assign) bool isAppeared;
@property (nonatomic, retain) NBStageData* currentSelectedStageData;

@end
