//
//  NBGameResourcePanel.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 21/4/13.
//
//

#import "NBGameResourcePanel.h"

static NBGameResourcePanel* gamePanel = nil;

@implementation NBGameResourcePanel

+(id)getGamePanel
{
    if (!gamePanel)
    {
        return [[NBGameResourcePanel alloc] init];
    }
    else
    {
        return gamePanel;
    }
}

-(id)init
{
    if (self = [super init])
    {
        gamePanel = self;
        
        CGSize winsize = [[CCDirector sharedDirector] winSize];
        
        self.contentSize = CGSizeMake(300, 32);
        self.anchorPoint = ccp(0, 0);
        self.position = ccp(winsize.width - self.contentSize.width - 5, winsize.height - self.contentSize.height - 5);
        
        self.background = [CCSprite spriteWithSpriteFrameName:@"staticbox_blue.png"];
        self.background.scaleX = self.contentSize.width / self.background.contentSize.width;
        self.background.scaleY = self.contentSize.height / self.background.contentSize.height;
        self.background.anchorPoint = ccp(0, 0);
        self.background.position = ccp(0, 0);
        
        [self addChild:self.background];
        
        self.energyInfoPanel = [CCSprite spriteWithSpriteFrameName:@"troopSelectionScreen_box_large.png"];
        self.energyInfoPanel.scaleX = (self.contentSize.width / self.energyInfoPanel.contentSize.width) / 3.25f;
        self.energyInfoPanel.scaleY = (self.contentSize.height - 6) / self.energyInfoPanel.contentSize.height;
        self.energyInfoPanel.anchorPoint = ccp(0, 0);
        self.energyInfoPanel.position = ccp(6, 3);
        [self addChild:self.energyInfoPanel];
        
        self.goldInfoPanel = [CCSprite spriteWithSpriteFrameName:@"troopSelectionScreen_box_large.png"];
        self.goldInfoPanel.scaleX = (self.contentSize.width / self.goldInfoPanel.contentSize.width) / 3.25f;
        self.goldInfoPanel.scaleY = (self.contentSize.height - 6) / self.goldInfoPanel.contentSize.height;
        self.goldInfoPanel.anchorPoint = ccp(0, 0);
        self.goldInfoPanel.position = ccp(self.goldInfoPanel.boundingBox.size.width + 12, 3);
        [self addChild:self.goldInfoPanel];
        
        self.elementalGemInfoPanel = [CCSprite spriteWithSpriteFrameName:@"troopSelectionScreen_box_large.png"];
        self.elementalGemInfoPanel.scaleX = (self.contentSize.width / self.elementalGemInfoPanel.contentSize.width) / 3.25f;
        self.elementalGemInfoPanel.scaleY = (self.contentSize.height - 6) / self.elementalGemInfoPanel.contentSize.height;
        self.elementalGemInfoPanel.anchorPoint = ccp(0, 0);
        self.elementalGemInfoPanel.position = ccp((self.elementalGemInfoPanel.boundingBox.size.width * 2) + 18, 3);
        [self addChild:self.elementalGemInfoPanel];
        
        self.energyIcon = [CCSprite spriteWithSpriteFrameName:@"troopSelectionScreen_manaPotion.png"];
        self.energyIcon.scaleX = 16 / self.energyIcon.contentSize.width;
        self.energyIcon.scaleY = 16 / self.energyIcon.contentSize.height;
        self.energyIcon.anchorPoint = ccp(0, 0);
        self.energyIcon.position = ccp(16, 8);
        [self addChild:self.energyIcon];
        
        self.goldIcon = [CCSprite spriteWithSpriteFrameName:@"troopSelectionScreen_healthPotion.png"];
        self.goldIcon.scaleX = 16 / self.goldIcon.contentSize.width;
        self.goldIcon.scaleY = 16 / self.goldIcon.contentSize.height;
        self.goldIcon.anchorPoint = ccp(0, 0);
        self.goldIcon.position = ccp(114, 8);
        [self addChild:self.goldIcon];
        
        self.elementalGemIcon = [CCSprite spriteWithSpriteFrameName:@"troopSelectionScreen_armor.png"];
        self.elementalGemIcon.scaleX = 16 / self.elementalGemIcon.contentSize.width;
        self.elementalGemIcon.scaleY = 16 / self.elementalGemIcon.contentSize.height;
        self.elementalGemIcon.anchorPoint = ccp(0, 0);
        self.elementalGemIcon.position = ccp(212, 8);
        [self addChild:self.elementalGemIcon];
        
        self.energyInfo = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeZero hAlignment:kCCTextAlignmentCenter fontName:@"Palatino" fontSize:16];
        self.energyInfo.anchorPoint = ccp(0.5, 0.5);
        self.energyInfo.position = ccp(62, 15);
        [self addChild:self.energyInfo];
        
        self.goldInfo = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeZero hAlignment:kCCTextAlignmentCenter fontName:@"Palatino" fontSize:16];
        self.goldInfo.anchorPoint = ccp(0.5, 0.5);
        self.goldInfo.position = ccp(162, 15);
        [self addChild:self.goldInfo];
        
        self.elementalGemInfo = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeZero hAlignment:kCCTextAlignmentCenter fontName:@"Palatino" fontSize:16];
        self.elementalGemInfo.anchorPoint = ccp(0.5, 0.5);
        self.elementalGemInfo.position = ccp(262, 15);
        [self addChild:self.elementalGemInfo];
        
        self.dataManager = [NBDataManager dataManager];
    }
    
    return self;
}

-(void)updateResourceInfo
{
    int energy = self.dataManager.availableEnergy;
    int gold = self.dataManager.availableGold;
    int elementalGem = self.dataManager.availableElementalGem;
    
    if (energy != self.currentElementalgem)
    {
        [self.energyInfo setString:[NSString stringWithFormat:@"%i", energy]];
    }
    
    if (gold != self.currentGold)
    {
        [self.goldInfo setString:[NSString stringWithFormat:@"%i", gold]];
    }
    
    if (elementalGem != self.currentElementalgem)
    {
        [self.elementalGemInfo setString:[NSString stringWithFormat:@"%i", elementalGem]];
    }
}

@end
