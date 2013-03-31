//
//  NBHQSetupScreen.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/2/13.
//
//

#import "NBBasicScreenLayer.h"
#import "NBHQEquipments.h"
#import "NBHQItems.h"
#import "NBHQUnits.h"

@interface NBHQSetupScreen : NBBasicScreenLayer

@property (nonatomic, retain) NBButton* testButton;
@property (nonatomic, retain) NBStaticObject* titleBanner;

@property (nonatomic, retain) NBStaticObject* backgroundImage;
@property (nonatomic, retain) NBStaticObject* headerImage;

@property (nonatomic, retain) NBHQEquipments* equipmentsLayer;
@property (nonatomic, retain) NBHQItems* itemsLayer;
@property (nonatomic, retain) NBHQUnits* unitsLayer;

@property (nonatomic, retain) NBButton *equipmentsTab;
@property (nonatomic, retain) NBButton *itemsTab;
@property (nonatomic, retain) NBButton *unitsTab;
@property (nonatomic, retain) NBButton* confirmButton;
@property (nonatomic, retain) NBButton* cancelButton;

-(void)openEquipmentsMenu;
-(void)openItemsMenu;
-(void)openUnitsMenu;
-(void)confirmAndCloseMenu;

-(void)gotoMainMenuScreen;
-(void)gotoMapSelectionScreen;
-(void)gotoStoryScreen;
-(void)gotoBattleSetupScreen;
-(void)gotoBattleScreen;
-(void)gotoTestScreen;

//UI Control
-(void)onTestButtonPressed;

@end
