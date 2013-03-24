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
    
    NBEquipment* equipment1 = [NBEquipment createEquipment:@"Potion" onLayer:self onSelector:@selector(selectTargetEquipment) equipmentIndex:0];
    [equipment1 setEquipmentIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self];
    NBEquipment* equipment2 = [NBEquipment createEquipment:@"FuryPill" onLayer:self onSelector:@selector(selectTargetEquipment) equipmentIndex:1];
    [equipment2 setEquipmentIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    NBEquipment* equipment3 = [NBEquipment createEquipment:@"WingedBoots" onLayer:self onSelector:@selector(selectTargetEquipment) equipmentIndex:0];
    [equipment3 setEquipmentIconWithNormalImage:@"Winged_boots.png" selectedImage:@"Winged_boots.png" disabledImage:@"Winged_boots.png" onLayer:self];
    NBEquipment* equipment4 = [NBEquipment createEquipment:@"FuryPill" onLayer:self onSelector:@selector(selectTargetEquipment) equipmentIndex:1];
    [equipment4 setEquipmentIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
    NBEquipment* equipment5 = [NBEquipment createEquipment:@"Potion" onLayer:self onSelector:@selector(selectTargetEquipment) equipmentIndex:1];
    [equipment5 setEquipmentIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self];

    
//    NBEquipment* equipment1 = [NBEquipment createEquipment:@"Potion" onLayer:self onSelector:@selector(selectTargetEquipment)];
//    [equipment1 setEquipmentIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self];
//    NBEquipment* equipment2 = [NBEquipment createEquipment:@"FuryPill" onLayer:self onSelector:@selector(selectTargetEquipment)];
//    [equipment2 setEquipmentIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
//    NBEquipment* equipment3 = [NBEquipment createEquipment:@"WingedBoots" onLayer:self onSelector:@selector(selectTargetEquipment)];
//    [equipment3 setEquipmentIconWithNormalImage:@"Winged_boots.png" selectedImage:@"Winged_boots.png" disabledImage:@"Winged_boots.png" onLayer:self];
//    NBEquipment* equipment4 = [NBEquipment createEquipment:@"FuryPill" onLayer:self onSelector:@selector(selectTargetEquipment)];
//    [equipment4 setEquipmentIconWithNormalImage:@"Fury_pill.png" selectedImage:@"Fury_pill.png" disabledImage:@"Fury_pill.png" onLayer:self];
//    NBEquipment* equipment5 = [NBEquipment createEquipment:@"Potion" onLayer:self onSelector:@selector(selectTargetEquipment)];
//    [equipment5 setEquipmentIconWithNormalImage:@"Potion.png" selectedImage:@"Potion.png" disabledImage:@"Potion.png" onLayer:self];
    self.allEquipments = [NSMutableArray new];
    self.allEquipments = [NSMutableArray arrayWithObjects:equipment1, equipment2, equipment3, equipment4, equipment5, nil];
}

-(void)initialiseEquipmentUI{
    for (int x = 0; x < [self.allEquipments count]; x++) {
        NBEquipment* thatEquipment = [self.allEquipments objectAtIndex:x];
        [thatEquipment.equipmentIcon setPosition:ccp(x%4 * 100 + 100, 250 - x/4 * 75)];
        [thatEquipment displayEquipmentIcon];
    }
    
    self.descriptionString = @"No equipment selected";
    self.descriptionLabel = [CCLabelTTF labelWithString:self.descriptionString fontName:@"Marker Felt" fontSize:20];
    self.descriptionLabel.position = ccp(240, 50);
    [self addChild:self.descriptionLabel];
    
    self.confirmButton = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(confirmAndCloseMenu) withSize:CGSizeZero];
    [self.confirmButton setPosition:CGPointMake(450, 50)];
    [self.confirmButton show];
    
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
        
        int asd = [selectedEquipmentButton.equipmentData.equipmentID intValue];
        NBEquipment* newEquipment = [NBEquipment createEquipment:selectedEquipmentButton.equipmentData.equipmentID onLayer:self onSelector:@selector(selectTargetEquipment) equipmentIndex:asd-1];
        [newEquipment setEquipmentIconWithNormalImage:selectedEquipmentButton.image selectedImage:selectedEquipmentButton.image disabledImage:selectedEquipmentButton.image onLayer:self.mainLayer];
        [newEquipment.equipmentIcon setPosition:ccp([self.changingTargetEquipment.equipmentIcon getPosition].x, [self.changingTargetEquipment.equipmentIcon getPosition].y)];
        [newEquipment displayEquipmentIcon];
        
        [self.changingTargetEquipment hideEquipmentIcon];
    }
}

-(void)selectTargetEquipment{
    NBEquipment *equipment = [NBEquipment getCurrentlySelectedEquipment];
    self.descriptionString = equipment.equipmentData.description;
    DLog(@"%@", self.descriptionString);
    self.descriptionLabel.string = self.descriptionString;
}

-(void)confirmAndCloseMenu{
    NBEquipment *equipment = [NBEquipment getCurrentlySelectedEquipment];
    [self toggleEquipmentSelection:equipment];
}

@end
