//
//  NBBattleSetupScreen.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 25/11/12.
//
//

#import "NBBattleSetupScreen.h"

float slideDuration = 0.5f;
bool itemSelectionOpen = NO;


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
    
    
    //Must be called everytime entering a layer
    [NBStaticObject initializeWithSpriteBatchNode:self.characterSpritesBatchNode andLayer:self andWindowsSize:self.layerSize];
    
    
    //Display Title
    self.battleSetupTitle = [NBStaticObject createStaticObject:@"setup_title.png" atPosition:CGPointMake(240, 280)];
    
    
    //Display Characters
    self.battleSetupCharacter1 = [NBStaticObject createStaticObject:@"button_confirm.png" atPosition:CGPointMake(100, 180)];
    self.battleSetupCharacter2 = [NBStaticObject createStaticObject:@"button_confirm.png" atPosition:CGPointMake(240, 180)];
    self.battleSetupCharacter3 = [NBStaticObject createStaticObject:@"button_confirm.png" atPosition:CGPointMake(380, 180)];
    
    //Display Character buttons
    //Character 1
    CCSprite* character1UpNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character1UpSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character1UpDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter1Up = [NBButton createWithCustomImageHavingNormal:character1UpNormal havingSelected:character1UpSelected havingDisabled:character1UpDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter1Up setPosition:CGPointMake(100, 230)];
    [self.battleSetupCharacter1Up show];
    
    CCSprite* character1RightNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character1RightSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character1RightDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter1Right = [NBButton createWithCustomImageHavingNormal:character1RightNormal havingSelected:character1RightSelected havingDisabled:character1RightDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter1Right setPosition:CGPointMake(150, 180)];
    [self.battleSetupCharacter1Right show];
    
    CCSprite* character1DownNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character1DownSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character1DownDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter1Down = [NBButton createWithCustomImageHavingNormal:character1DownNormal havingSelected:character1DownSelected havingDisabled:character1DownDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter1Down setPosition:CGPointMake(100, 130)];
    [self.battleSetupCharacter1Down show];
    
    CCSprite* character1LeftNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character1LeftSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character1LeftDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter1Left = [NBButton createWithCustomImageHavingNormal:character1LeftNormal havingSelected:character1LeftSelected havingDisabled:character1LeftDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter1Left setPosition:CGPointMake(50, 180)];
    [self.battleSetupCharacter1Left show];
    
    
    //Character 2
    CCSprite* character2UpNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character2UpSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character2UpDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter2Up = [NBButton createWithCustomImageHavingNormal:character2UpNormal havingSelected:character2UpSelected havingDisabled:character2UpDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter2Up setPosition:CGPointMake(240, 230)];
    [self.battleSetupCharacter2Up show];
    
    CCSprite* character2RightNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character2RightSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character2RightDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter2Right = [NBButton createWithCustomImageHavingNormal:character2RightNormal havingSelected:character2RightSelected havingDisabled:character2RightDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter2Right setPosition:CGPointMake(290, 180)];
    [self.battleSetupCharacter2Right show];
    
    CCSprite* character2DownNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character2DownSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character2DownDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter2Down = [NBButton createWithCustomImageHavingNormal:character2DownNormal havingSelected:character2DownSelected havingDisabled:character2DownDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter2Down setPosition:CGPointMake(240, 130)];
    [self.battleSetupCharacter2Down show];
    
    CCSprite* character2LeftNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character2LeftSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character2LeftDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter2Left = [NBButton createWithCustomImageHavingNormal:character2LeftNormal havingSelected:character2LeftSelected havingDisabled:character2LeftDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter2Left setPosition:CGPointMake(190, 180)];
    [self.battleSetupCharacter2Left show];
    
    
    //Character 3
    CCSprite* character3UpNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character3UpSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character3UpDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter3Up = [NBButton createWithCustomImageHavingNormal:character3UpNormal havingSelected:character3UpSelected havingDisabled:character3UpDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter3Up setPosition:CGPointMake(380, 230)];
    [self.battleSetupCharacter3Up show];
    
    CCSprite* character3RightNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character3RightSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character3RightDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter3Right = [NBButton createWithCustomImageHavingNormal:character3RightNormal havingSelected:character3RightSelected havingDisabled:character3RightDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter3Right setPosition:CGPointMake(430, 180)];
    [self.battleSetupCharacter3Right show];
    
    CCSprite* character3DownNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character3DownSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character3DownDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter3Down = [NBButton createWithCustomImageHavingNormal:character3DownNormal havingSelected:character3DownSelected havingDisabled:character3DownDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter3Down setPosition:CGPointMake(380, 130)];
    [self.battleSetupCharacter3Down show];
    
    CCSprite* character3LeftNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character3LeftSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* character3LeftDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCharacter3Left = [NBButton createWithCustomImageHavingNormal:character3LeftNormal havingSelected:character3LeftSelected havingDisabled:character3LeftDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupCharacter3Left setPosition:CGPointMake(330, 180)];
    [self.battleSetupCharacter3Left show];
    
    
    //Display buttons Navigation
    //OK
    CCSprite* buttonOkNormal = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    CCSprite* buttonOkSelected = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    CCSprite* buttonOkDisabled = [CCSprite spriteWithSpriteFrameName:@"button_confirm.png"];
    self.battleSetupOk = [NBButton createWithCustomImageHavingNormal:buttonOkNormal havingSelected:buttonOkSelected havingDisabled:buttonOkDisabled onLayer:self selector:@selector(gotoBattleScreen)];
    [self.battleSetupOk setPosition:CGPointMake(450, 50)];
    [self.battleSetupOk show];
    
    //Cancel
    CCSprite* buttonCancelNormal = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* buttonCancelSelected = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    CCSprite* buttonCancelDisabled = [CCSprite spriteWithSpriteFrameName:@"button_cancel.png"];
    self.battleSetupCancel = [NBButton createWithCustomImageHavingNormal:buttonCancelNormal havingSelected:buttonCancelSelected havingDisabled:buttonCancelDisabled onLayer:self selector:@selector(gotoMapSelectionScreen)];
    [self.battleSetupCancel setPosition:CGPointMake(50, 50)];
    [self.battleSetupCancel show];
    
    
    //Display buttons Items
    //Item 1
    CCSprite* buttonItem1Normal = [CCSprite spriteWithSpriteFrameName:@"Potion.png"];
    CCSprite* buttonItem1Selected = [CCSprite spriteWithSpriteFrameName:@"Potion.png"];
    CCSprite* buttonItem1Disabled = [CCSprite spriteWithSpriteFrameName:@"Potion.png"];
    self.battleSetupItem1 = [NBButton createWithCustomImageHavingNormal:buttonItem1Normal havingSelected:buttonItem1Selected havingDisabled:buttonItem1Disabled onLayer:self selector:@selector(toggleItemSelection)];
    [self.battleSetupItem1 setPosition:CGPointMake(160, 50)];
    [self.battleSetupItem1 show];
    
    //Item 2
    CCSprite* buttonItem2Normal = [CCSprite spriteWithSpriteFrameName:@"Fury_pill.png"];
    CCSprite* buttonItem2Selected = [CCSprite spriteWithSpriteFrameName:@"Fury_pill.png"];
    CCSprite* buttonItem2Disabled = [CCSprite spriteWithSpriteFrameName:@"Fury_pill.png"];
    self.battleSetupItem2 = [NBButton createWithCustomImageHavingNormal:buttonItem2Normal havingSelected:buttonItem2Selected havingDisabled:buttonItem2Disabled onLayer:self selector:@selector(toggleItemSelection)];
    [self.battleSetupItem2 setPosition:CGPointMake(240, 50)];
    [self.battleSetupItem2 show];
    
    //Item 3
    CCSprite* buttonItem3Normal = [CCSprite spriteWithSpriteFrameName:@"Winged_boots.png"];
    CCSprite* buttonItem3Selected = [CCSprite spriteWithSpriteFrameName:@"Winged_boots.png"];
    CCSprite* buttonItem3Disabled = [CCSprite spriteWithSpriteFrameName:@"Winged_boots.png"];
    self.battleSetupItem3 = [NBButton createWithCustomImageHavingNormal:buttonItem3Normal havingSelected:buttonItem3Selected havingDisabled:buttonItem3Disabled onLayer:self selector:@selector(toggleItemSelection)];
    [self.battleSetupItem3 setPosition:CGPointMake(320, 50)];
    [self.battleSetupItem3 show];
    
    [self initialiseItemSelection];
}

-(NBButton*)tempCreateButton:(NSString*)normalImage selected:(NSString*)selectedImage disabled:(NSString*)disabledImage atPosition:(CGPoint)position selector:(SEL)selector{
    CCSprite* normal = [CCSprite spriteWithSpriteFrameName:normalImage];
    CCSprite* selected = [CCSprite spriteWithSpriteFrameName:selectedImage];
    CCSprite* disabled = [CCSprite spriteWithSpriteFrameName:disabledImage];
    NBButton* newButton = [NBButton createWithCustomImageHavingNormal:normal havingSelected:selected havingDisabled:disabled onLayer:self selector:@selector(selector)];
    [newButton setPosition:position];
    [newButton show];
    
    return newButton;
}

-(void)initialiseItemSelection{
    self.itemSelectionFrame = [NBStaticObject createWithSize:CGSizeMake(400, 300) usingFrame:@"frame_item.png" atPosition:CGPointMake(240, -300)];
    self.item01 = [self tempCreateButton:@"Potion.png" selected:@"Potion.png" disabled:@"Potion.png" atPosition:CGPointMake(100, -300) selector:@selector(toggleItemSelection)];
    self.item02 = [self tempCreateButton:@"Potion.png" selected:@"Potion.png" disabled:@"Potion.png" atPosition:CGPointMake(150, -300) selector:@selector(toggleItemSelection)];
    self.item03 = [self tempCreateButton:@"Potion.png" selected:@"Potion.png" disabled:@"Potion.png" atPosition:CGPointMake(200, -300) selector:@selector(toggleItemSelection)];
    self.item04 = [self tempCreateButton:@"Potion.png" selected:@"Potion.png" disabled:@"Potion.png" atPosition:CGPointMake(250, -300) selector:@selector(toggleItemSelection)];
    self.item05 = [self tempCreateButton:@"Potion.png" selected:@"Potion.png" disabled:@"Potion.png" atPosition:CGPointMake(300, -300) selector:@selector(toggleItemSelection)];
    self.item01.parent = self.itemSelectionFrame;
    self.item02.parent = self.itemSelectionFrame;
    self.item03.parent = self.itemSelectionFrame;
    self.item04.parent = self.itemSelectionFrame;
    self.item05.parent = self.itemSelectionFrame;
}

-(void)toggleItemSelection{
    //Closed
    if (!itemSelectionOpen) {
        id open = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(240, 150)];
        [self.itemSelectionFrame runAction:open];
        itemSelectionOpen = YES;
    }
    //Opened
    else{
        id close = [CCMoveTo actionWithDuration:slideDuration position:CGPointMake(240, -300)];
        [self.itemSelectionFrame runAction:close];
        itemSelectionOpen = NO;
    }
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
