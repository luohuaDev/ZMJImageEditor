//
//  WBGDrawTool.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGDrawTool.h"
#import "WBGImageEditorGestureManager.h"
#import "WBGTextToolView.h"

@interface WBGDrawTool ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation WBGDrawTool
{
    __weak UIImageView *_drawingView;
    CGSize _originalImageSize;
}

- (instancetype)initWithImageEditor:(WBGImageEditorViewController *)editor
{
    self = [super init];
    
    if(self)
    {
        self.editor = editor;
        
        _allLineMutableArray = [NSMutableArray new];//这个数组里的每个元素代表一条划线
    }
    
    return self;
}

- (void)backToLastDraw
{
    [_allLineMutableArray removeLastObject];
    
    [self drawLinePathEx];
    
    if(self.drawToolStatus)
    {
        self.drawToolStatus(_allLineMutableArray.count > 0 ? : NO);
    }
}

#pragma mark - Gesture
//tap
- (void)drawingViewDidTap:(UITapGestureRecognizer *)sender
{
    if(self.drawingDidTap)
    {
        self.drawingDidTap();
    }
}

//draw
- (void)drawingViewDidPan:(UIPanGestureRecognizer *)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawingView];
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        for(UIView *subView in self.editor.drawingView.subviews)
        {
            if([subView isKindOfClass:[WBGTextToolView class]])
            {
                [WBGTextToolView setInactiveTextView:(WBGTextToolView *)subView];
            }
        }
        
        WBGPath *path = [WBGPath pathToPoint:currentDraggingPosition pathWidth:MAX(1, self.pathWidth)];
        
        path.pathColor = self.editor.hzColorPan.currentColor;
        
        path.superState = self;
        
        [_allLineMutableArray addObject:path];
        
        [path pathExTouchesBegan:currentDraggingPosition];
    }
    
    if(sender.state == UIGestureRecognizerStateChanged)
    {
        WBGPath *path = [_allLineMutableArray lastObject];
        
        [path pathExTouchesMoved:currentDraggingPosition];
        
        if(self.drawingCallback)
        {
            self.drawingCallback(YES);
        }
    }
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        if(self.drawToolStatus)
        {
            self.drawToolStatus(_allLineMutableArray.count > 0 ? : NO);
        }
        
        if(self.drawingCallback)
        {
            self.drawingCallback(NO);
        }
    }
}

- (void)drawLinePathEx
{
    CGSize size = _drawingView.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    for(WBGPath *path in _allLineMutableArray)
    {
        [path drawPath];
    }
    
    _drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (UIImage *)buildImage
{
    UIGraphicsBeginImageContextWithOptions(_originalImageSize, NO, self.editor.imageView.image.scale);
    
    [self.editor.imageView.image drawAtPoint:CGPointZero];
    
    [_drawingView.image drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

#pragma mark - implementation 重写父方法
- (void)setup {
    //初始化一些东西
    _originalImageSize   = self.editor.imageView.image.size;
    _drawingView         = self.editor.drawingView;
    
    //滑动手势
    if (!self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
        self.panGesture.delegate = [WBGImageEditorGestureManager instance];
        self.panGesture.maximumNumberOfTouches = 1;
    }
    if (!self.panGesture.isEnabled) {
        self.panGesture.enabled = YES;
    }
    
    //点击手势
    if (!self.tapGesture) {
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidTap:)];
        self.tapGesture.delegate = [WBGImageEditorGestureManager instance];
        self.tapGesture.numberOfTouchesRequired = 1;
        self.tapGesture.numberOfTapsRequired = 1;
        
    }
    
    [_drawingView addGestureRecognizer:self.panGesture];
    [_drawingView addGestureRecognizer:self.tapGesture];
    _drawingView.userInteractionEnabled = YES;
    _drawingView.layer.shouldRasterize = YES;
    _drawingView.layer.minificationFilter = kCAFilterTrilinear;
    
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    //TODO: todo?

}

- (void)cleanup {
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGesture.enabled = NO;
    //TODO: todo?
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

@end

#pragma mark - WBGPath
@interface WBGPath()
{
    //参考那个
    UIImage *incrementalImage;
    CGPoint pts[5];
    uint ctr;
}

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;

@end

@implementation WBGPath

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth     = pathWidth;
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    
    WBGPath *path   = [[WBGPath alloc] init];
    path.beginPoint = beginPoint;
    path.pathWidth  = pathWidth;
    path.bezierPath = bezierPath;
    
    return path;
}

- (void)drawPath
{
    [[UIColor whiteColor] set];

    CGContextRef content = UIGraphicsGetCurrentContext();
    
    CGContextSetShadowWithColor(content, CGSizeMake(0, 0), 10.0, self.pathColor.CGColor);
    
    [self.bezierPath stroke];
}

//参考
- (void)pathExTouchesBegan:(CGPoint)point
{
    ctr = 0;
    
    pts[0] = point;
}

- (void)pathExTouchesMoved:(CGPoint)point
{
    CGPoint p = point;
    
    ctr++;
    
    pts[ctr] = p;
    
    if(ctr == 4)
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0);
        
        [self.bezierPath moveToPoint:pts[0]];
        [self.bezierPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
        
        [self.superState drawLinePathEx];
        
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
}

@end
