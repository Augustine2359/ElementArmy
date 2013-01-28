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
#import "NBDataManager.h"
#import "NBStageData.h"

#define STAGE_ICON_WIDTH 32
#define STAGE_ICON_HEIGHT 32
#define LINE_CONNECTOR_SPEED 0.05

typedef enum
{
    ssLocked = 0,
    ssHidden = 1,
    ssUnlocked = 2,
    ssCompleted
} EnumStageStatus;

@interface NBStage : NSObject

+(id)createStageWithStageData:(NBStageData*)newStageData;
+(id)createStageWithStageData:(NBStageData *)newStageData onLayer:(CCLayer*)layer dataManager:(NBDataManager*)dataManager;
+(id)getCurrentlySelectedStage;
-(void)setAvailableImage:(NSString*)selectedFrame withDisabledImage:(NSString*)disabledFrame onLayer:(CCLayer*)layer selector:(SEL)selector;
-(void)setCompletedImage:(NSString*)selectedFrame withDisabledImage:(NSString*)disabledFrame onLayer:(CCLayer*)layer selector:(SEL)selector;
-(bool)setupGrid;
-(CGPoint)getActualPosition;
-(void)update;
-(void)onIconSelected;
-(void)createLineFrom:(NBStage*)previousStage onLayer:(CCLayer*)layer;
-(void)createLineTo:(NBStage*)nextStage onLayer:(CCLayer*)layer;
-(void)createCompletedLines;
-(void)animateLineTo:(NBStage*)nextStage onLayer:(CCLayer*)layer;
-(void)updateScaleX:(int)connectorID;
-(void)updateScaleY:(int)connectorID;
-(void)changeParent:(CCLayer*)layer;

@property (nonatomic, retain) NBStageData* stageData;
@property (nonatomic, retain) NSString* previousStageID;
@property (nonatomic, retain) CCArray* nextStageLineCreatedStatus;
@property (nonatomic, retain) NSString* willUnlockStageID;
@property (nonatomic, retain) NSString* canBeUnlockedByStageID;
@property (nonatomic, assign) bool isConnecting;
@property (nonatomic, assign) bool isUpdatingScaleX;
@property (nonatomic, assign) bool isUpdatingScaleY;

@property (nonatomic, assign) EnumStageStatus previousStatus;
@property (nonatomic, assign) EnumStageStatus status;
@property (nonatomic, retain) NBButton* worldIcon;
@property (nonatomic, retain) NBButton* worldIconCompleted;
@property (nonatomic, assign) CGPoint positionInWorldGrid;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, retain) CCArray* connectorLines;
@property (nonatomic, retain) CCSprite* connectorLine2;
@property (nonatomic, retain) CCSprite* connectorLine3;

@property (nonatomic, retain) id listenerLayer;
@property (nonatomic, assign) SEL selector;

@property (nonatomic, retain) CCArray* enemyList;
@property (nonatomic, retain) CCLayer* currentLayer;
@property (nonatomic, retain) NBDataManager* currentDataManager;

@end
