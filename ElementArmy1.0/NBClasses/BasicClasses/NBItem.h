//
//  NBItem.h
//  ElementArmy1.0
//
//  Created by Romy Irawaty on 28/1/13.
//
//

#import <Foundation/Foundation.h>
#import "NBItemData.h"

@interface NBItem : NSObject
{
    bool isActivated;
}

+(NBItem*)getCurrentlySelectedItem;
+(id)createItem:(NBItemData*)newItemData onLayer:(id)layer onSelector:(SEL)selector;
-(id)setItemIconWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage disabledImage:(NSString*)disabledImage onLayer:(CCLayer*)layer;
-(void)displayItemIcon;
-(void)hideItemIcon;
-(void)onItemSelected;

@property (nonatomic, retain) NBItemData* itemData;
@property (nonatomic, retain) NBButton* itemIcon;

@property (nonatomic, retain) NSString* image;

@property (nonatomic, retain) id currentLayer;
@property (nonatomic, assign) SEL currentSelector;

@end
