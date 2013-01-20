//
//  NBStage.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 13/1/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBUserInterface.h"

#define STAGE_ICON_WIDTH 32
#define STAGE_ICON_HEIGHT 32

typedef enum
{
    ssLocked = 0,
    ssHidden = 1,
    ssUnlocked = 2,
    ssCompleted
} EnumStageStatus;

@interface NBStage : NSObject

+(id)createStageWithStatus:(EnumStageStatus)newStatus withID:(NSString*)newStageID;
+(id)getCurrentlySelectedStage;
-(void)setAvailableImage:(NSString*)selectedFrame withDisabledImage:(NSString*)disabledFrame onLayer:(CCLayer*)layer selector:(SEL)selector;
-(void)setCompletedImage:(NSString*)selectedFrame withDisabledImage:(NSString*)disabledFrame onLayer:(CCLayer*)layer selector:(SEL)selector;
-(bool)setGridPoint:(CGPoint)point;
-(CGPoint)getActualPosition;
-(void)update;
-(void)onIconSelected;
-(void)createLineFrom:(NBStage*)previousStage onLayer:(CCLayer*)layer;

@property (nonatomic, retain) NSString* stageID;
@property (nonatomic, retain) NSString* previousStageID;
@property (nonatomic, retain) NSString* nextStageID;
@property (nonatomic, retain) NSString* willUnlockStageID;
@property (nonatomic, retain) NSString* canBeUnlockedByStageID;

@property (nonatomic, assign) EnumStageStatus previousStatus;
@property (nonatomic, assign) EnumStageStatus status;
@property (nonatomic, retain) NBButton* worldIcon;
@property (nonatomic, retain) NBButton* worldIconCompleted;
@property (nonatomic, assign) CGPoint positionInWorldGrid;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, retain) id listenerLayer;
@property (nonatomic, assign) SEL selector;

@property (nonatomic, retain) CCArray* enemyList;

@end
