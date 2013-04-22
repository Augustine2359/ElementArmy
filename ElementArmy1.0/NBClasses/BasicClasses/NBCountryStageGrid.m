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
    if (size.height > (layer.layerSize.height * 0.95)) size = CGSizeMake(size.width, (layer.layerSize.height * 0.95));
    
    if (self = [super initWithColor:ccc4(200, 200, 125, 255) width:size.width height:size.height])
    {
        self.anchorPoint = ccp(0, 0);
        
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
        
        if (self.countryData.gridBackgroundImage && ![self.countryData.gridBackgroundImage isEqualToString:@""])
        {
            self.background = [CCSprite spriteWithSpriteFrameName:self.countryData.gridBackgroundImage];
            self.background.scaleX = self.contentSize.width / self.background.contentSize.width;
            self.background.scaleY = self.contentSize.height / self.background.contentSize.height;
            self.background.position = CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2);
            [self addChild:self.background z:0];
        }
        
        self.contentSize = CGSizeMake(self.background.boundingBox.size.width, self.background.boundingBox.size.height);
        
        self.isTouchEnabled = YES;
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        isDragging = NO;
		lasty = 0.0f;
		xvel = 0.0f;
		direction = BounceDirectionStayingStill;
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
    CCMoveTo* move = [CCMoveTo actionWithDuration:1.5 position:CGPointMake(0, (winSize.height / 2) - (self.contentSize.height / 2))];
    CCEaseIn* accell = [CCEaseIn actionWithAction:move rate:3.0];
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
    
    /*CCARRAY_FOREACH(self.stageList, stage)
    {
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
                
                if (stage.isConnected)
                {
                    NBConnectorLine* connector = [[NBConnectorLine alloc] initWithAtPosition:CGPointMake(stage.worldIcon.menu.position.x + 16, stage.worldIcon.menu.position.y + 16)
                                                                               withDirection:LineDirectionRight withLength:ccpDistance(stage.worldIcon.menu.position, nextStage.worldIcon.menu.position) isVertical:NO onLayer:self];
                    [connector show];
                }
                
                if (!stage.isConnected && nextStage.stageData.isUnlocked && !connectorLine && !stage.isConnecting && stage.stageData.winCount == 1)
                {
                    NBConnectorLine* connector = [[NBConnectorLine alloc] initWithAtPosition:CGPointMake(stage.worldIcon.menu.position.x + 16, stage.worldIcon.menu.position.y + 16)
                                                                               withDirection:LineDirectionRight withLength:ccpDistance(stage.worldIcon.menu.position, nextStage.worldIcon.menu.position) isVertical:NO onLayer:self];
                    [connector animate];
                    stage.isConnected = true;
                    
                    if (!stage.isUpdatingScaleX && !stage.isUpdatingScaleY)
                    {
                        //[stage createLineTo:[self getStageByID:stage.nextStageID] onLayer:self];
                        //[stage animateLineTo:nextStage onLayer:self];
                    }
                }
                
                connectorIndex++;
            }
        }
    }*/
    
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
    
    DLog(@"width=%f, height=%f", stage.worldIcon.buttonObject.normalImage.contentSize.width, stage.worldIcon.buttonObject.contentSize.height);
    
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

-(void)update:(ccTime)delta
{
    NBStage* stage = nil;
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    if (!isEntering)
    {
        if (self.position.x > GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET)
            self.position = CGPointMake(GRID_LAYER_MAXIMUM_HORIZONTAL_OFFSET, self.position.y);
        
        if (self.position.x < (winsize.width - self.contentSize.width))
            self.position = CGPointMake((winsize.width - self.contentSize.width), self.position.y);
    }
    
    if (!isEntering)
    {
        CCARRAY_FOREACH(self.stageList, stage)
        {
            [stage update];
            
            NSString* nextStageID = nil;
            int connectorIndex = 0;
            
            CCARRAY_FOREACH(stage.stageData.nextStageDataList, nextStageID)
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
                    
                    /*if (stage.isConnected)
                    {
                        NBConnectorLine* connector = [[NBConnectorLine alloc] initWithAtPosition:CGPointMake(stage.worldIcon.menu.position.x + 16, stage.worldIcon.menu.position.y + 16)
                                                                                   withDirection:LineDirectionRight withLength:ccpDistance(stage.worldIcon.menu.position, nextStage.worldIcon.menu.position) isVertical:NO onLayer:self];
                        [connector show];
                    }*/
                    
                    /*if (!stage.isConnected && nextStage.stageData.isUnlocked && !connectorLine && !stage.isConnecting && stage.stageData.winCount == 1)
                    {
                        NBConnectorLine* connector = [[NBConnectorLine alloc] initWithAtPosition:CGPointMake(stage.worldIcon.menu.position.x + 16, stage.worldIcon.menu.position.y + 16)
                                                                                   withDirection:LineDirectionRight withLength:ccpDistance(stage.worldIcon.menu.position, nextStage.worldIcon.menu.position) isVertical:NO onLayer:self];
                        [connector animate];
                        stage.isConnected = true;
                        
                        if (!stage.isUpdatingScaleX && !stage.isUpdatingScaleY)
                        {
                            //[stage createLineTo:[self getStageByID:stage.nextStageID] onLayer:self];
                            //[stage animateLineTo:nextStage onLayer:self];
                        }
                    }*/
                    
                    connectorIndex++;
                }
            }
        }
        
        [self updateScroll:delta];
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    isDragging = YES;
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint preLocation = [touch previousLocationInView:[touch view]];
	CGPoint curLocation = [touch locationInView:[touch view]];
	
	CGPoint a = [[CCDirector sharedDirector] convertToGL:preLocation];
	CGPoint b = [[CCDirector sharedDirector] convertToGL:curLocation];
	
	CGPoint nowPosition = self.position;
	nowPosition.x += ( b.x - a.x );
	self.position = nowPosition;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    isDragging = NO;
}

-(void)updateScroll:(ccTime)delta
{
	CGPoint pos = self.position;
	// positions for scrollLayer
	
	float right = pos.x + /*[self boundingBox].origin.x + */self.contentSize.width;
	float left = pos.x + [self boundingBox].origin.x;
	// Bounding area of scrollview
	float minX = [self boundingBox].origin.x;
	float maxX = [self boundingBox].origin.x + [self boundingBox].size.width;
	
	if (!isDragging)
    {
		static float friction = 0.96f;
		
		if (left > minX && direction != BounceDirectionGoingLeft)
        {
			
			xvel = 0;
			direction = BounceDirectionGoingLeft;
			
		}
		else if (right < maxX && direction != BounceDirectionGoingRight)
        {
			
			xvel = 0;
			direction = BounceDirectionGoingRight;
		}
		
		if (direction == BounceDirectionGoingRight)
		{
			if (xvel >= 0)
			{
				float delta = (maxX - right);
				float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
				xvel = yDeltaPerFrame;
			}
			
			if ((right + 0.5f) == maxX)
			{
				pos.x = right -  self.contentSize.width;
				xvel = 0;
				direction = BounceDirectionStayingStill;
			}
		}
		else if(direction == BounceDirectionGoingLeft)
		{
			
			if (xvel <= 0)
			{
				float delta = (minX - left);
				float yDeltaPerFrame = (delta / (BOUNCE_TIME * FRAME_RATE));
				xvel = yDeltaPerFrame;
			}
			
			if ((left + 0.5f) == minX)
            {
				pos.x = left - [self boundingBox].origin.x;
				xvel = 0;
				direction = BounceDirectionStayingStill;
			}
		}
		else
		{
			xvel *= friction;
		}
		
		pos.x += xvel;
		
		self.position = pos;
	}
	else
	{
		if (left <= minX || right >= maxX)
        {
			direction = BounceDirectionStayingStill;
		}
		
		if (direction == BounceDirectionStayingStill)
        {
			xvel = (pos.x - lasty)/2;
			lasty = pos.x;
		}
	}
}

@end
