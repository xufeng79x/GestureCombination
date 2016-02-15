//
//  ViewController.m
//  GestureCombination
//
//  Created by apple on 16/2/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *testView;

// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

// 手势限制
@property (nonatomic,assign) BOOL panEnable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    //  长按是需要一个过程的，一般默认按下0.5秒后才能被识别出，为了避免在识别出之前做touchBegan事件，需要设定延迟转发
    [self.longPressGesture setDelaysTouchesBegan:YES];
    
    [self.testView addGestureRecognizer:self.longPressGesture];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    
    self.panGesture.delegate = self;
    
    [self.testView addGestureRecognizer:self.panGesture];
    
    
}

//拖动事件处理
-(void) panView:(UIPanGestureRecognizer *)gr
{
    if (!self.panEnable) {
        return;
    }
    // 在移动的时候触发处理
    if (gr.state == UIGestureRecognizerStateChanged) {
        // 当前手势移动到哪里了
        CGPoint translation = [gr translationInView:self.testView];
        CGRect frame = self.testView.frame;
        frame.origin.x += translation.x;
        frame.origin.y += translation.y;
        
        self.testView.frame = frame;
        
        // 增加此行代码后，每一次都会传来增量的移动坐标数据。
        [gr setTranslation:CGPointZero inView:self.testView];
    }
}

// 长按事件处理
-(void) longPress:(UILongPressGestureRecognizer *)gr
{
    // 当长按被识别到的时候,将view颜色设置为绿色
    if (gr.state == UIGestureRecognizerStateBegan) {
        self.testView.backgroundColor = [UIColor greenColor];
        self.panEnable = YES;
    }
    // 当长按并移动手指的时候保持颜色不变
    else if (gr.state == UIGestureRecognizerStateChanged){
        self.testView.backgroundColor = [UIColor greenColor];
        self.panEnable = YES;
    }
    // 当长结束或者其他状态的时候设置为原来的黑色
    else{
        self.testView.backgroundColor = [UIColor blackColor];
        self.panEnable = NO;
    }
}

// 覆盖代理方法，当某个手势也辨识出当前行为时候，会调用此方法来申请是否能够参与活动
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.panGesture){
        return YES;
    }
    
    return NO;
}

@end
