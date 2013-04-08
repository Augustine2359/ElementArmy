//
//  NBBattleResultLayer.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 8/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define INITIAL_BACKGROUND_SCALE 100
#define TARGET_BACKGROUND_SCALEX 25
#define TARGET_BACKGROUND_SCALEY 15

@interface NBBattleResultLayer : CCLayer
{
    long incrementalNumber;
    long targetAvailableBattlePoint;
}

-(void)setupParentLayer:(id)layer selector:(SEL)selector withCurrentAvailableBattlePoints:(long)availablePoints;
-(void)callLayerWithBattleResult:(NSString*)result battlePointsAwarded:(long)points;
-(void)onBattleCompleteAnimationStep1Completed;
-(void)onDoneButtonCompleted;

@property (nonatomic, retain) CCSprite* background;
@property (nonatomic, retain) CCLabelTTF* battleResultText;
@property (nonatomic, retain) CCLabelTTF* battlePointAwardedLabel;
@property (nonatomic, retain) CCLabelTTF* battlePointAvailableLabel;
@property (nonatomic, retain) CCLabelTTF* battlePointAwardedAmountLabel;
@property (nonatomic, retain) CCLabelTTF* battlePointAvailableAmountLabel;
@property (nonatomic, assign) long battlePointAwarded;
@property (nonatomic, assign) long battlePointAvailable;
@property (nonatomic, retain) CCMenu* doneButtonMenu;
@property (nonatomic, retain) CCMenuItemSprite* doneButton;
@property (nonatomic, retain) id battleLayer;
@property (nonatomic, assign) SEL battleLayerSelectorForDoneButton;

@end
