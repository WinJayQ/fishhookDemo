//
//  ViewController.m
//  fishhookDemo
//
//  Created by zhihuishequ on 2018/5/16.
//  Copyright © 2018年 WinJayQ. All rights reserved.
//

#import "ViewController.h"
#import "fishhook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    struct rebinding {
        const char *name; //需要HOOK的函数名称，字符串
        void *replacement;//替换到哪个新的函数上(函数指针，也就是函数的名称)
        void **replaced;//保存原始函数指针变量的指针(它是一个二级指针)
    };*/
    
     //定义rebinding结构体
    struct rebinding nslogBind;
    //函数名称
    nslogBind.name = "NSLog";
    //新的函数地址
    nslogBind.replacement = myNSLog;
    //保存原始函数地址的变量的指针
    nslogBind.replaced = (void *)&old_nslog;
    
    //数组
    struct rebinding rebs[]={nslogBind};
    
    
    /*
     arg1:存放rebinding结构体的数组
     arg2:数组的长度
     */
    rebind_symbols(rebs, 1);
}

//函数指针，用来保存原始的函数的地址
static void(*old_nslog)(NSString *format, ...);

//新的NSLog
void myNSLog(NSString *format, ...){
    format = @"~~勾上了！\n🐶🐶🐶🐶🐶";
    //再调用原来的nslog
    old_nslog(format);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了屏幕!");
}

@end
