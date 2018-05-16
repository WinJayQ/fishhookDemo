# fishhookDemo
iOS逆向之fishhookDemo
题外话：此教程是一篇严肃的学术探讨类文章，仅仅用于学习研究，也请读者不要用于商业或其他非法途径上，笔者一概不负责哟~~

##准备工作
* 非越狱的iPhone手机
* [fishhook](https://github.com/facebook/fishhook)

##Demo 1:

###1、新建工程，将fishhook文件拖入工程
![image.png](https://upload-images.jianshu.io/upload_images/1013424-54369e6d3c79349b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###2、我们的目的是hook系统的NSLog函数，编写代码
```
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

```

###3、了解fishhook中的struct rebinding结构体
```
struct rebinding {
        const char *name; //需要HOOK的函数名称，字符串
        void *replacement;//替换到哪个新的函数上(函数指针，也就是函数的名称)
        void **replaced;//保存原始函数指针变量的指针(它是一个二级指针)
    };
```
定义结构体：
```
 //定义rebinding结构体
    struct rebinding nslogBind;
    //函数名称
    nslogBind.name = "NSLog";
    //新的函数地址
    nslogBind.replacement = myNSLog;
    //保存原始函数地址的变量的指针
    nslogBind.replaced = (void *)&old_nslog;
```
重新绑定：
```
//数组
    struct rebinding rebs[]={nslogBind};
    
    /*
     arg1:存放rebinding结构体的数组
     arg2:数组的长度
     */
    rebind_symbols(rebs, 1);
```

###4、运行，点击屏幕，打印的是我们自己的myNSLog
![image.png](https://upload-images.jianshu.io/upload_images/1013424-1e5b73859297c15b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**是不是很爽，是不是很简单？好，看点不一样的**

##Demo2

###1、自己写了两个函数func和newFunc：
```
void func(const char *str){
    NSLog(@"%s",str);
}
```
```
void newFunc(const char *str){
    NSLog(@"勾上了！");
    funcP(str);
}
```

###2、现在的目的是想交换func和newFunc，当调用func时，我们调用newFunc，跟Demo1一样的编写代码

![image.png](https://upload-images.jianshu.io/upload_images/1013424-56230c9c355548a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###3、运行点击屏幕，发现打印的是func中的文字，并不是newFunc的文字
![image.png](https://upload-images.jianshu.io/upload_images/1013424-cd49ec9f8cd6a89f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**代码没有任何问题，但就是勾不住；自己写的函数是勾不住的，具体原因见下回分解 😁**



