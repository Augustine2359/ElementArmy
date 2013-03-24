//
//  NBStageInfoPanel.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 22/3/13.
//
//

#import "NBStageInfoPanel.h"

@implementation NBStageInfoPanel

-(id)initOnLayer:(CCLayer*)layer
{
    if (self = [super init])
    {
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        reappearFlag = false;
        
        DLog(@"test pos x = %f, y = %f", self.position.x, self.position.y);
        
        self.background = [CCSprite spriteWithSpriteFrameName:@"staticbox_gray.png"];
        self.background.scaleX = 256 / self.background.contentSize.width;
        self.background.scaleY = 48 / self.background.contentSize.height;
        [self addChild:self.background];
        self.background.position = CGPointMake((windowSize.width / 2), 30);
        self.position = CGPointMake(0, -100);
        self.isAppeared = false;
        self.currentSelectedStageData = nil;
        
        //Stage Title
        self.levelName = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(120, 24) hAlignment:NSTextAlignmentLeft fontName:@"Zapfino" fontSize:10];
        self.levelName.position = CGPointMake((windowSize.width / 2), 30);
        [self addChild:self.levelName];
        
        [layer addChild:self];
    }
    
    return self;
}

-(void)appearWithStageData:(NBStageData*)stageData
{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    if (self.isAppeared && stageData == self.currentSelectedStageData)
        return;
    else
        self.currentSelectedStageData = stageData;
    
    if (self.isAppeared)
    {
        [self disappear:true];
        return;
    }
    
    NBBasicClassData* classData = nil;
    int enemyIndex = 0;
    
    CCARRAY_FOREACH(stageData.enemyList, classData)
    {
        CCSprite* newEnemyImage = [CCSprite spriteWithSpriteFrameName:classData.idleFrame];
        
        //maintain an optimized 24x48 size sprite size.
        newEnemyImage.scaleX = 24 / newEnemyImage.contentSize.width;
        newEnemyImage.scaleY = 48 / newEnemyImage.contentSize.height;
        
        if (enemyIndex == 0)
        {
            self.enemyImage1 = newEnemyImage;
        }
        else if (enemyIndex == 1)
        {
            self.enemyImage2 = newEnemyImage;
        }
        else if (enemyIndex == 2)
        {
            self.enemyImage3 = newEnemyImage;
        }
        
        [self addChild:newEnemyImage];
        newEnemyImage.position = CGPointMake(((windowSize.width / 2) + 48) + (enemyIndex * 30), 30);

        enemyIndex++;
    }
    
    [self.levelName setString:stageData.stageName];
    
    CCMoveTo* move = [CCMoveTo actionWithDuration:0.75 position:CGPointMake(0, 0)];
    CCEaseOut* ease = [CCEaseOut actionWithAction:move rate:0.5];
    [self runAction:ease];
        
    self.isAppeared = true;
}

-(void)disappear:(bool)reappear
{
    reappearFlag = reappear;
    CCMoveTo* move = [CCMoveTo actionWithDuration:0.75 position:CGPointMake(0, -100)];
    CCEaseIn* ease = [CCEaseIn actionWithAction:move rate:0.5];
    CCCallFunc* moveCompleted = [CCCallFunc actionWithTarget:self selector:@selector(onDisappeared)];
    CCSequence* sequence = [CCSequence actions:ease, moveCompleted, nil];
    [self runAction:sequence];
}

-(void)onDisappeared
{
    self.isAppeared = false;
    
    if (self.enemyImage1)
    {
        [self.enemyImage1 removeFromParentAndCleanup:YES];
        self.enemyImage1 = nil;
    }
    
    if (self.enemyImage2)
    {
        [self.enemyImage2 removeFromParentAndCleanup:YES];
        self.enemyImage2 = nil;
    }
    
    if (self.enemyImage3)
    {
        [self.enemyImage3 removeFromParentAndCleanup:YES];
        self.enemyImage3 = nil;
    }
    
    [self.levelName setString:@""];
    
    if (reappearFlag)
    {
        reappearFlag = false;
        [self appearWithStageData:self.currentSelectedStageData];
    }
}

@end
