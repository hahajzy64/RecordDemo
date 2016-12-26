//
//  ViewController.m
//  AVAudioPlayerDemo
//
//  Created by jzy on 16/12/26.
//  Copyright © 2016年 secretlisa. All rights reserved.
//

#import "ViewController.h"
#import "SMPlayRecordManager.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
}

- (void)setUpViews
{
    [self.view addSubview:self.tableView];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [self getAllVideoNames];
    }
    return _dataSource;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    NSString *videoName = self.dataSource[indexPath.row];
    NSString *videoNameNoAcc = [videoName stringByReplacingOccurrencesOfString:@".acc" withString:@""];
    NSInteger videoTime = [SMPlayRecordManager localRecorderDuration:videoNameNoAcc];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%lds", videoName, (long)videoTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *videoName = self.dataSource[indexPath.row];
    videoName = [videoName stringByReplacingOccurrencesOfString:@".acc" withString:@""];
    [[SMPlayRecordManager shareInstance] playLocalFileRecord:videoName];
}

#pragma mark - private
- (NSArray *)getAllFileNames
{
    NSString *documentsDirectory = [[NSBundle mainBundle] bundlePath];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
    return files;
}

- (NSArray *)getAllVideoNames
{
    NSMutableArray *allVideoNames = [[NSMutableArray alloc] init];
    NSArray *allFileNames = [self getAllFileNames];
    for (NSString *eachFileName in allFileNames) {
        if ([eachFileName hasSuffix:@".acc"]) {
            [allVideoNames addObject:eachFileName];
        }
    }
    return allVideoNames;
}

@end
