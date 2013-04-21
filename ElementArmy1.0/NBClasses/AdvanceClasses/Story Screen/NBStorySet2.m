//
//  NBStorySet2.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 19/4/13.
//
//

#import "NBStorySet2.h"

@implementation NBStorySet2

-(id)init
{
    if (self = [super init])
    {
        CGSize winsize = [[CCDirector sharedDirector] winSize];
        
        [self initializeEnvironments];
        [self initializeNarratives];
        [self initializeActors];
        
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
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    self.darkLordImage = [CCSprite spriteWithSpriteFrameName:@"boss_barbarian_IDLE_1.png"];
    self.darkLordImage.scale = 4;
    self.darkLordImage.anchorPoint = ccp(0.5, 0.5);
    self.darkLordImage.position = ccp(winsize.width / 2, -100);
    self.darkLordImage.opacity = 0;
    [self addChild:self.darkLordImage];
}

-(void)initializeEnvironments
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    self.storyBackgroundImage1 = [CCSprite spriteWithSpriteFrameName:@"nebula stage selection map.jpg"];
    self.storyBackgroundImage1.scaleX = winsize.width / self.storyBackgroundImage1.contentSize.width;
    self.storyBackgroundImage1.scaleY = winsize.height / self.storyBackgroundImage1.contentSize.height;
    self.storyBackgroundImage1.anchorPoint = ccp(0, 0);
    self.storyBackgroundImage1.position = ccp(0, -100);
    self.storyBackgroundImage1.opacity = 0;
    [self addChild:self.storyBackgroundImage1];
    
    self.storyBackgroundImage2 = [CCSprite spriteWithSpriteFrameName:@"NB_worldMap_960x480.png"];
    self.storyBackgroundImage2.scaleX = winsize.width / self.storyBackgroundImage1.contentSize.width;
    self.storyBackgroundImage2.scaleY = winsize.height / self.storyBackgroundImage1.contentSize.height;
    self.storyBackgroundImage2.anchorPoint = ccp(0, 0);
    self.storyBackgroundImage2.position = ccp(0, -100);
    self.storyBackgroundImage2.opacity = 0;
    [self addChild:self.storyBackgroundImage2];
    
    self.flashingScreen = [NBFlashingScreen createFlashOnLayer:self callSelectorWhenDone:@selector(onFlashingCompleted)];
    self.flashingScreen.flashCount = 5;
    
    self.redFlash = [CCSprite spriteWithSpriteFrameName:@"staticbox_white.png"];
    self.redFlash.scaleX = winsize.width / self.redFlash.contentSize.width;
    self.redFlash.scaleY = winsize.height / self.redFlash.contentSize.height;
    self.redFlash.anchorPoint = ccp(0, 0);
    self.redFlash.position = ccp(0, 0);
    self.redFlash.opacity = 0;
    self.redFlash.color = ccRED;
    [self addChild:self.redFlash];
    
    self.whiteFlash = [CCSprite spriteWithSpriteFrameName:@"staticbox_white.png"];
    self.whiteFlash.scaleX = winsize.width / self.whiteFlash.contentSize.width;
    self.whiteFlash.scaleY = winsize.height / self.whiteFlash.contentSize.height;
    self.whiteFlash.anchorPoint = ccp(0, 0);
    self.whiteFlash.position = ccp(0, 0);
    self.whiteFlash.opacity = 0;
    self.whiteFlash.color = ccWHITE;
    [self addChild:self.whiteFlash];
    
    self.gameTitle1 = [CCLabelTTF labelWithString:@"Barbie" dimensions:CGSizeZero hAlignment:kCCTextAlignmentCenter fontName:@"Palatino" fontSize:68];
    self.gameTitle1.color = ccBLUE;
    self.gameTitle1.anchorPoint = ccp(0.5f, 0.5f);
    self.gameTitle1.position = ccp(winsize.width / 2, winsize.height / 2 + 25);
    self.gameTitle1.visible = NO;
    [self addChild:self.gameTitle1];
    
    self.gameTitle2 = [CCLabelTTF labelWithString:@"Warriors Of The Elements" dimensions:CGSizeZero hAlignment:kCCTextAlignmentCenter fontName:@"Palatino" fontSize:14];
    self.gameTitle2.color = ccBLUE;
    self.gameTitle2.anchorPoint = ccp(0.5f, 0.5f);
    self.gameTitle2.position = ccp(winsize.width / 2, winsize.height / 2 - 10);
    self.gameTitle2.visible = NO;
    [self addChild:self.gameTitle2];
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
    [self callNarrativeNormalRoll:@"Kingdom of Nebula, a properous union of states. Thousand of years ruling the world of element ............. ........ ........ ....... ........ ......... .......... .......... .......... .......... ........... ........." nextRoll:@selector(roll2) stay:false];
}

-(void)roll2
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:(5.0 / STORY_SPEED)];
    [self.storyBackgroundImage1 runAction:fadeIn];
    
    CCMoveBy* moveBy_0 = [CCMoveBy actionWithDuration:(6.0 / STORY_SPEED) position:ccp(0, winsize.height - 150)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll3)];
    CCSequence* sequence_0 = [CCSequence actions:moveBy_0, callNextRoll, nil];
    [self.storyBackgroundImage1 runAction:sequence_0];
}

-(void)roll3
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    CCMoveBy* moveBy_0 = [CCMoveBy actionWithDuration:(7.0 / STORY_SPEED) position:ccp(0, winsize.height - 50)];
    [self.storyBackgroundImage1 runAction:moveBy_0];
    
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:(2.5 / STORY_SPEED)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll4)];
    CCSequence* sequence_0 = [CCSequence actions:fadeOut, callNextRoll, nil];
    [self.storyBackgroundImage1 runAction:sequence_0];
}

-(void)roll4
{
    [self callNarrativeNormalRoll:@"And there are much more story to tell like blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah" nextRoll:@selector(roll5) stay:false];
}

-(void)roll5
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:(5.0 / STORY_SPEED)];
    [self.storyBackgroundImage2 runAction:fadeIn];
    
    CCMoveBy* moveBy_0 = [CCMoveBy actionWithDuration:(6.0 / STORY_SPEED) position:ccp(0, winsize.height - 150)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll6)];
    CCSequence* sequence_0 = [CCSequence actions:moveBy_0, callNextRoll, nil];
    [self.storyBackgroundImage2 runAction:sequence_0];
}

-(void)roll6
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    CCMoveBy* moveBy_0 = [CCMoveBy actionWithDuration:(7.0 / STORY_SPEED) position:ccp(0, winsize.height - 50)];
    [self.storyBackgroundImage2 runAction:moveBy_0];
    
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:(2.5 / STORY_SPEED)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll7)];
    CCSequence* sequence_0 = [CCSequence actions:fadeOut, callNextRoll, nil];
    [self.storyBackgroundImage2 runAction:sequence_0];
}

-(void)roll7
{
    [self callNarrativeNormalRoll:@"And suddenly there are many very nice flashing effect out of nowhere. After this i think the dark lord will appear...OMG!!!!!!" nextRoll:@selector(roll8) stay:false];
}

-(void)roll8
{
    CGSize winsize = [[CCDirector sharedDirector] winSize];
    
    [self reorderChild:self.flashingScreen z:(self.darkLordImage.zOrder + 1)];
    DLog(@"%i %i", self.flashingScreen.zOrder, self.darkLordImage.zOrder);
    
    [self.flashingScreen invokeFlash];
    
    self.storyBackgroundImage2.opacity = 0;
    self.storyBackgroundImage2.position = ccp(0, winsize.height);
    
    CCFadeIn* fadeIn_0 = [CCFadeIn actionWithDuration:(5.0 / STORY_SPEED)];
    [self.storyBackgroundImage2 runAction:fadeIn_0];
    
    CCMoveTo* moveTo_0 = [CCMoveTo actionWithDuration:(6.0 / STORY_SPEED) position:ccp(0, 0)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll9)];
    CCSequence* sequence_0 = [CCSequence actions:moveTo_0, callNextRoll, nil];
    [self.storyBackgroundImage2 runAction:sequence_0];
    
    self.darkLordImage.position = ccp(winsize.width / 2, -120);
    CCFadeIn* fadeIn_1 = [CCFadeIn actionWithDuration:(5.0 / STORY_SPEED)];
    [self.darkLordImage runAction:fadeIn_1];
    
    CCMoveBy* moveTo_1 = [CCMoveTo actionWithDuration:(6.0 / STORY_SPEED) position:ccp(winsize.width / 2, (winsize.height / 2) + 20)];
    [self.darkLordImage runAction:moveTo_1];
}

-(void)roll9
{
    if (self.flashingScreen.isFlashingNow)
    {
        CCDelayTime* delay_0 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
        CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll9)];
        CCSequence* sequence_0 = [CCSequence actions:delay_0, callNextRoll, nil];
        [self runAction:sequence_0];
    }
    else
    {
        CCDelayTime* delay_0 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
        CCFadeTo* fadeTo_0 = [CCFadeTo actionWithDuration:(4.0f / STORY_SPEED) opacity:175];
        CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll10)];
        CCSequence* sequence_0 = [CCSequence actions:delay_0, fadeTo_0, callNextRoll, nil];
        [self.redFlash runAction:sequence_0];
    }
}

-(void)roll10
{
    CCDelayTime* delay_0 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
    CCFadeOut* fadeOut_0 = [CCFadeOut actionWithDuration:3.0f / STORY_SPEED];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll11)];
    CCSequence* sequence_0 = [CCSequence actions:delay_0, fadeOut_0, callNextRoll, nil];
    [self.storyBackgroundImage2 runAction:sequence_0];
    
    CCDelayTime* delay_1 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
    CCFadeOut* fadeOut_1 = [CCFadeOut actionWithDuration:3.0f / STORY_SPEED];
    CCSequence* sequence_1 = [CCSequence actions:delay_1, fadeOut_1, nil];
    [self.darkLordImage runAction:sequence_1];
    
    CCDelayTime* delay_2 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
    CCFadeOut* fadeOut_2 = [CCFadeOut actionWithDuration:3.0f / STORY_SPEED];
    CCSequence* sequence_2 = [CCSequence actions:delay_2, fadeOut_2, nil];
    [self.redFlash runAction:sequence_2];
}

-(void)roll11
{
    [self callNarrativeNormalRoll:@"then there is this hero (maybe a legendary boy or something), born in metal kingdom, who were not affected by the blinding flash. This is his destiny, something like beong the chosen one by the guardians of elements, being called to take up his sword to defeat the dark lord." nextRoll:@selector(roll12) stay:false];
}

-(void)roll12
{
    [self callNarrativeNormalRoll:@"Thus begin his journey....." nextRoll:@selector(roll13) stay:true];
}

-(void)roll13
{
    CCFadeIn* fadeIn_0 = [CCFadeIn actionWithDuration:(1.25f / STORY_SPEED)];
    CCDelayTime* delay_0 = [CCDelayTime actionWithDuration:(5.0f / STORY_SPEED)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll14)];
    CCSequence* sequence_0 = [CCSequence actions:fadeIn_0, delay_0, callNextRoll, nil];
    [self.whiteFlash runAction:sequence_0];
}

-(void)roll14
{
    [self reorderChild:self.whiteFlash z:(self.gameTitle1.zOrder + 5)];
    
    self.gameTitle1.visible = YES;
    self.gameTitle2.visible = YES;
    self.narrative1.opacity = 0;
    
    CCFadeOut* fadeOut_0 = [CCFadeOut actionWithDuration:(5.0f / STORY_SPEED)];
    CCDelayTime* delay_0 = [CCDelayTime actionWithDuration:(5.0f / STORY_SPEED)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:@selector(roll15)];
    CCSequence* sequence_0 = [CCSequence actions:fadeOut_0, delay_0, callNextRoll, nil];
    [self.whiteFlash runAction:sequence_0];
}

-(void)roll15
{
    [self lastRoll];
}

-(void)lastRoll
{
    self.finishRollLabel.visible = YES;
}

-(void)callNarrativeNormalRoll:(NSString*)text nextRoll:(SEL)selector stay:(bool)stay
{
    [self.narrative1 setString:text];
    
    CCDelayTime* delay1 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
    CCDelayTime* delay2 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:(2.0 / STORY_SPEED)];
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:(2.0 / STORY_SPEED)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:selector];
    CCSequence* sequence1 = nil;
    
    if (!stay)
    {
        sequence1 = [CCSequence actions:delay1, fadeIn, delay2, fadeOut, callNextRoll, nil];
    }
    else
    {
        sequence1 = [CCSequence actions:delay1, fadeIn, delay2, callNextRoll, nil];
    }
    
    [self.narrative1 runAction:sequence1];
}

-(void)onSkipButtonPressed
{
    [self.parentLayer performSelector:self.parentSelector];
}

-(void)onFlashingCompleted
{
    //[self lastRoll];
}

@end
