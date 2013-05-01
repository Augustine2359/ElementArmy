//
//  NBAudioManager.m
//  ElementArmy1.0
//
//  Created by Augustine on 25/4/13.
//
//

#import "NBAudioManager.h"
#import "SimpleAudioEngine.h"

@interface NBAudioManager()

@property (nonatomic) NSInteger bgmVolume;
@property (nonatomic) BOOL isMute;
@property (nonatomic, strong) NSString *currentBGM;

@end

@implementation NBAudioManager

+ (NBAudioManager *)sharedInstance {
  static NBAudioManager *_sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[self alloc] init];
  });
  
  return _sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    self.bgmVolume = 5;
    self.isMute = NO;
    [self playBGM:@"FFMainTheme.mp3"];
  }

  return self;
}

- (NSInteger)bgmVolume {
  return _bgmVolume;
}

- (BOOL)isMute {
  return _isMute;
}

- (void)playSoundEffect:(NSString *)soundEffect {
  [[SimpleAudioEngine sharedEngine] playEffect:soundEffect];
}

- (void)playBGM:(NSString *)bgmString {
  self.currentBGM = bgmString;
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:self.currentBGM loop:YES];
}

- (void)stopBGM {
  self.currentBGM = nil;
  [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}


- (void)decreaseBGMVolume {
  self.bgmVolume--;
  if (self.bgmVolume < 0)
    self.bgmVolume = 0;

  [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:(self.bgmVolume)*1.0/10];
}

- (void)increaseBGMVolume {
  self.bgmVolume++;
  if (self.bgmVolume > 10)
    self.bgmVolume = 10;

  [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:(self.bgmVolume)*1.0/10];
}

- (void)toggleMute {
  self.isMute = !self.isMute;
  if (self.isMute)
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
  else
    if (self.currentBGM != nil)
      [[SimpleAudioEngine sharedEngine] playBackgroundMusic:self.currentBGM loop:YES];
}

@end
