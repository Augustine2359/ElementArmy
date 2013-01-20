//
//  NBStage.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 13/1/13.
//
//

#import "NBStage.h"

static NBStage* currentlySelectedStage = nil;

@implementation NBStage

+(id)createStageWithStatus:(EnumStageStatus)newStatus withID:(NSString *)newStageID
{
    NBStage* stage = [[NBStage alloc] init];
    stage.status = newStatus;
    stage.stageID = newStageID;
    
    return stage;
}

+(id)getCurrentlySelectedStage
{
    return currentlySelectedStage;
}

-(void)setAvailableImage:(NSString*)selectedFrame withDisabledImage:(NSString*)disabledFrame onLayer:(CCLayer*)layer selector:(SEL)selector
{
    self.worldIcon = [NBButton createWithStringHavingNormal:selectedFrame havingSelected:selectedFrame havingDisabled:disabledFrame onLayer:layer respondTo:self selector:@selector(onIconSelected) withSize:CGSizeZero];
    self.worldIcon.buttonObject.anchorPoint = ccp(0, 0);
    self.listenerLayer = layer;
    self.selector = selector;
}

-(void)setCompletedImage:(NSString*)selectedFrame withDisabledImage:(NSString*)disabledFrame onLayer:(CCLayer*)layer selector:(SEL)selector
{
    self.worldIconCompleted = [NBButton createWithStringHavingNormal:selectedFrame havingSelected:selectedFrame havingDisabled:disabledFrame onLayer:layer respondTo:nil selector:@selector(onIconSelected) withSize:CGSizeZero];
    self.worldIconCompleted.buttonObject.anchorPoint = ccp(0, 0);
    self.listenerLayer = layer;
    self.selector = selector;
}

-(bool)setGridPoint:(CGPoint)point
{
    if (self.worldIcon && self.worldIconCompleted)
    {
        self.positionInWorldGrid = point;
        self.worldIcon.menu.position = CGPointMake(point.x * STAGE_ICON_WIDTH / 2, point.y * STAGE_ICON_HEIGHT / 2);
        self.worldIconCompleted.menu.position = CGPointMake(point.x * STAGE_ICON_WIDTH / 2, point.y * STAGE_ICON_HEIGHT / 2);
        self.origin = CGPointMake(self.worldIcon.menu.position.x + (self.worldIcon.currentSize.width / 2), self.worldIcon.menu.position.y + (self.worldIcon.currentSize.height / 2));
        return true;
    }
    
    return false;
}

-(CGPoint)getActualPosition
{
    return self.worldIcon.menu.position;
}

-(void)update
{
    if (self.status != self.previousStatus)
    {
        switch (self.status)
        {
            case ssHidden:
                [self.worldIcon hide];
                break;
            case ssLocked:
                [self.worldIcon show];
                [self.worldIcon disable];
                break;
            case ssCompleted:
            case ssUnlocked:
                [self.worldIcon show];
                [self.worldIcon enable];
                break;
                
            default:
                break;
        }
        
        self.previousStatus = self.status;
    }
}

-(void)onIconSelected
{
    currentlySelectedStage = self;
    [self.listenerLayer performSelector:self.selector];
}

-(void)createLineFrom:(NBStage*)previousStage onLayer:(CCLayer*)layer
{
    CCSprite* line = [CCSprite spriteWithSpriteFrameName:@"stageline.png"];
    line.anchorPoint = ccp(0, 0);
    [line setScaleX:((self.worldIcon.menu.position.x - previousStage.worldIcon.menu.position.x) / line.contentSize.width)];
    [line setScaleY:(5 / line.contentSize.height)];
    
    CGPoint previousStagePosition = [previousStage getActualPosition];
    line.position = previousStage.origin;
    [layer addChild:line z:6];
    [layer reorderChild:previousStage.worldIcon.menu z:5];
    [layer reorderChild:self.worldIcon.menu z:5];
}

@end
