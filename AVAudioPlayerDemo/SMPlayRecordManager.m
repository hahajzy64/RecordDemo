//
//  SMPlayRecordManager.m
//  Meetville
//
//  Created by jzy on 16/12/20.
//  Copyright © 2016年 secretlisa. All rights reserved.
//

#import "SMPlayRecordManager.h"
#import <AVFoundation/AVFoundation.h>

@interface SMPlayRecordManager () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件

@end

@implementation SMPlayRecordManager

+ (instancetype)shareInstance
{
    static SMPlayRecordManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SMPlayRecordManager alloc] init];
    });
    return instance;
}

- (BOOL)playRecord:(NSURL *)recordUrl
{
    [self.audioPlayer stop];
    NSLog(@"%@", recordUrl);
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordUrl error:nil];
    self.audioPlayer.delegate = self;
    if (self.audioPlayer) {
        [self.audioPlayer play];
        return YES;
    }
    return NO;
}

- (BOOL)playFileRecord:(NSString *)fileName
{
    NSURL *destURL = [SMPlayRecordManager destPathWithFileName:fileName];
    return [self playRecord:destURL];
}

- (BOOL)playLocalFileRecord:(NSString *)fileName
{
    NSURL *destURL = [SMPlayRecordManager desstPathWithLocalFileName:fileName];
    return [self playRecord:destURL];
}

+ (NSURL *)destPathWithFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSString *destPath = [docsDir stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:destPath];
    
}

+ (NSURL *)desstPathWithLocalFileName:(NSString *)fileName
{
    NSString *string = [[NSBundle mainBundle] pathForResource:fileName ofType:@"acc"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    return url;
}

+ (NSTimeInterval)recorderDuration:(NSString *)fileName
{
    NSURL *destURL = [self destPathWithFileName:fileName];
    AVAudioPlayer *tempPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:destURL error:nil];
    return tempPlayer.duration;
}

+ (NSTimeInterval)localRecorderDuration:(NSString *)fileName
{
    NSURL *destURL = [self desstPathWithLocalFileName:fileName];
    AVAudioPlayer *tempPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:destURL error:nil];
    return tempPlayer.duration;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 播放完成
}

@end
