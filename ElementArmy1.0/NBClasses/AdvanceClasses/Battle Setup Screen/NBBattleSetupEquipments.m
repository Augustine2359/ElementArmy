//
//  NBBattleSetupEquipments.m
//  ElementArmy1.0
//
//  Created by Eric on 15/1/13.
//
//

#import "NBBattleSetupEquipments.h"

@implementation NBBattleSetupEquipments


-(id)initWithLayer:(id)layer
{
    if ((self = [super init]))
    {
        self.mainLayer = layer;
        [self initialiseEquipmentArray];
        [self initialiseEquipmentUI];
    }
    return self;
}

- (void)onEnter {
    [super onEnter];
}

- (id)init {
    self = [super init];
    
    if (self) {
    }
    return self;
}

-(void)initialiseEquipmentArray{
    [self setCurrentBackgroundWithFileName:@"frame_item.png" stretchToScreen:YES];
    
    NBEquipment* equipment1 = [NBEquipment createEquipment:@"Potion" onLayer:self onSelector:@selector(selectTargetEquipment)];
    [equipment1 setEquipmentIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self];
    NBEquipment* equipment2 = [NBEquipment createEquipment:@"FuryPill" onLayer:self onSelector:@selector(selectTargetEquipment)];
    [equipment2 setEquipmentIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    NBEquipment* equipment3 = [NBEquipment createEquipment:@"WingedBoots" onLayer:self onSelector:@selector(selectTargetEquipment)];
    [equipment3 setEquipmentIconWithNormalImage:@"Winged_boots.png" selectedImage:@"Winged_boots.png" disabledImage:@"Winged_boots.png" onLayer:self];
    NBEquipment* equipment4 = [NBEquipment createEquipment:@"FuryPill" onLayer:self onSelector:@selector(selectTargetEquipment)];
    [equipment4 setEquipmentIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    NBEquipment* equipment5 = [NBEquipment createEquipment:@"Potion" onLayer:self onSelector:@selector(selectTargetEquipment)];
    [equipment5 setEquipmentIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self];
    self.allEquipments = [NSMutableArray new];
    self.allEquipments = [NSMutableArray arrayWithObjects:equipment1, equipment2, equipment3, equipment4, equipment5, nil];
}

-(void)initialiseEquipmentUI{
    for (int x = 0; x < [self.allEquipments count]; x++) {
        NBEquipment* thatEquipment = [self.allEquipments objectAtIndex:x];
        [thatEquipment.equipmentIcon setPosition:ccp(x%4 * 100 + 100, 250 - x/4 * 75)];
        [thatEquipment displayEquipmentIcon];
    }
    
    CCSpriteBatchNode* spritesBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"CharacterSprites.png"];
    
    self.descriptionLabel = [[NBMessageBox alloc] initWithFrameName:@"frame_item.png" andSpriteBatchNode:spritesBatchNode onLayer:self respondTo:self selector:@selector(null) atMessageBoxStartingPosition:(enum MessageBoxStartingPosition)MessageBoxStartingPositionCentre];
//    [self.descriptionLabel message] = @"asd";
    
    [self setPosition:ccp(0, -320)];
}

-(void)toggleEquipmentSelection:(NBEquipment*)selectedEquipmentButton{
    //Is already closed
    if (!self.equipmentSelectionOpen) {
        id open = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, 0)];
        [self runAction:open];
        self.equipmentSelectionOpen = YES;
        
        self.changingTargetEquipment = selectedEquipmentButton;
    }
    
    //Is already opened
    else{
        id close = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, -320)];
        [self runAction:close];
        self.equipmentSelectionOpen = NO;
        
        NBEquipment* newEquipment = [NBEquipment createEquipment:selectedEquipmentButton.equipmentData.equipmentID onLayer:self onSelector:@selector(selectTargetEquipment)];
        [newEquipment setEquipmentIconWithNormalImage:selectedEquipmentButton.image selectedImage:selectedEquipmentButton.image disabledImage:selectedEquipmentButton.image onLayer:self.mainLayer];
        [newEquipment.equipmentIcon setPosition:ccp([self.changingTargetEquipment.equipmentIcon getPosition].x, [self.changingTargetEquipment.equipmentIcon getPosition].y)];
        [newEquipment displayEquipmentIcon];
        
        [self.changingTargetEquipment hideEquipmentIcon];
    }
}

-(void)selectTargetEquipment{
    NBEquipment *equipment = [NBEquipment getCurrentlySelectedEquipment];
    [self toggleEquipmentSelection:equipment];
}

@end
