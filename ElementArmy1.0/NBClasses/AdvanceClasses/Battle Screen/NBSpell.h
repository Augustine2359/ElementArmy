//
//  NBSpell.h
//  ElementArmy1.0
//
//  Created by Augustine on 8/4/13.
//
//

#import "CCNode.h"

@class NBSpell;

@protocol NBSpellDelegate <NSObject>

@end

@interface NBSpell : CCNode

@property (nonatomic, strong) id<NBSpellDelegate> delegate;

@end
