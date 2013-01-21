//
//  NBCountryStageGrid.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 15/1/13.
//
//

#import "NBBasicScreenLayer.h"
#import "NBCountryStageGrid.h"

@implementation NBCountryStageGrid

-(id)initOnLayer:(NBBasicScreenLayer*)layer withSize:(CGSize)size
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //Guard with minimum size...
    if (size.width < (layer.layerSize.width - 32)) size = CGSizeMake((layer.layerSize.width - 32), size.height);
    if (size.height < (layer.layerSize.height * 0.95)) size = CGSizeMake(size.width, (layer.layerSize.height * 0.95));
    
    if (self = [super initWithColor:ccc4(200, 200, 125, 255) width:size.width height:size.height])
    {
        self.stageGrid = [CCArray arrayWithCapacity:STAGE_VERTICAL_CAPACITY];
        
        for (int i = 0; i < STAGE_VERTICAL_CAPACITY; i++)
        {
            CCArray* stageHorizontalGrid = [CCArray arrayWithCapacity:STAGE_HORIZONTAL_CAPACITY];
            [self.stageGrid addObject:stageHorizontalGrid];
        }
        
        self.currentLayer = layer;
        self.stageList = [CCArray arrayWithCapacity:STAGE_VERTICAL_CAPACITY * STAGE_HORIZONTAL_CAPACITY];
        self.position = CGPointMake((winSize.width / 2) - (self.contentSize.width / 2), (winSize.height / 2) - (self.contentSize.height / 2));
        [layer addChild:self z:0];
        
        self.isTouchEnabled = YES;
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    
    return self;
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
    [stage.worldIcon changeParent:self];
    [stage.worldIconCompleted changeParent:self];
    
    [self.stageList addObject:stage];
    
    if (stage.previousStageID)
    {
        /*CCSprite* line = [CCSprite spriteWithSpriteFrameName:@"stageline.png"];
        line.anchorPoint = ccp(0, 0);
        [line setScaleX:(100 / line.contentSize.width)];
        [line setScaleY:(5 / line.contentSize.height)];
        
        NBStage* previousStage = [self getStageByID:stage.previousStageID];
        line.position = [previousStage getActualPosition];
        [self addChild:line z:2];
        [self reorderChild:previousStage.worldIcon.menu z:5];
        [self reorderChild:stage.worldIcon.menu z:5];*/
        
        [stage createLineFrom:[self getStageByID:stage.previousStageID] onLayer:self];
    }
}

-(NBStage*)getStageByID:(NSString*)compareStageID
{
    NBStage* stage = nil;
    
    CCARRAY_FOREACH(self.stageList, stage)
    {
        if ([stage.stageID isEqualToString:compareStageID])
            return stage;
    }
    
    return nil;
}

-(void)update
{
    NBStage* stage = nil;
    
    if (self.position.x > GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET) self.position = CGPointMake(GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET, self.position.y);
    
    CCARRAY_FOREACH(self.stageList, stage)
    {
        [stage update];
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
    if ((newPos.x >= GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET) || (self.currentLayer.contentSize.width - (newPos.x + self.contentSize.width) >= GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET))
        newPos = self.position;
        
    self.position = newPos;
}

@end
