//
//  NBConnectorLine.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 17/3/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NBSingleAnimatedObject.h"
#import "NBConnectorDot.h"

typedef enum
{
    LineDirectionRight,
    LineDirectionLeft,
    LineDirectionUp,
    LineDirectionDown
} EnumLineDirection;

typedef enum
{
    csRight,
    csLeft,
    csTop,
    csBottom
} EnumConnectionSide;

@interface NBConnectorLine : NSObject
{
    int currentDotIndex;
    CGPoint lastPointAfterHorizontalIsCreated;
}

-(id)createConnectorFrom:(NSString*)originalStageName withGridPoint:(CGPoint)startGrid toStageName:(NSString*)destinationStageName withGridPoint:(CGPoint)endGrid;
-(id)createConnectorFrom:(NSString*)originalStageName toStageName:(NSString*)destinationStageName withDotList:(CCArray*)dotList;
-(void)setupIconOnLayer:(CCLayer*)layer;
-(id)initAtPosition:(CGPoint)newPosition toPosition:(CGPoint)destination connectFromSide:(EnumConnectionSide)fromSide withDirection:(EnumLineDirection)direction withLength:(CGFloat)length isVertical:(BOOL)isVertical onLayer:(CCLayer *)layer;
-(void)show;
-(void)animate;
-(void)animationCompleted;

@property (nonatomic, retain) NSString* ownerStageName;
@property (nonatomic, retain) NSString* connectToStageName;
@property (nonatomic, retain) CCArray* dots;
@property (nonatomic, retain) CCArray* dotsData;
@property (nonatomic, assign) CGFloat widthPerDot;
@property (nonatomic, assign) CGFloat heightPerDot;
@property (nonatomic, assign) BOOL isVertical;
@property (nonatomic, assign) EnumLineDirection lineDirection;
@property (nonatomic, assign) EnumConnectionSide connectFromSide;
@property (nonatomic, retain) CCLayer* currentLayer;
@property (nonatomic, assign) BOOL dotsInitialized;

@end
