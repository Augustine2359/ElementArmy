//
//  NBBasicObject.m
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 9/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NBBasicObject.h"

static int objectCount = 0;
static CCArray* worldObjectList = nil;
static CGSize worldSize;

@implementation NBBasicObject

@synthesize objectIndex;
@synthesize name;
@synthesize currentLayer;
@synthesize sprite;
@synthesize currentTargetPosition, currentDirection;
@synthesize basicSpeedPoint;

+(void)update:(ccTime)delta
{
    if (!worldObjectList) return;
    
    id object;
    
    CCARRAY_FOREACH(worldObjectList, object)
    {
        [object update:delta];
    }
}

+(CGPoint)createDirectionFrom:(CGPoint)startPoint to:(CGPoint)destinationPoint
{
    CGFloat xDiff, yDiff = 0;
    
    CGFloat distance = ccpDistance(startPoint, destinationPoint);
    
    xDiff = destinationPoint.x - startPoint.x;
    yDiff = destinationPoint.y - startPoint.y;
    
    CGFloat xPerFrame = (xDiff / distance);
    CGFloat yPerFrame = (yDiff / distance);
    
    return CGPointMake(xPerFrame, yPerFrame);
}

-(void)setFacing:(EnumFacing)facing
{
    _facing = facing;
    
    if (self.facing == Left)
        self.sprite.flipX = YES;
    else
        self.sprite.flipX = NO;
}

-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer
{
    if (worldSize.width == 0 || worldSize.height == 0)
        worldSize = [[CCDirector sharedDirector] winSize];
    
    if (!worldObjectList)
        worldObjectList = [[CCArray alloc] initWithCapacity:MAXIMUM_OBJECT_IN_WORLD];
        
    if (self = [super init])
    {
        self.sprite = [[CCSprite alloc] initWithSpriteFrameName:frameName];
        [self addChild:self.sprite];
        self.currentLayer = layer;
        self.currentSpriteBatchNode = spriteBatchNode;
        self.objectIndex = [layer.children count];
        self.basicSpeedPoint = OBJECT_SPEED_PIXEL_PER_SECOND;
        
        //Add to the world object list for update
        [worldObjectList addObject:self];
        
        [layer addChild:self];
        
        objectCount++;
        
        //Add touch feature
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        //[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
    }
    
    return self;
}

-(void)dealloc
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    //[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    
    [super dealloc];
    objectCount--;
}

-(void)update:(ccTime)delta
{
}

-(void)moveToPosition:(CGPoint)newPosition withDelta:(ccTime)delta
{
    CGPoint nextPosition = self.position;
    bool xArrived = false;
    bool yArrived = false;
    CGFloat xDiff, yDiff = 0;
    
    CGFloat distance = ccpDistance(self.position, newPosition);
    
    if ((self.currentTargetPosition.x != newPosition.x) || (self.currentTargetPosition.y != newPosition.y))
    {
        //Maybe can add move animation here
        //[animation playAnimation:@"Move" withDelay:0.1 andRepeatForever:YES withTarget:nil andSelector:nil];
        
        xDiff = newPosition.x - self.position.x;
        yDiff = newPosition.y - self.position.y;
        
        CGFloat xPerFrame = (self.basicSpeedPoint / distance * xDiff);
        CGFloat yPerFrame = (self.basicSpeedPoint / distance * yDiff);
        
        xSpeedLock = xPerFrame;
        ySpeedLock = yPerFrame;
        
        self.currentTargetPosition = newPosition;
    }
    
    self.currentDirection = CGPointMake(xSpeedLock * delta, ySpeedLock * delta);
    
    xDiff = abs(self.currentTargetPosition.x - self.position.x);
    if (xDiff < 2)
    {
        self.position = CGPointMake(self.currentTargetPosition.x, self.position.y);
        xArrived = true;
    }
    
    yDiff = abs(self.currentTargetPosition.y - self.position.y);
    if (yDiff < 2)
    {
        self.position = CGPointMake(self.position.x, self.currentTargetPosition.y);
        yArrived = true;
    }
    
    if (!xArrived || !yArrived)
    {
        nextPosition = ccpAdd(self.position, self.currentDirection);
        self.position = nextPosition;
    }
    else
        [self onMoveCompleted];
}

-(void)moveToDirection:(CGPoint)direction withDelta:(ccTime)delta
{
    self.position = ccpAdd(self.position, ccpMult(direction, self.basicSpeedPoint));
    
    NBBasicObject* object = nil;
    int collisionCount = 0;
    
    CCARRAY_FOREACH(worldObjectList, object)
    {
        collisionCount = 0;
        
        if (object != self)
        {
            if (object.isActive)
            {
                if ([self checkCollisionWith:object])
                {
                    collisionCount++;
                    [self isCollidedWith:object];
                    
                    if (collisionCount > MAXIMUM_COLLISION_ALLOWED)
                        continue;
                }
            }
        }
    }
    
    if (![self checkWithinWorld])
    {
        self.isActive = false;
        self.visible = NO;
    }
}

-(BOOL)isTouchingMe:(CGPoint)touchLocation
{
    BOOL isTouched = false;
    
    //NSLog(@"touch location x = %f y = %f", touchLocation.x, touchLocation.y);
    //NSLog(@"%@ location x = %f y = %f width = %f", self.name, self.position.x, self.position.y, self.characterSprite.contentSize.width);
    
    if (((touchLocation.x >= (self.position.x - (self.sprite.contentSize.width / 2.5))) && (touchLocation.x <= (self.position.x + (self.sprite.contentSize.width / 2.5)))) &&
        ((touchLocation.y >= (self.position.y - (self.sprite.contentSize.height / 4))) && (touchLocation.y <= (self.position.y + (self.sprite.contentSize.height / 4)))))
    {
        isTouched = YES;
    }
    
    return isTouched;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL returnValue = NO;
    
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    //NSLog(@"%@ current origin x = %f, y = %f with size = %f", self.name, [self.characterSprite boundingBox].origin.x, [self.characterSprite boundingBox].origin.y, [self.characterSprite boundingBox].size.width);
    returnValue = [self isTouchingMe:touchLocation];
    
    if (returnValue == YES)
        [self onTouched];
    
    return returnValue;
}

-(bool)checkCollisionWith:(NBBasicObject*)otherObject
{
    //CGRect myBoundingBox = CGRectMake(self.position.x, self.position.y, [self boundingBox].size.width, [self boundingBox].size.height);
    //CGRect otherObjectBoundingBox = CGRectMake(otherObject.position.x, otherObject.position.y, [otherObject boundingBox].size.width, [otherObject boundingBox].size.height);
    CGRect myBoundingBox = CGRectMake(self.position.x, self.position.y, self.sprite.contentSize.width / 2, self.sprite.contentSize.height / 2);
    CGRect otherObjectBoundingBox = CGRectMake(otherObject.position.x, otherObject.position.y, otherObject.sprite.contentSize.width / 2, otherObject.sprite.contentSize.height / 2);
    
    return CGRectIntersectsRect(myBoundingBox, otherObjectBoundingBox);
}

-(bool)checkWithinWorld
{
    if ((self.position.x + self.sprite.contentSize.width) > 0 && ((self.position.x - self.sprite.contentSize.width) < worldSize.width) &&
        (self.position.y + self.sprite.contentSize.height) > 0 && (self.position.y - self.sprite.contentSize.height) < worldSize.height)
    {
        return true;
    }
    else
    {
        return false;
    }
}

//Events
-(void)onTouched
{
    NSLog(@"%@ is touched", self.name);
}

-(void)onMoveCompleted
{
    NSLog(@"%@ move completed", self.name);
}

-(void)isCollidedWith:(NBBasicObject*)object
{
    NSLog(@"%@ is collided with %@", self.name, object.name);
}

@end
