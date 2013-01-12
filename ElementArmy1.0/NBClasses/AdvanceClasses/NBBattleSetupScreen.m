//
//  NBBattleSetupScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import "NBBattleSetupScreen.h"
#import "NBBattleSetupUnitSelectorLayer.h"
#import "NBBattleSetupUnitSelectorsContainerLayer.h"

@interface NBBattleSetupScreen()

@property (nonatomic, strong) NBBattleSetupUnitSelectorsContainerLayer *unitSelectorsContainerLayer;

@end

@implementation NBBattleSetupScreen

// Helper class method that creates a Scene with the NBBattleLayer as the only child.
+(CCScene*)scene
{
    return [NBBattleSetupScreen sceneAndSetAsDefault:NO];
}

+(CCScene*)sceneAndSetAsDefault:(BOOL)makeDefault
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	NBBattleSetupScreen *layer = [NBBattleSetupScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    if (makeDefault)
        [NBBasicScreenLayer setDefaultScreen:scene];
    
    [NBBasicScreenLayer resetMenuIndex];
	
	// return the scene
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    UI_USER_INTERFACE_IDIOM();
    
    //Prepare Sprite Batch Node
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CharacterSprites.plist"];
    self.characterSpritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
    [self addChild:self.characterSpritesBatchNode z:0 tag:0];
    
    
    //Display Title
    self.battleSetupTitle = [NBStaticObject createStaticObject:@"setup_title.png" atPosition:CGPointMake(240, 200)];
//    [self.battleSetupTitle show];
    
    
    //Display buttons Navigation
    //OK
    CCSprite* buttonOkNormal = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    CCSprite* buttonOkSelected = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    CCSprite* buttonOkDisabled = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    
    self.battleSetupOk = [NBButton createWithCustomImageHavingNormal:buttonOkNormal havingSelected:buttonOkSelected havingDisabled:buttonOkDisabled onLayer:self selector:@selector(gotoBattleScreen) withSize:CGSizeZero];
    [self.battleSetupOk setPosition:CGPointMake(450, 50)];
    [self.battleSetupOk show];
    
    //Cancel
    CCSprite* buttonCancelNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* buttonCancelSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* buttonCancelDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    
    self.battleSetupCancel = [NBButton createWithCustomImageHavingNormal:buttonCancelNormal havingSelected:buttonCancelSelected havingDisabled:buttonCancelDisabled onLayer:self selector:@selector(gotoMapSelectionScreen) withSize:CGSizeZero];
    [self.battleSetupCancel setPosition:CGPointMake(450, 100)];
    [self.battleSetupCancel show];
    
    
    //Display buttons Items
    //Item 1
    CCSprite* buttonItem1Normal = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    CCSprite* buttonItem1Selected = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    CCSprite* buttonItem1Disabled = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    
    self.battleSetupItem1 = [NBButton createWithCustomImageHavingNormal:buttonItem1Normal havingSelected:buttonItem1Selected havingDisabled:buttonItem1Disabled onLayer:self selector:@selector(gotoMainMenuScreen) withSize:CGSizeZero];
    [self.battleSetupItem1 setPosition:CGPointMake(160, 50)];
    [self.battleSetupItem1 show];
    
    //Item 2
    CCSprite* buttonItem2Normal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* buttonItem2Selected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* buttonItem2Disabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    
    self.battleSetupItem2 = [NBButton createWithCustomImageHavingNormal:buttonItem2Normal havingSelected:buttonItem2Selected havingDisabled:buttonItem2Disabled onLayer:self selector:@selector(gotoMainMenuScreen) withSize:CGSizeZero];
    [self.battleSetupItem2 setPosition:CGPointMake(240, 50)];
    [self.battleSetupItem2 show];
    
    //Item 2
    CCSprite* buttonItem3Normal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* buttonItem3Selected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* buttonItem3Disabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    
    self.battleSetupItem3 = [NBButton createWithCustomImageHavingNormal:buttonItem3Normal havingSelected:buttonItem3Selected havingDisabled:buttonItem3Disabled onLayer:self selector:@selector(gotoMainMenuScreen) withSize:CGSizeZero];
    [self.battleSetupItem3 setPosition:CGPointMake(320, 50)];
    [self.battleSetupItem3 show];
    
    //Item Sample
    self.battleSetupItemSample = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self selector:@selector(gotoMainMenuScreen) withSize:CGSizeZero];
    [self.battleSetupItemSample setPosition:CGPointMake(self.battleSetupItemSample.buttonObject.contentSize.width / 2, (self.layerSize.height - self.battleSetupItemSample.buttonObject.contentSize.height / 2))];
    [self.battleSetupItemSample show];
}

-(void)gotoIntroScreen
{
    self.nextScene = @"NBIntroScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoMainMenuScreen
{
    self.nextScene = @"NBMainMenuScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoStoryScreen
{
    self.nextScene = @"NBStoryScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoMapSelectionScreen
{
    self.nextScene = @"NBMapSelectionScreen";
    [self changeToScene:self.nextScene];
}

-(void)gotoBattleScreen
{
    self.nextScene = @"NBBattleLayer";
    [self changeToScene:self.nextScene];
}

@end
