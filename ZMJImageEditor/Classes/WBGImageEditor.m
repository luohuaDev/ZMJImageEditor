//
//  WBGImageEditor.m
//  Trader
//
//  Created by Jason on 2017/3/13.
//
//

#import "WBGImageEditor.h"
#import "WBGImageEditorViewController.h"

@interface WBGImageEditor ()

@end

@implementation WBGImageEditor

- (instancetype)init
{
    return [WBGImageEditorViewController new];
}

- (id)initWithImage:(UIImage*)image
{
    return [self initWithImage:image delegate:nil dataSource:nil];
}

- (id)initWithClearImage:(UIImage *)imageTouMing imageView:(UIImageView *)imageView delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource
{
    WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:imageTouMing delegate:delegate dataSource:dataSource];
    
    UIView *editorView = editor.view;
    NSArray *editorViewSubviews = editorView.subviews;
    
    UIView *tempView = [editorViewSubviews firstObject];
    NSArray *tempViewSubViews = tempView.subviews;
    
    for(UIView * view in tempViewSubViews)
    {
        if([view isKindOfClass:[UIScrollView class]])
        {
            NSArray *scrollSubViews = view.subviews;
            if([scrollSubViews count] == 1)
            {
                UIView *scrollSubView = [scrollSubViews firstObject];
                [view insertSubview:imageView belowSubview:scrollSubView];
            }
            
            break;
        }
    }
    
    return editor;
}

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource;
{
    return [[WBGImageEditorViewController alloc] initWithImage:image delegate:delegate dataSource:dataSource];
}

- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate
{
    return [[WBGImageEditorViewController alloc] initWithDelegate:delegate];
}

- (void)showInViewController:(UIViewController*)controller withImageView:(UIImageView*)imageView;
{
    
}

- (void)refreshToolSettings
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
