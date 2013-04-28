//
//  NBConnectorLine.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 17/3/13.
//
//

#import "NBConnectorLine.h"

@implementation NBConnectorLine

-(id)createConnectorFrom:(NSString*)originalStageName withGridPoint:(CGPoint)startGrid toStageName:(NSString*)destinationStageName withGridPoint:(CGPoint)endGrid
{
    if (self = [super init])
    {
        self.ownerStageName = originalStageName;
        self.connectToStageName = destinationStageName;
        self.dots = [CCArray array];
        self.dotsData = [CCArray array];
        [self createHorizontalLineFrom:startGrid to:endGrid];
        [self createVerticalLineFrom:lastPointAfterHorizontalIsCreated to:endGrid];
    }
    
    return self;
}

-(void)createHorizontalLineFrom:(CGPoint)start to:(CGPoint)end
{
    if (start.x != end.x)
    {
        int count = start.x - end.x;
        int factor = count /  (ABS(count));
        
        for (int i = 0; i < ABS(count); i++)
        {
            NBConnectorDot* dot = [[NBConnectorDot alloc] init];
            dot.gridPosition = CGPointMake(start.x + (i * factor) + factor, start.y);
            
            lastPointAfterHorizontalIsCreated = dot.gridPosition;
            
            if (factor > 0)
                dot.rotation = 0;
            else
                dot.rotation = 180;
            
            [self.dotsData addObject:dot];
        }
    }
}

-(void)createVerticalLineFrom:(CGPoint)start to:(CGPoint)end
{
    if (start.y != end.y)
    {
        int count = start.y - end.y;
        int factor = count /  (ABS(count));
        
        for (int i = 0; i < ABS(count); i++)
        {
            NBConnectorDot* dot = [[NBConnectorDot alloc] init];
            dot.gridPosition = CGPointMake(start.x, start.y + (i * factor) + factor);
            
            if (factor > 0)
                dot.rotation = 270;
            else
                dot.rotation = 90;
            
            [self.dotsData addObject:dot];
        }
    }
}

-(id)createConnectorFrom:(NSString*)originalStageName toStageName:(NSString*)destinationStageName withDotList:(CCArray*)dotList
{
    if (self = [super init])
    {
        self.ownerStageName = originalStageName;
        self.connectToStageName = destinationStageName;
        self.dots = [[CCArray alloc] initWithCapacity:[dotList count]];
        self.dotsData = dotList;
    }
    
    return self;
}

-(void)setupIconOnLayer:(CCLayer*)layer
{
    self.currentLayer = layer;
    
    if (self.dotsInitialized)
    {
        for (NBSingleAnimatedObject* dot in self.dots)
        {
            [dot removeFromParentAndCleanup:NO];
            [layer addChild:dot z:0];
        }
    }
    else
    {
        for (NBConnectorDot* connectorDot in self.dotsData)
        {
            NBSingleAnimatedObject* dot = [[NBSingleAnimatedObject alloc] initWithSpriteFrameName:@"footStep_1.png"];
            dot.position = CGPointMake((connectorDot.gridPosition.x - 1) * DOT_SQUARE_SIZE, (connectorDot.gridPosition.y) * DOT_SQUARE_SIZE);
            dot.rotation = connectorDot.rotation;
            [dot addAnimationFrameName:@"footStep" withAnimationCount:2 fileExtension:@"png"];
            dot.visible = NO;
            [self.dots addObject:dot];
            
            [layer addChild:dot z:0];
        }
        
        self.dotsInitialized = YES;
    }
}

-(id)initAtPosition:(CGPoint)newPosition toPosition:(CGPoint)destination connectFromSide:(EnumConnectionSide)fromSide withDirection:(EnumLineDirection)direction withLength:(CGFloat)length isVertical:(BOOL)isVertical onLayer:(CCLayer *)layer
{
    if (self = [super init])
    {
        self.isVertical = isVertical;
        self.lineDirection = direction;
        currentDotIndex = 0;
        
        NBSingleAnimatedObject* footStep = [[NBSingleAnimatedObject alloc] initWithSpriteFrameName:@"footStep_0.png"];
        footStep.visible = NO;
        footStep.position = newPosition;
        [footStep addAnimationFrameName:@"footStep" withAnimationCount:2 fileExtension:@"png"];
        [layer addChild:footStep];
        self.heightPerDot = footStep.contentSize.height;
        self.widthPerDot = footStep.contentSize.width;
        
        int objectCountNeeded = 0;
        
        if (self.lineDirection == LineDirectionUp || self.lineDirection == LineDirectionDown)
        {
            objectCountNeeded = length / self.heightPerDot;
        }
        else
        {
            objectCountNeeded = length / self.widthPerDot;
        }
        
        objectCountNeeded++;
        self.dots = [CCArray arrayWithCapacity:objectCountNeeded];
        [self.dots addObject:footStep];
        
        for (int i = 1; i < objectCountNeeded; i++)
        {
            footStep = [[NBSingleAnimatedObject alloc] initWithSpriteFrameName:@"footStep_0.png"];
            footStep.position = newPosition;
            footStep.scaleX = 10 / footStep.contentSize.width;
            footStep.scaleY = 10 / footStep.contentSize.height;
            footStep.visible = NO;
            
            if (fromSide == csRight)
            
            if (destination.x > newPosition.x)
            {
                direction = LineDirectionRight;
            }
            
            switch (self.lineDirection)
            {
                case LineDirectionUp:
                    footStep.position = CGPointMake(newPosition.x, newPosition.y + (footStep.contentSize.height * (i - 1)));
                    footStep.rotation = 270;
                    break;
                case LineDirectionDown:
                    footStep.position = CGPointMake(newPosition.x, newPosition.y - (footStep.contentSize.height * (i - 1)));
                    footStep.rotation = 90;
                    break;
                case LineDirectionRight:
                    footStep.position = CGPointMake(newPosition.x + (footStep.contentSize.width * (i - 1)), newPosition.y);
                    footStep.rotation = 0;
                    break;
                case LineDirectionLeft:
                    footStep.position = CGPointMake(newPosition.x - (footStep.contentSize.width * (i - 1)), newPosition.y);
                    footStep.rotation = 180;
                    break;
            }
            
            [footStep addAnimationFrameName:@"footStep" withAnimationCount:2 fileExtension:@"png"];
            [layer addChild:footStep];
            [self.dots addObject:footStep];
        }
    }

    return self;
}

-(void)show
{
    for (int i = 0; i < [self.dots count]; i++)
    {
        NBSingleAnimatedObject* currentDot = (NBSingleAnimatedObject*)[self.dots objectAtIndex:i];
        currentDot.visible = YES;
    }
}

-(void)animate
{
    if (currentDotIndex >= [self.dots count])
    {
        currentDotIndex = 0;
        return;
    }
 
    NBSingleAnimatedObject* currentDot = (NBSingleAnimatedObject*)[self.dots objectAtIndex:currentDotIndex];
    currentDot.visible = YES;
    [currentDot playAnimationWithDelay:0.1 informToObject:self onSelector:@selector(animationCompleted)];
    currentDotIndex++;
}

-(void)animationCompleted
{
    [self animate];
}

@end
