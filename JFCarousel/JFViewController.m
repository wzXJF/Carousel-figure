//
//  JFViewController.m
//  JFCarousel
//
//  Created by JFCarousel on 2016/10/7.
//  Copyright © 2016年 JFCarousel. All rights reserved.
//

#import "JFViewController.h"
#import "JFView.h"

@interface JFViewController ()

@end

@implementation JFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *images = [NSMutableArray array];
    [images addObject:@"http://img0.pcauto.com.cn/pcauto/picSystem/Mpic/dt/1703/154456.jpg"];
    [images addObject:@"hpAdvAOverseas"];
    [images addObject:@"http://img0.pcauto.com.cn/pcauto/picSystem/Mpic/dt/1703/xingmai.jpg"];
    [images addObject:@"hpAdvATimeout"];
    JFView *v = [[JFView alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200) images:images playSpeed:2.0];
    [self.view addSubview:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
