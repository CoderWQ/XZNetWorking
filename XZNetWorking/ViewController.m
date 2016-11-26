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
@property(nonatomic,strong)UITextView *textview;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITextView *textview = [[UITextView alloc] init];
    textview.frame = CGRectMake(100, 100, 200, 400);
    self.textview = textview;
    [self.view addSubview:textview];
    
    
    
    
    
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hashTablde) name:@"hahahha" object:nil];

}
- (void)hashTablde{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"哈哈哈" message:@"出错了" delegate:self cancelButtonTitle:@"啊哈哈" otherButtonTitles:@"哈哈", nil];
    [view show];
}

- (IBAction)clickBtn:(id)sender {
    
    XZNetWorkManager *mgr =  [XZNetWorkManager manager];
    
    [mgr GETRequestWithUrl:@"http://httpbin.org/get" parameters:nil success:^(id response) {
        
        NSLog(@"请求成功");
        NSLog(@"%@",[response class]);
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSString *text =  [self dictionaryToJson:response];
            
            self.textview.text = text;
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self connectInternet];
}
- (void)connectInternet{
    
   XZNetWorkManager *mgr =  [XZNetWorkManager manager];

    
    
   [mgr GETRequestWithUrl:@"http://httpbin.org/get" parameters:nil success:^(id response) {
        
       NSLog(@"请求成功---%@",[response class]);
       
       
       
       if ([response isKindOfClass:[NSDictionary class]]) {
       NSString *text =  [self dictionaryToJson:response];
       
           self.textview.text = text;

       
       }
       
       
       
    } failure:^(NSError *error) {
        
    }];
    
    
}

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
