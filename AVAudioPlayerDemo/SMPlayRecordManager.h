//
//  SMPlayRecordManager.h
//  Meetville
//
//  Created by jzy on 16/12/20.
//  Copyright © 2016年 secretlisa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMPlayRecordManager : NSObject

+ (instancetype)shareInstance;

- (BOOL)playRecord:(NSURL *)recordUrl;

- (BOOL)playFileRecord:(NSString *)fileName;

- (BOOL)playLocalFileRecord:(NSString *)fileName;

+ (NSTimeInterval)recorderDuration:(NSString *)fileName;

+ (NSTimeInterval)localRecorderDuration:(NSString *)fileName;

@end
