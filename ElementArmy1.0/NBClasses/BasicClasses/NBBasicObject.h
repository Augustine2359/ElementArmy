//
//  NBBasicObject.h
//  NebulaGame1_2
//
//  Created by Romy Irawaty on 9/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBDataManager.h"

#define MAXIMUM_COLLISION_ALLOWED 3
#define MAXIMUM_OBJECT_IN_WORLD 1000
#define DEFAULT_MAXIMUM_OBJECT_CAPACITY 50
#define OBJECT_SPEED_PIXEL_PER_SECOND 60

typedef enum
{
    Right,
    Left
} EnumFacing;

@interface NBBasicObject : CCNode <CCTargetedTouchDelegate>
{
    CGFloat xSpeedLock;
    CGFloat ySpeedLock;
}

+(void)update:(ccTime)delta;
+(CGPoint)createDirectionFrom:(CGPoint)startPoint to:(CGPoint)destinationPoint;
+(CCArray*)getWorldObjectList;

-(void)initialize;
-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer;
-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setPosition:(CGPoint)position;
-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setRotation:(CGFloat)rotation;
-(id)initWithFrameName:(NSString*)frameName andSpriteBatchNode:(CCSpriteBatchNode*)spriteBatchNode onLayer:(CCLayer*)layer setPosition:(CGPoint)position setRotation:(CGFloat)rotation;
-(void)moveToPosition:(CGPoint)newPosition withDelta:(ccTime)delta;
-(void)moveToDirection:(CGPoint)direction withDelta:(ccTime)delta;
-(void)moveToPosition:(CGPoint)newPosition withDuration:(ccTime)milliseconds;
-(void)moveToPosition:(CGPoint)newPosition withDuration:(ccTime)milliseconds informMoveCompleted:(bool)toInform;
-(BOOL)isTouchingMe:(CGPoint)touchLocation;
-(bool)checkCollisionWith:(NBBasicObject*)otherObject;
-(bool)checkWithinWorld;
-(void)update:(ccTime)delta;
-(void)setToCustomSize:(CGSize)newSize;
-(void)setToDefaultSize;
-(void)setCurrentFrame:(NSString*)frameName;
-(void)reorderMe:(int)z;

//Events
-(void)onTouched;
-(void)onMoveCompleted;
-(void)isCollidedWith:(NBBasicObject*)object;

@property (nonatomic, retain) NBDataManager* dataManager;
@property (nonatomic, assign) int objectIndex;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) int basicSpeedPoint;
@property (nonatomic, retain) CCLayer* currentLayer;
@property (nonatomic, retain) CCSpriteBatchNode* currentSpriteBatchNode;
@property (nonatomic, retain) CCSprite* sprite;
@property (nonatomic, assign) CGPoint currentTargetPosition;
@property (nonatomic, assign) CGPoint currentDirection;
@property (nonatomic, assign) EnumFacing facing;
@property (nonatomic, assign) bool isActive;
@property (nonatomic, assign) CGSize sizeOnScreen;
@property (nonatomic, assign) BOOL isSwallowingTouch;
@property (nonatomic, assign) BOOL isCurrentlyTouched;

@end
