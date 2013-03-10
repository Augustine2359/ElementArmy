//
//  NBCountryStageGrid.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 15/1/13.
//
//

#import "NBCountryStageGrid.h"

@implementation NBCountryStageGrid

-(id)initOnLayer:(NBBasicScreenLayer*)layer withSize:(CGSize)size withCountryData:(NBCountryData*)newCountryData respondToSelector:(SEL)selector
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //Guard with minimum size...
    if (size.width < (layer.layerSize.width - 32)) size = CGSizeMake((layer.layerSize.width - 32), size.height);
    if (size.height < (layer.layerSize.height * 0.95)) size = CGSizeMake(size.width, (layer.layerSize.height * 0.95));
    
    if (self = [super initWithColor:ccc4(200, 200, 125, 255) width:size.width height:size.height])
    {
        self.countryData = newCountryData;
        self.stageGrid = [[CCArray alloc] initWithCapacity:STAGE_VERTICAL_CAPACITY];
        
        for (int i = 0; i < STAGE_VERTICAL_CAPACITY; i++)
        {
            CCArray* stageHorizontalGrid = [[CCArray alloc] initWithCapacity:STAGE_HORIZONTAL_CAPACITY];
            [self.stageGrid addObject:stageHorizontalGrid];
        }
        
        self.currentLayer = layer;
        self.currentSelector = selector;
        self.stageList = [[CCArray alloc] initWithCapacity:STAGE_VERTICAL_CAPACITY * STAGE_HORIZONTAL_CAPACITY];
        //self.position = CGPointMake((winSize.width / 2) - (self.contentSize.width / 2), (winSize.height / 2) - (self.contentSize.height / 2));
        self.position = CGPointMake(1000, (winSize.height / 2) - (self.contentSize.height / 2));
        [layer addChild:self z:0];
        
        self.isTouchEnabled = YES;
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    
    return self;
}

-(void)onEnter:(CCLayer*)mainLayer
{
    self.visible = NO;
    isEntering = true;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    self.position = CGPointMake(winSize.width - 10, (winSize.height / 2) - (self.contentSize.height / 2));
    self.visible = YES;
    
    //CCMoveTo* move = [CCMoveTo actionWithDuration:2.0 position:CGPointMake((winSize.width / 2) - (self.contentSize.width / 2), (winSize.height / 2) - (self.contentSize.height / 2))];
    CCMoveTo* move = [CCMoveTo actionWithDuration:2.0 position:CGPointMake(0, (winSize.height / 2) - (self.contentSize.height / 2))];
    CCEaseIn* accell = [CCEaseIn actionWithAction:move rate:4.0];
    //CCEaseOut* decell = [CCEaseOut actionWithAction:move rate:0.5];
    CCCallFuncN* animationCompleted = [CCCallFuncN actionWithTarget:self selector:@selector(onEnteringAnimationCompleted)];
    //CCSequence* sequence = [CCSequence actions:accell, decell, animationCompleted, nil];
    CCSequence* sequence = [CCSequence actions:accell, animationCompleted, nil];
    [self runAction:sequence];
}

-(void)onEnteringAnimationCompleted
{
    isEntering = false;
    
    NBStage* stage = nil;
    
    CCARRAY_FOREACH(self.stageList, stage)
    {
        [stage onEnteringStageGrid:self];
    }
    
    [self.currentLayer performSelector:self.currentSelector];
}

-(void)dealloc
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super dealloc];
}

-(void)displayAllStages
{
    
}

-(void)addStage:(NBStage*)stage
{
    //[stage changeParent:self];
    [stage.worldIcon changeParent:self];
    [stage.worldIconCompleted changeParent:self];
    stage.worldIcon.menu.zOrder = WORLD_ICON_Z;
    stage.worldIconCompleted.menu.zOrder = WORLD_ICON_Z;
    [self.stageList addObject:stage];
    
    //if (stage.previousStageID)
    //{
        //[stage createLineFrom:[self getStageByID:stage.previousStageID] onLayer:self];
    //}
}

-(NBStage*)getStageByID:(NSString*)compareStageID
{
    NBStage* stage = nil;
    
    CCARRAY_FOREACH(self.countryData.stageList, stage)
    {
        if ([stage.stageData.stageID isEqualToString:compareStageID])
            return stage;
    }
    
    return nil;
}

-(void)update
{
    NBStage* stage = nil;
    
    if (!isEntering)
        if (self.position.x > GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET) self.position = CGPointMake(GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET, self.position.y);
    
    CCARRAY_FOREACH(self.stageList, stage)
    {
        [stage update];
        
        NSString* nextStageID = nil;
        int connectorIndex = 0;
        
        CCARRAY_FOREACH(stage.stageData.nextStageID, nextStageID)
        {
            if (stage.stageData.isCompleted)
            {
                NBStage* nextStage = [self getStageByID:nextStageID];
                
                CCSprite* connectorLine = nil;
                
                if (stage.connectorLines)
                {
                    if ([stage.connectorLines count] > connectorIndex)
                    {
                        connectorLine = [stage.connectorLines objectAtIndex:connectorIndex];
                        
                        if (connectorLine)
                        {
                            connectorIndex++;
                            continue;
                        }
                    }
                }
                
                if (nextStage.stageData.isUnlocked && !connectorLine && !stage.isConnecting && stage.stageData.winCount == 1)
                {
                    if (!stage.isUpdatingScaleX && !stage.isUpdatingScaleY)
                    {
                        //[stage createLineTo:[self getStageByID:stage.nextStageID] onLayer:self];
                        [stage animateLineTo:nextStage onLayer:self];
                    }
                }
                
                connectorIndex++;
            }
        }
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccp(touchLocation.x - oldTouchLocation.x, 0);
    CGPoint newPos = ccpAdd(self.position, translation);
    
    //Set maximum move for the layer so it does not dissapear from screen :p
    if ((newPos.x + 2 >= GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET) || (self.currentLayer.contentSize.width - (newPos.x + self.contentSize.width + 2) >= GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET))
        newPos = self.position;
        
    self.position = newPos;
}

@end
