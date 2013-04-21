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
    [self callNarrativeNormalRoll:@"Kingdom of Nebula, a properous union of states. Thousand of years ruling the world of element ............. ........ ........ ....... ........ ......... .......... .......... .......... .......... ........... ........." nextRoll:@selector(roll2)];
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
    [self callNarrativeNormalRoll:@"And there are much more story to tell like blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah" nextRoll:@selector(roll5)];
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
    [self callNarrativeNormalRoll:@"And suddenly there are many very nice flashing effect out of nowhere. After this i think the dark lord will appear...OMG!!!!!!" nextRoll:@selector(roll8)];
}

-(void)roll8
{
    [self.flashingScreen invokeFlash];
}

-(void)lastRoll
{
    self.finishRollLabel.visible = YES;
}

-(void)callNarrativeNormalRoll:(NSString*)text nextRoll:(SEL)selector
{
    [self.narrative1 setString:text];
    
    CCDelayTime* delay1 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
    CCDelayTime* delay2 = [CCDelayTime actionWithDuration:(1.5 / STORY_SPEED)];
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:(2.0 / STORY_SPEED)];
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:(2.0 / STORY_SPEED)];
    CCCallFunc* callNextRoll = [CCCallFunc actionWithTarget:self selector:selector];
    CCSequence* sequence1 = [CCSequence actions:delay1, fadeIn, delay2, fadeOut, callNextRoll, nil];
    [self.narrative1 runAction:sequence1];
}

-(void)onSkipButtonPressed
{
    [self.parentLayer performSelector:self.parentSelector];
}

-(void)onFlashingCompleted
{
    [self lastRoll];
}

@end
