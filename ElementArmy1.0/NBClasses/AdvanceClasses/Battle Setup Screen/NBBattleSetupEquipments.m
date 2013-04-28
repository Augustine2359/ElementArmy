//
//  NBBattleSetupEquipments.m
//  ElementArmy1.0
//
//  Created by Eric on 15/1/13.
//
//

#import "NBBattleSetupEquipments.h"
#import "NBBattleSetupScreen.h"

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
    
    self.allEquipments = [CCArray new];
    NBEquipmentData* equipmentData = nil;
    CCARRAY_FOREACH([NBDataManager getListOfEquipments], equipmentData)
    {
        NBEquipment* equipment = [NBEquipment createEquipment:equipmentData onLayer:self onSelector:@selector(selectTargetEquipment)];
        [self.allEquipments addObject:equipment];
    }
}

-(void)initialiseEquipmentUI{
    for (int x = 0; x < [self.allEquipments count]; x++) {
        NBEquipment* thatEquipment = [self.allEquipments objectAtIndex:x];
        [thatEquipment.equipmentIcon setPosition:ccp(x%4 * 100 + 100, 250 - x/4 * 75)];
        [thatEquipment displayEquipmentIcon];
        
        if (x == 11) {
            //Do something to show the remainder on next page
            break;
        }
    }
    
    self.descriptionString = @"No equipment selected";
    self.descriptionLabel = [CCLabelTTF labelWithString:self.descriptionString fontName:@"PF Ronda Seven" fontSize:20];
    self.descriptionLabel.position = ccp(240, 75);
    [self addChild:self.descriptionLabel];
    
    self.confirmButton = [NBButton createWithStringHavingNormal:@"button_confirm.png" havingSelected:@"button_confirm.png" havingDisabled:@"button_confirm.png" onLayer:self respondTo:nil selector:@selector(confirmAndCloseMenu) withSize:CGSizeZero];
    [self.confirmButton setPosition:CGPointMake(450, 50)];
    [self.confirmButton show];
    
    self.cancelButton = [NBButton createWithStringHavingNormal:@"button_cancel.png" havingSelected:@"button_cancel.png" havingDisabled:@"button_cancel.png" onLayer:self respondTo:nil selector:@selector(cancelAndCloseMenu) withSize:CGSizeZero];
    [self.cancelButton setPosition:CGPointMake(30, 50)];
    [self.cancelButton show];
    
    [self setPosition:ccp(0, -320)];
}

-(void)toggleEquipmentSelection:(NBEquipment*)selectedEquipmentButton confirmSel:(SEL)confirmSel{
    
    //Is already closed
    if (!self.equipmentSelectionOpen) {
        id open = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, 0)];
        [self runAction:open];
        self.equipmentSelectionOpen = YES;
        
        self.changingTargetEquipment = selectedEquipmentButton;
        self.updateStatSelector = confirmSel;
    }
    
    //Is already opened
    else{
        id close = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(0, -320)];
        [self runAction:close];
        self.equipmentSelectionOpen = NO;
        
        if (selectedEquipmentButton != nil) {
            SEL thatSelector = self.changingTargetEquipment.currentSelector;
            NBEquipment* newEquipment = [NBEquipment createEquipment:selectedEquipmentButton.equipmentData onLayer:self.mainLayer onSelector:thatSelector];
            [newEquipment.equipmentIcon setPosition:[self.changingTargetEquipment.equipmentIcon getPosition]];
            [newEquipment displayEquipmentIcon];
            
            [self.changingTargetEquipment hideEquipmentIcon];
            [self.changingTargetEquipment release];
            [self.mainLayer performSelector:self.updateStatSelector];
        }
    }
}

-(void)selectTargetEquipment{
    NBEquipment *equipment = [NBEquipment getCurrentlySelectedEquipment];
    self.descriptionString = equipment.equipmentData.description;
    self.descriptionLabel.string = self.descriptionString;
}

-(void)confirmAndCloseMenu{
    NBEquipment *equipment = [NBEquipment getCurrentlySelectedEquipment];
    [self toggleEquipmentSelection:equipment confirmSel:nil];
}

-(void)cancelAndCloseMenu{
    [self toggleEquipmentSelection:nil confirmSel:nil];
}

@end
