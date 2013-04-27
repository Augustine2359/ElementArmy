//
//  NBItem.m
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/1/13.
//
//

#import "NBItem.h"

static NBItem* currentlySelectedItemInBattleSetup = nil;

@implementation NBItem

+(NBItem*)getCurrentlySelectedItem
{
    return currentlySelectedItemInBattleSetup;
}

+(id)createItem:(NBItemData*)newItemData onLayer:(id)layer onSelector:(SEL)selector
{
    NBItem* item = [[NBItem alloc] init];
    item.itemData = newItemData;
    item.currentLayer = layer;
    item.currentSelector = selector;
    
    [item setItemIconWithNormalImage:item.itemData.imageNormal selectedImage:item.itemData.imageSelected disabledImage:item.itemData.imageDisabled onLayer:layer];
    
    return item;
}

-(id)setItemIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer
{
    self.itemIcon = [NBButton createWithStringHavingNormal:normalImage havingSelected:selectedImage havingDisabled:disabledImage onLayer:layer respondTo:self selector:@selector(onItemSelected) withSize:CGSizeZero];
    self.image = normalImage;
    return self;
}

-(void)onItemSelected
{
    if ([[NBBasicScreenLayer getCurrentScreenName] isEqualToString:@"NBBattleSetupScreen"] ||
        [[NBBasicScreenLayer getCurrentScreenName] isEqualToString:@"NBHQSetupScreen"])
    {
        currentlySelectedItemInBattleSetup = self;
        [self.currentLayer performSelector:self.currentSelector];
    }
}

-(void)displayItemIcon
{
    if (self.itemIcon)
        [self.itemIcon show];
}

-(void)hideItemIcon
{
    if (self.itemIcon)
        [self.itemIcon hide];
}

-(void)activate
{
    if (self.itemData.availableAmount > 0)
    {
        self.itemData.availableAmount--;
        self.isActivated = true;
    }
}

-(void)deactivate
{
    self.isActivated = false;
}

-(void)implementEffect:(NBCharacter*)characterObject
{
    DLog(@"item implemented");
    
    if (!characterObject.isAlive) return;
    
    NSArray* impactedStatusList = [self.itemData.impactedStatus componentsSeparatedByString:@";"];
    NSArray* impactedValueList = [self.itemData.impactValue componentsSeparatedByString:@";"];
    
    for (int effectIndex = 0; effectIndex < [impactedStatusList count]; effectIndex++)
    {
        NSString* impactedStatus = (NSString*)[impactedStatusList objectAtIndex:effectIndex];
        
        if ([impactedStatus length] < 1) continue;
        
        CGFloat impactedStatusValue = 0.0f;
        CGFloat allowableMaximumStatusValue = 0.0f;
        
        if ([impactedStatus isEqualToString:@"HP"])
        {
            impactedStatusValue = characterObject.hitPoint;
            allowableMaximumStatusValue = characterObject.initialHitPoint;
        }
        else if ([impactedStatus isEqualToString:@"SP"])
        {
            impactedStatusValue = characterObject.spiritPoint;
            allowableMaximumStatusValue = characterObject.initialSpiritPoint;
        }
        else if ([impactedStatus isEqualToString:@"ATK"])
        {
            impactedStatusValue = characterObject.attackPoint;
            allowableMaximumStatusValue = characterObject.initialAttackPoint;
        }
        else if ([impactedStatus isEqualToString:@"DEF"])
        {
            impactedStatusValue = characterObject.defensePoint;
            allowableMaximumStatusValue = characterObject.initialDefensePoint;
        }
        else if ([impactedStatus isEqualToString:@"INT"])
        {
            impactedStatusValue = characterObject.intelligencePoint;
            allowableMaximumStatusValue = characterObject.initialIntelligencePoint;
        }
        else if ([impactedStatus isEqualToString:@"DEX"])
        {
            impactedStatusValue = characterObject.dexterityPoint;
            allowableMaximumStatusValue = characterObject.initialDexterityPoint;
        }
        else if ([impactedStatus isEqualToString:@"EVA"])
        {
            impactedStatusValue = characterObject.evasionPoint;
            allowableMaximumStatusValue = characterObject.initialEvasionPoint;
        }
        else
        {
            DLog(@"error: unknown attribute while applying passive buff!!!");
            return;
        }
        
        if (self.itemData.impactType == itimAdd)
        {
            impactedStatusValue = impactedStatusValue + (int)[impactedValueList objectAtIndex:effectIndex];
        }
        else if (self.itemData.impactType == itimSubstract)
        {
            impactedStatusValue = impactedStatusValue - (int)[impactedValueList objectAtIndex:effectIndex];
        }
        else if (self.itemData.impactType == itimMultiply)
        {
            impactedStatusValue = impactedStatusValue * (int)[impactedValueList objectAtIndex:effectIndex];
        }
        else if (self.itemData.impactType == itimDivide)
        {
            impactedStatusValue = impactedStatusValue / (int)[impactedValueList objectAtIndex:effectIndex];
        }
        
        //Normalize the status so that it wont go beyond the maximum value, unless the item type allows
        if (impactedStatusValue >= allowableMaximumStatusValue && !self.itemData.allowBeyondMaximumValue)
            impactedStatusValue = allowableMaximumStatusValue;
        
        if ([impactedStatus isEqualToString:@"HP"])
        {
            DLog(@"Item %@ effected for %@; HP changed from %d to %f", self.itemData.itemName, characterObject.basicClassData.className, characterObject.hitPoint, impactedStatusValue);
            characterObject.hitPoint = impactedStatusValue;
        }
        else if ([impactedStatus isEqualToString:@"SP"])
        {
            DLog(@"Item %@ effected for %@; SP changed from %d to %f", self.itemData.itemName, characterObject.basicClassData.className, characterObject.spiritPoint, impactedStatusValue);
            characterObject.spiritPoint = impactedStatusValue;
        }
        else if ([impactedStatus isEqualToString:@"ATK"])
        {
            DLog(@"Item %@ effected for %@; ATK changed from %d to %f", self.itemData.itemName, characterObject.basicClassData.className, characterObject.attackPoint, impactedStatusValue);
            characterObject.attackPoint = impactedStatusValue;
        }
        else if ([impactedStatus isEqualToString:@"DEF"])
        {
            DLog(@"Item %@ effected for %@; DEF changed from %d to %f", self.itemData.itemName, characterObject.basicClassData.className, characterObject.defensePoint, impactedStatusValue);
            characterObject.defensePoint = impactedStatusValue;
        }
        else if ([impactedStatus isEqualToString:@"INT"])
        {
            DLog(@"Item %@ effected for %@; INT changed from %d to %f", self.itemData.itemName, characterObject.basicClassData.className, characterObject.intelligencePoint, impactedStatusValue);
            characterObject.intelligencePoint = impactedStatusValue;
        }
        else if ([impactedStatus isEqualToString:@"DEX"])
        {
            DLog(@"Item %@ effected for %@; DEX changed from %d to %f", self.itemData.itemName, characterObject.basicClassData.className, characterObject.dexterityPoint, impactedStatusValue);
            characterObject.dexterityPoint = impactedStatusValue;
        }
        else if ([impactedStatus isEqualToString:@"EVA"])
        {
            DLog(@"Item %@ effected for %@; EVA changed from %d to %f", self.itemData.itemName, characterObject.basicClassData.className, characterObject.evasionPoint, impactedStatusValue);
            characterObject.evasionPoint = impactedStatusValue;
        }
    }
}

-(CCArray*)statsEffectOfItem{
    //0 is HP
    //1 is SP
    //2 is STR
    //3 is DEF
    //4 is INT
    //5 is DEX
    //6 is EVA
    CCArray* statsModifierArray = [[CCArray alloc] initWithCapacity:7];
    for (int x = 0; x < [statsModifierArray count]; x++) {
        [statsModifierArray addObject:@""];
    }
    
    NSArray* impactedStatusList = [self.itemData.impactedStatus componentsSeparatedByString:@";"];
    NSArray* impactedValueList = [self.itemData.impactValue componentsSeparatedByString:@";"];

    for (int effectIndex = 0; effectIndex < [impactedStatusList count]; effectIndex++)
    {
        NSString* impactedStatus = (NSString*)[impactedStatusList objectAtIndex:effectIndex];
        if ([impactedStatus length] < 1) continue;
        
        NSString* valueString = nil;
        if (self.itemData.impactType == itimAdd)
        {
            valueString = [valueString stringByAppendingString:@"+"];
        }
        else if (self.itemData.impactType == itimSubstract)
        {
            valueString = [valueString stringByAppendingString:@"-"];
        }
        else if (self.itemData.impactType == itimMultiply)
        {
            valueString = [valueString stringByAppendingString:@"*"];
        }
        else if (self.itemData.impactType == itimDivide)
        {
            valueString = [valueString stringByAppendingString:@"/"];
        }
        
        CGFloat impactedStatusValue = (int)[impactedValueList objectAtIndex:effectIndex];
        valueString = [valueString stringByAppendingFormat:@"%f", impactedStatusValue];
        
        if ([impactedStatus isEqualToString:@"HP"])
        {
            [statsModifierArray replaceObjectAtIndex:0 withObject:valueString];
        }
        else if ([impactedStatus isEqualToString:@"SP"])
        {
            [statsModifierArray replaceObjectAtIndex:1 withObject:valueString];
        }
        else if ([impactedStatus isEqualToString:@"ATK"])
        {
            [statsModifierArray replaceObjectAtIndex:2 withObject:valueString];
        }
        else if ([impactedStatus isEqualToString:@"DEF"])
        {
            [statsModifierArray replaceObjectAtIndex:3 withObject:valueString];
        }
        else if ([impactedStatus isEqualToString:@"INT"])
        {
            [statsModifierArray replaceObjectAtIndex:4 withObject:valueString];
        }
        else if ([impactedStatus isEqualToString:@"DEX"])
        {
            [statsModifierArray replaceObjectAtIndex:5 withObject:valueString];
        }
        else if ([impactedStatus isEqualToString:@"EVA"])
        {
            [statsModifierArray replaceObjectAtIndex:6 withObject:valueString];
        }
        else
        {
            DLog(@"error: unknown attribute: %@", impactedStatus);
        }
    }
    
    return statsModifierArray;
}

@end
