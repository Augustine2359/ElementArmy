//
//  NBAudioManager.m
//  ElementArmy1.0
//
//  Created by Augustine on 25/4/13.
//
//

#import "NBAudioManager.h"
#import "SimpleAudioEngine.h"

@implementation NBAudioManager

+ (NBAudioManager *)sharedInstance {
  static NBAudioManager *_sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[self alloc] init];
  });
  
  return _sharedInstance;
}

- (void)playSoundEffect:(NSString *)soundEffect {
  [[SimpleAudioEngine sharedEngine] playEffect:soundEffect];
}

@end
