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

typedef enum
{
    LineDirectionRight,
    LineDirectionLeft,
    LineDirectionUp,
    LineDirectionDown
} EnumLineDirection;

@interface NBConnectorLine : NSObject
{
    int currentDotIndex;
}

-(id)initWithAtPosition:(CGPoint)newPosition withDirection:(EnumLineDirection)direction withLength:(CGFloat)length isVertical:(BOOL)isVertical onLayer:(CCLayer*)layer;
-(void)show;
-(void)animate;
-(void)animationCompleted;

@property (nonatomic, retain) CCArray* dots;
@property (nonatomic, assign) CGFloat widthPerDot;
@property (nonatomic, assign) CGFloat heightPerDot;
@property (nonatomic, assign) BOOL isVertical;
@property (nonatomic, assign) EnumLineDirection lineDirection;

@end
