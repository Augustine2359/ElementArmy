//
//  NBStorySet1.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 14/4/13.
//
//

#import "NBStorySet1.h"

@implementation NBStorySet1

-(id)init
{
    if (self = [super init])
    {
        CGSize winsize = [[CCDirector sharedDirector] winSize];
        
        [self initializeEnvironments];
        [self initializeActors];
        [self initializeNarratives];
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Skip..." dimensions:CGSizeZero hAlignment:kCCTextAlignmentLeft fontName:@"Zapfino" fontSize:8];
        self.skipButton = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(onSkipButtonPressed)];
        //CCMenuItem *startGameButtonMenu = [CCMenuItemFont itemWithLabel:label target:self selector:selectedMethod];
        self.menu = [CCMenu menuWithItems:self.skipButton, nil];
        [self.menu setPosition:ccp(winsize.width - 40, 20)];
        [self addChild:self.menu];
        
        self.finishRollLabel = [CCLabelTTF labelWithString:@"Story Completed" dimensions:CGSizeZero hAlignment:kCCTextAlignmentCenter fontName:@"Zapfino" fontSize:20];
        self.finishRollLabel.anchorPoint = ccp(0.5, 0.5);
        self.finishRollLabel.position = ccp(winsize.width / 2, winsize.height / 2);
        self.finishRollLabel.visible = NO;
        [self addChild:self.finishRollLabel];
    }
    
    return self;
}

-(void)setupParentLayer:(id)layer withSelector:(SEL)selector
{
    self.parentLayer = layer;
    self.parentSelector = selector;
}

-(void)initializeActors
{
    self.metalActor1 = [CCSprite spriteWithSpriteFrameName:@"metal_soldier_IDLEanim_1.png"];
    self.metalActor1.opacity = 0;
    [self addChild:self.metalActor1];
    
    self.metalActor2 = [CCSprite spriteWithSpriteFrameName:@"metal_soldier_IDLEanim_1.png"];
    self.metalActor2.opacity = 0;
    [self addChild:self.metalActor2];
    
    self.metalActor3 = [CCSprite spriteWithSpriteFrameName:@"metal_soldier_IDLEanim_1.png"];
    self.metalActor3.opacity = 0;
    [self addChild:self.metalActor3];
    
    self.metalActor4 = [CCSprite spriteWithSpriteFrameName:@"metal_soldier_IDLEanim_1.png"];
    self.metalActor4.opacity = 0;
    [self addChild:self.metalActor4];
    
    self.metalActor5 = [CCSprite spriteWithSpriteFrameName:@"metal_soldier_IDLEanim_1.png"];
    self.metalActor5.opacity = 0;
    [self addChild:self.metalActor5];
}

-(void)initializeEnvironments
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    self.normalSky = [CCSprite spriteWithSpriteFrameName:@"staticbox_sky.png"];
    self.normalSky.scaleX = winsize.width / self.normalSky.contentSize.width;
    self.normalSky.scaleY = winsize.height / self.normalSky.contentSize.height;
    self.normalSky.anchorPoint = ccp(0, 0);
    self.normalSky.position = ccp(0, 0);
    self.normalSky.opacity = 0;
    [self addChild:self.normalSky];
}

-(void)initializeNarratives
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    NSString* narrativeString1 = @"Kingdom of Nebula, a properous union of states. Thousand of years ruling the world of element ............. ........ ........ ....... ........ ......... .......... .......... .......... .......... ........... .........";
    
    self.narrative1 = [CCLabelTTF labelWithString:narrativeString1 dimensions:CGSizeMake(winsize.width - 100, winsize.height / 2) hAlignment:kCCTextAlignmentCenter fontName:@"PF Ronda Seven" fontSize:12];
    self.narrative1.anchorPoint = ccp(0.5, 0.5);
    self.narrative1.position = ccp(winsize.width / 2, winsize.height / 2);
    self.narrative1.opacity = 0;
    [self addChild:self.narrative1];
}

-(void)startStory
{
    self.visible = YES;
    
    [self roll1];
}

-(void)roll1
{
    CCDelayTime* delay1 = [CCDelayTime actionWithDuration:1.5];
    CCDelayTime* delay2 = [CCDelayTime actionWithDuration:1.5];
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:2.0];
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:2.0];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll2)];
    CCSequence* sequence1 = [CCSequence actions:delay1, fadeIn, delay2, callNextRoll, fadeOut, nil];
    [self.narrative1 runAction:sequence1];
}

-(void)roll2
{
    self.metalActor1.position = ccp(100, 100);
    self.metalActor2.position = ccp(200, 75);
    self.metalActor3.position = ccp(75, 56);
    self.metalActor4.position = ccp(310, 140);
    self.metalActor5.position = ccp(135, 180);
    
    CCDelayTime* delay1 = [CCDelayTime actionWithDuration:1.5];
    CCFadeIn* fadeIn1 = [CCFadeIn actionWithDuration:3.0];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(lastRoll)];
    CCSequence* sequence1 = [CCSequence actions:delay1, fadeIn1, callNextRoll, nil];
    [self.metalActor1 runAction:sequence1];
    
    CCDelayTime* delay2 = [CCDelayTime actionWithDuration:1.5];
    CCFadeIn* fadeIn2 = [CCFadeIn actionWithDuration:3.0];
    CCSequence* sequence2 = [CCSequence actions:delay2, fadeIn2, nil];
    [self.metalActor2 runAction:sequence2];
    
    CCDelayTime* delay3 = [CCDelayTime actionWithDuration:1.5];
    CCFadeIn* fadeIn3 = [CCFadeIn actionWithDuration:3.0];
    CCSequence* sequence3 = [CCSequence actions:delay3, fadeIn3, nil];
    [self.metalActor3 runAction:sequence3];
    
    CCDelayTime* delay4 = [CCDelayTime actionWithDuration:1.5];
    CCFadeIn* fadeIn4 = [CCFadeIn actionWithDuration:3.0];
    CCSequence* sequence4 = [CCSequence actions:delay4, fadeIn4, nil];
    [self.metalActor4 runAction:sequence4];

    CCDelayTime* delay5 = [CCDelayTime actionWithDuration:1.5];
    CCDelayTime* delay5_1 = [CCDelayTime actionWithDuration:1.5];
    CCFadeIn* fadeIn5 = [CCFadeIn actionWithDuration:3.0];
    CCSequence* sequence5 = [CCSequence actions:delay5, fadeIn5, nil];
    CCMoveTo* moveTo5 = [CCMoveTo actionWithDuration:3.0 position:ccp(300, 180)];
    CCSequence* sequence5_1 = [CCSequence actions:delay5_1, moveTo5, nil];
    [self.metalActor5 runAction:sequence5];
    [self.metalActor5 runAction:sequence5_1];
    
    CCDelayTime* delaySky = [CCDelayTime actionWithDuration:1.5];
    CCFadeIn* fadeInSky = [CCFadeIn actionWithDuration:3.0];
    CCSequence* sequenceSky = [CCSequence actions:delaySky, fadeInSky, nil];
    [self.normalSky runAction:sequenceSky];
}

-(void)roll3
{
    
}

-(void)lastRoll
{
    self.finishRollLabel.visible = YES;
}

-(void)onSkipButtonPressed
{
    [self.parentLayer performSelector:self.parentSelector];
}

@end
