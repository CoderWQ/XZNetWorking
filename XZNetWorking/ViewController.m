//
//  ViewController.m
//  XZNetWorking
//
//  Created by 徐文强 on 16/9/6.
//  Copyright © 2016年 coderxu.com. All rights reserved.
//

#import "ViewController.h"
#import "XZNetWorkManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [XZNetWorkManager GETRequestWithUrl:@"http://httpbin.org/get" parameters:nil success:^(id response) {
       
        NSLog(@"%@---%@",[NSThread currentThread],response);
        
    } failure:^(NSError *error) {
        
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
