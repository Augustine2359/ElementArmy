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
	[scene addChild:layer z:0];
    
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
    [self createUnitSelectors];
    
    //Display buttons Navigation
    //OK
    self.battleSetupOk = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(gotoBattleScreen) withSize:CGSizeZero];
    [self.battleSetupOk setPosition:CGPointMake(450, 50)];
    [self.battleSetupOk show];
    
    //Cancel
    self.battleSetupCancel = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(gotoMapSelectionScreen) withSize:CGSizeZero];
    [self.battleSetupCancel setPosition:CGPointMake(30, 50)];
    [self.battleSetupCancel show];
    
    
    //Temp hardcode
    //Display buttons Items
    self.selectedItemsArrayIndex = [NSArray new];
    self.selectedItemsArrayIndex = [NSArray arrayWithObjects:@"Potion.png", @"Fury_pill.png", @"Winged_boots.png", nil];
    self.tempNumberOfUnlockedItemsSlots = 2;
    for (int x = 0; x < 3; x++) {
        if (x < self.tempNumberOfUnlockedItemsSlots) {
            NBButton* itemButton;
            itemButton = [NBButton createWithStringHavingNormal:[self.selectedItemsArrayIndex objectAtIndex:x] havingSelected:[self.selectedItemsArrayIndex objectAtIndex:x] havingDisabled:[self.selectedItemsArrayIndex objectAtIndex:x] onLayer:self respondTo:nil selector:@selector(openItemSelection:) withSize:CGSizeZero];
            itemButton.tag = x;
            [itemButton setPosition:ccp(x*80 + 160, 50)];
            [itemButton show];
        }
        else{
            NBButton* lockedButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(gotoAppStore) withSize:CGSizeZero];
            [lockedButton setPosition:ccp(x*80 + 160, 50)];
            [lockedButton show];
        }
    }
    
    //Item selection
    self.setupItemsFrame = [BattleSetupItems new];
    [self addChild:self.setupItemsFrame z:1];
}

-(void)openItemSelection:(NBButton*)selectedItemIndex{
    if (!self.setupItemsFrame.itemSelectionOpen) {
        self.currentSelectedItemIndex = selectedItemIndex.tag;
        [self.setupItemsFrame toggleItemSelection];
    }
}
-(void)updateSelectedItems{
    
}

- (void)createUnitSelectors {
  ccColor4B startColor;
  startColor.r = 255;
  startColor.g = 255;
  startColor.b = 255;
  startColor.a = 255;

  self.unitSelectorsContainerLayer = [[NBBattleSetupUnitSelectorsContainerLayer alloc] initWithColor:startColor width:330 height:200];
  self.unitSelectorsContainerLayer.position = CGPointMake(100, 100);
  [self addChild:self.unitSelectorsContainerLayer];
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

-(void)gotoAppStore{
    DLog(@"Buy new slot with $$!");
}

@end
