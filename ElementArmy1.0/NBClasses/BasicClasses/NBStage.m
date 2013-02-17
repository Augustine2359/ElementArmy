//
//  NBStage.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 13/1/13.
//
//

#import "NBStage.h"
#import "NBBasicClassData.h"

static NBStage* currentlySelectedStage = nil;
static CCArray* allStageList = nil;

@interface NBStage()

@property (nonatomic, assign) CGFloat currentLineScaleX;
@property (nonatomic, assign) CGFloat currentLineScaleY;
@property (nonatomic, assign) CGPoint currentLineEndPosition;
@property (nonatomic, assign) CGFloat targetScaleX;
@property (nonatomic, assign) CGFloat targetScaleY;

@end

@implementation NBStage

+(NBStage*)getStageByID:(NSString*)stageID
{
    if (allStageList)
    {
        NBStage* stage = nil;
        
        CCARRAY_FOREACH(allStageList, stage)
        {
            if ([stage isKindOfClass:[NBStage class]])
            {
                if ([stage.stageData.stageID isEqualToString:stageID])
                {
                    return stage;
                }
            }
        }
    }
    
    return nil;
}

+(CCArray*)getAllStageList
{
    if (!allStageList)
    {
        allStageList = [[CCArray alloc] initWithCapacity:100];
    }
    
    return allStageList;
}

+(id)createStageWithStageData:(NBStageData*)newStageData
{
    NBStage* stage = [[NBStage alloc] init];
    stage.stageData = newStageData;
    stage.currentLineScaleX = 1;
    stage.currentLineScaleY = 1;
    stage.isUpdatingScaleX = false;
    stage.isUpdatingScaleY = false;
    stage.isConnecting = false;
    stage.nextStageLineCreatedStatus = [CCArray arrayWithNSArray:[NSArray arrayWithObjects:@"0", @"0", @"0", nil]];
    stage.connectorLines = [[CCArray alloc] initWithCapacity:3];
    
    if (!allStageList)
    {
        allStageList = [[CCArray alloc] initWithCapacity:100];
    }
    
    [allStageList addObject:stage];
    
    return stage;
}

+(id)createStageWithStageData:(NBStageData*)newStageData onLayer:(CCLayer*)layer dataManager:(NBDataManager*)dataManager
{
    NBStage* stage = [NBStage createStageWithStageData:newStageData];
    stage.currentLayer = layer;
    stage.currentDataManager = dataManager;
    
    return stage;
}

+(id)getCurrentlySelectedStage
{
    return currentlySelectedStage;
}

-(void)setupIconAndDisplayOnLayer:(CCLayer*)layer selector:(SEL)selector
{
    if (self.stageData)
    {
        if (self.stageData.availableNormalImageName && self.stageData.availableDisabledImageName && self.stageData.completedNormalImageName && self.stageData.completedDisabledImageName)
        {
            self.worldIcon = [NBButton createWithStringHavingNormal:self.stageData.availableNormalImageName havingSelected:self.stageData.availableNormalImageName havingDisabled:self.stageData.availableDisabledImageName onLayer:layer respondTo:self selector:@selector(onIconSelected) withSize:CGSizeZero];
            self.worldIcon.buttonObject.anchorPoint = ccp(0, 0);
            self.listenerLayer = layer;
            self.selector = selector;
            //[self.worldIcon show];
            
            self.worldIconCompleted = [NBButton createWithStringHavingNormal:self.stageData.completedNormalImageName havingSelected:self.stageData.completedNormalImageName havingDisabled:self.stageData.completedDisabledImageName onLayer:layer respondTo:nil selector:@selector(onIconSelected) withSize:CGSizeZero];
            self.worldIconCompleted.buttonObject.anchorPoint = ccp(0, 0);
            self.listenerLayer = layer;
            self.selector = selector;
            //[self.worldIconCompleted hide];
        }
    }
    
}

-(void)setAvailableImage:(NSString*)selectedFrame withDisabledImage:(NSString*)disabledFrame onLayer:(CCLayer*)layer selector:(SEL)selector
{
    self.worldIcon = [NBButton createWithStringHavingNormal:selectedFrame havingSelected:selectedFrame havingDisabled:disabledFrame onLayer:layer respondTo:self selector:@selector(onIconSelected) withSize:CGSizeZero];
    self.worldIcon.buttonObject.anchorPoint = ccp(0, 0);
    self.listenerLayer = layer;
    self.selector = selector;
    //[self.worldIcon show];
}

-(void)setCompletedImage:(NSString*)selectedFrame withDisabledImage:(NSString*)disabledFrame onLayer:(CCLayer*)layer selector:(SEL)selector
{
    self.worldIconCompleted = [NBButton createWithStringHavingNormal:selectedFrame havingSelected:selectedFrame havingDisabled:disabledFrame onLayer:layer respondTo:nil selector:@selector(onIconSelected) withSize:CGSizeZero];
    self.worldIconCompleted.buttonObject.anchorPoint = ccp(0, 0);
    self.listenerLayer = layer;
    self.selector = selector;
    //[self.worldIconCompleted show];
}

-(bool)setupGrid
{
    if (self.worldIcon && self.worldIconCompleted)
    {
        self.positionInWorldGrid = self.stageData.gridPoint;
        self.worldIcon.menu.position = CGPointMake(self.stageData.gridPoint.x * STAGE_ICON_WIDTH / 2, self.stageData.gridPoint.y * STAGE_ICON_HEIGHT / 2);
        self.worldIconCompleted.menu.position = CGPointMake(self.stageData.gridPoint.x * STAGE_ICON_WIDTH / 2, self.stageData.gridPoint.y * STAGE_ICON_HEIGHT / 2);
        self.origin = CGPointMake(self.worldIcon.menu.position.x + (self.worldIcon.currentSize.width / 2), self.worldIcon.menu.position.y + (self.worldIcon.currentSize.height / 2));
        
        return true;
    }
    
    return false;
}

-(CGPoint)getActualPosition
{
    return self.worldIcon.menu.position;
}

-(void)onEnteringStageGrid:(CCLayer*)layer
{
    NSString* connectedStageID = nil;
    
    if (self.stageData.isCompleted)
    {
        NSString* nextStageID = nil;
        self.stageData.connectedStageID = [CCArray arrayWithCapacity:3];
        
        CCARRAY_FOREACH(self.stageData.nextStageID, nextStageID)
        {
            [self.stageData.connectedStageID addObject:nextStageID];
        }
    }
    
    CCARRAY_FOREACH(self.stageData.connectedStageID, connectedStageID)
    {
        NBStage* nextStage = [NBStage getStageByID:connectedStageID];
        [self createLineTo:nextStage onLayer:layer];
    }
    
    NSString* nextStageID = nil;
    
    CCARRAY_FOREACH(self.stageData.nextStageID, nextStageID)
    {
        bool alreadyConnected = false;
        
        CCARRAY_FOREACH(self.stageData.connectedStageID, connectedStageID)
        {
            if ([connectedStageID isEqualToString:nextStageID])
            {
                alreadyConnected = true;
                break;
            }
        }
        
        if (!alreadyConnected)
        {
            NBStage* nextStage = [NBStage getStageByID:nextStageID];
            
            if (nextStage.stageData.isUnlocked)
            {
                [self animateLineTo:[NBStage getStageByID:nextStageID] onLayer:layer];
            }
        }
    }
}

-(void)update
{
    if (self.stageData.isUnlocked)
    {
        if (self.stageData.isCompleted)
        {
            [self.worldIconCompleted show];
            [self.worldIcon hide];
        }
        else
        {
            [self.worldIcon show];
            [self.worldIconCompleted hide];
        }
    }
    else
    {
        /*if (self.worldIcon.menu.visible || self.worldIconCompleted.menu.visible)
        {*/
            [self.worldIcon hide];
            [self.worldIconCompleted hide];
        //}
    }
    
    if (self.isUpdatingScaleX)
    {
        [self updateScaleHorizontal];
    }
    
    if (self.isUpdatingScaleY)
    {
        [self updateScaleVertical];
    }
}

-(void)onIconSelected
{
    currentlySelectedStage = self;
    [self.listenerLayer performSelector:self.selector];
}

/*-(void)createLineFrom:(NBStage*)previousStage onLayer:(CCLayer*)layer
{
    self.connectorLine1 = [CCSprite spriteWithSpriteFrameName:@"stageline.png"];
    self.connectorLine1.anchorPoint = ccp(0, 0);
    self.currentLineScaleX = (self.worldIcon.menu.position.x - previousStage.worldIcon.menu.position.x + self.connectorLine1.contentSize.width) / self.connectorLine1.contentSize.width;
    [self.connectorLine1 setScaleX:self.currentLineScaleX];
    [self.connectorLine1 setScaleY:(5 / self.connectorLine1.contentSize.height)];
    
    self.connectorLine1.position = CGPointMake(previousStage.origin.x - (self.connectorLine1.contentSize.width / 2), previousStage.origin.y - (self.connectorLine1.contentSize.height / 2));
    [layer addChild:self.connectorLine1 z:6];
    [layer reorderChild:previousStage.worldIcon.menu z:5];
    [layer reorderChild:self.worldIcon.menu z:5];
}*/

-(void)createLineTo:(NBStage*)stage onLayer:(CCLayer*)layer
{
    CCSprite* connectorLine = [CCSprite spriteWithSpriteFrameName:@"stageline.png"];
    
    if (stage.worldIcon.menu.position.x < self.worldIcon.menu.position.x)
    {
        connectorLine.anchorPoint = ccp(1, 0);
        connectorLine.position = CGPointMake(self.origin.x + (connectorLine.contentSize.width / 2), self.origin.y - (connectorLine.contentSize.height / 2));
    }
    else if (stage.worldIcon.menu.position.y < self.worldIcon.menu.position.y)
    {
        connectorLine.anchorPoint = ccp(0, 1);
        connectorLine.position = CGPointMake(self.origin.x - (connectorLine.contentSize.width / 2), self.origin.y + (connectorLine.contentSize.height / 2));
    }
    else
    {
        connectorLine.anchorPoint = ccp(0, 0);
        connectorLine.position = CGPointMake(self.origin.x - (connectorLine.contentSize.width / 2), self.origin.y - (connectorLine.contentSize.height / 2));
    }
    
    CGFloat targetScaleX = (abs(stage.worldIcon.menu.position.x - self.worldIcon.menu.position.x) + connectorLine.contentSize.width) / connectorLine.contentSize.width;
    [connectorLine setScaleX:targetScaleX];
    
    CGFloat targetScaleY = (abs(stage.worldIcon.menu.position.y - self.worldIcon.menu.position.y) + connectorLine.contentSize.height) / connectorLine.contentSize.height;
    [connectorLine setScaleY:targetScaleY];

    [layer addChild:connectorLine z:5];
    [layer reorderChild:stage.worldIcon.menu z:6];
    [layer reorderChild:self.worldIcon.menu z:6];
}

-(void)createCompletedLines
{
    CCSprite* connectorLine = nil;
    
    CCARRAY_FOREACH(self.connectorLines, connectorLine)
    {
        if (connectorLine.parent)
        {
            [connectorLine removeFromParentAndCleanup:YES];
        }
        
        [self.currentLayer addChild:connectorLine z:5];
        [self.currentLayer reorderChild:self.worldIcon.menu z:6];
    }
}

-(void)animateLineTo:(NBStage*)nextStage onLayer:(CCLayer*)layer
{
    int index = [self.connectorLines count];
    
    if (index >= 3) return;
    
    self.isConnecting = true;
    
    CCSprite* connectorLine = [CCSprite spriteWithSpriteFrameName:@"stageline.png"];
    
    if (nextStage.worldIcon.menu.position.x < self.worldIcon.menu.position.x)
    {
        connectorLine.anchorPoint = ccp(1, 0);
        connectorLine.position = CGPointMake(self.origin.x + (connectorLine.contentSize.width / 2), self.origin.y - (connectorLine.contentSize.height / 2));
    }
    else if (nextStage.worldIcon.menu.position.y < self.worldIcon.menu.position.y)
    {
        connectorLine.anchorPoint = ccp(0, 1);
        connectorLine.position = CGPointMake(self.origin.x - (connectorLine.contentSize.width / 2), self.origin.y + (connectorLine.contentSize.height / 2));
    }
    else
    {
        connectorLine.anchorPoint = ccp(0, 0);
        connectorLine.position = CGPointMake(self.origin.x - (connectorLine.contentSize.width / 2), self.origin.y - (connectorLine.contentSize.height / 2));
    }
    
    self.targetScaleX = (abs(nextStage.worldIcon.menu.position.x - self.worldIcon.menu.position.x) + connectorLine.contentSize.width) / connectorLine.contentSize.width;
    if (self.targetScaleX != self.currentLineScaleX)
    {
        self.isUpdatingScaleX = true;
    }
    
    self.targetScaleY = (abs(nextStage.worldIcon.menu.position.y - self.worldIcon.menu.position.y) + connectorLine.contentSize.height) / connectorLine.contentSize.height;
    if (self.targetScaleY != self.currentLineScaleY)
    {
        self.isUpdatingScaleY = true;
    }
    
    self.currentlyConnectingToStage = nextStage;
    [layer addChild:connectorLine z:5];
    [layer reorderChild:nextStage.worldIcon.menu z:6];
    [layer reorderChild:self.worldIcon.menu z:6];
        
    [self.connectorLines addObject:connectorLine];
}

-(void)updateScaleHorizontal
{
    bool scaleTargetReached = false;
    
    if (self.targetScaleX > self.currentLineScaleX)
    {
        self.currentLineScaleX = self.currentLineScaleX + LINE_CONNECTOR_SPEED;
        if (self.currentLineScaleX >= self.targetScaleX)
        {
            self.currentLineScaleX = self.targetScaleX;
            scaleTargetReached = true;
        }
    }
    else
    {
        self.currentLineScaleX = self.currentLineScaleX - LINE_CONNECTOR_SPEED;
        if (self.currentLineScaleX <= self.targetScaleX)
        {
            self.currentLineScaleX = self.targetScaleX;
            scaleTargetReached = true;
        }
    }
    
    CCSprite* connectorLine = [self.connectorLines objectAtIndex:[self.connectorLines count] - 1];
    
    [connectorLine setScaleX:self.currentLineScaleX];
    
    if (scaleTargetReached)
    {
        self.isUpdatingScaleX = false;
        self.isConnecting = false;
        self.targetScaleX = 0;
        self.currentLineScaleX = 0;
        [self.stageData.connectedStageID addObject:self.currentlyConnectingToStage.stageData.stageID];
        return;
    }
}

-(void)updateScaleVertical
{
    bool scaleTargetReached = false;
    
    if (self.targetScaleY > self.currentLineScaleY)
    {
        self.currentLineScaleY = self.currentLineScaleY + LINE_CONNECTOR_SPEED;
        if (self.currentLineScaleY >= self.targetScaleY)
        {
            self.currentLineScaleY = self.targetScaleY;
            scaleTargetReached = true;
        }
    }
    else
    {
        self.currentLineScaleY = self.currentLineScaleY - LINE_CONNECTOR_SPEED;
        if (self.currentLineScaleY <= self.targetScaleY)
        {
            self.currentLineScaleY = self.targetScaleY;
            scaleTargetReached = true;
        }
    }
    
    CCSprite* connectorLine = [self.connectorLines objectAtIndex:[self.connectorLines count] - 1];
    
    [connectorLine setScaleY:self.currentLineScaleY];
    
    if (scaleTargetReached)
    {
        self.isUpdatingScaleY = false;
        self.isConnecting = false;
        self.targetScaleY = 0;
        self.currentLineScaleY = 0;
        [self.stageData.connectedStageID addObject:self.currentlyConnectingToStage.stageData.stageID];
        return;
    }
}

-(void)changeParent:(CCLayer*)layer
{
    [self.worldIcon changeParent:layer];
    [self.worldIconCompleted changeParent:layer];
    
    self.currentLayer = layer;
}
@end
