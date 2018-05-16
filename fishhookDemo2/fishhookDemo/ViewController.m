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
    //交换
    rebind_symbols((struct rebinding[1]){{"func",newFunc,(void *)&funcP}}, 1);
}

//原始指针
static void(*funcP)(const char *);

//新的函数
void newFunc(const char *str){
    NSLog(@"勾上了！");
    funcP(str);
}


void func(const char *str){
    NSLog(@"%s",str);
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    func("hello");
}

@end
