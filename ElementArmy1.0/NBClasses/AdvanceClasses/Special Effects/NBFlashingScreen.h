//
//  NBFlashingScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 19/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NBFlashingScreen : CCSprite

+(id)createFlashOnLayer:(CCLayer*)layer callSelectorWhenDone:(SEL)selector;
-(void)invokeFlash;

@property (nonatomic, assign) short flashCount;
@property (nonatomic, assign) short currentFlashIndex;
@property (nonatomic, retain) id screenOwner;
@property (nonatomic, assign) SEL screenSelector;

@end
