//
//  NBFlashingScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 19/4/13.
//
//

#import "NBFlashingScreen.h"

@implementation NBFlashingScreen

+(id)createFlashOnLayer:(CCLayer*)layer callSelectorWhenDone:(SEL)selector
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    NBFlashingScreen* image = [NBFlashingScreen spriteWithSpriteFrameName:@"staticbox_white.png"];
    image.scaleX = winsize.width / image.contentSize.width;
    image.scaleY = winsize.height / image.contentSize.height;
    image.anchorPoint = ccp(0, 0);
    image.position = ccp(0, 0);
    image.opacity = 0;
    [layer addChild:image];
    
    image.screenOwner = layer;
    image.screenSelector = selector;
    
    return image;
}

-(void)setFlashCount:(short)flashCount
{
    _flashCount = flashCount;
    self.currentFlashIndex = 0;
}

-(void)invokeFlash
{
    self.isFlashingNow = true;
    self.currentFlashIndex++;
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.15];
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:0.25];
    CCCallFunc* callNextFlash = [CCCallFunc actionWithTarget:self selector:@selector(invokeNextFlash)];
    CCSequence* sequence = [CCSequence actions:fadeIn, fadeOut, callNextFlash, nil];
    [self runAction:sequence];
}

-(void)invokeNextFlash
{
    bool toWaitNextTry = false;
    
    if (self.currentFlashIndex <= self.flashCount)
    {
        int randomNumber = arc4random() % 2;
        
        if (randomNumber == 0)
            toWaitNextTry = true;
        else
            toWaitNextTry = false;
    }
    else
    {
        self.currentFlashIndex = 0;
        self.isFlashingNow = false;
        [self.screenOwner performSelector:self.screenSelector];
        return;
    }
    
    if (toWaitNextTry)
    {
        CCDelayTime* delay = [CCDelayTime actionWithDuration:0.5];
        CCCallFunc* callNextFlash = [CCCallFunc actionWithTarget:self selector:@selector(invokeNextFlash)];
        CCSequence* sequence = [CCSequence actions:delay, callNextFlash, nil];
        [self runAction:sequence];
    }
    else
    {
        [self invokeFlash];
    }
}

@end
