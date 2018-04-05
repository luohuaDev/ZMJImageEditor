//
//  WBGImageEditorViewController.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditorViewController.h"
#import "WBGImageToolBase.h"
#import "ColorfullButton.h"
#import "WBGDrawTool.h"
#import "WBGTextTool.h"
#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"
#import "WBGTextToolView.h"
#import "UIView+YYAdd.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"
#import "Masonry.h"
#import "YYCategories.h"

NSString * const kColorPanNotificaiton = @"kColorPanNotificaiton";

#pragma mark - WBGImageEditorViewController

@interface WBGImageEditorViewController () <UINavigationBarDelegate, UIScrollViewDelegate, TOCropViewControllerDelegate, WBGMoreKeyboardDelegate, WBGKeyboardDelegate>

@property (nonatomic, strong, nullable) WBGImageToolBase *currentTool;

@property (weak,   nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *drawingView;
@property (weak,   nonatomic) IBOutlet UIScrollView *scrollView;

//@property (strong, nonatomic) IBOutlet WBGColorPan *colorPan;
@property (strong, nonatomic) IBOutlet WBGCustomColorPan *hzColorPan;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UILabel *undoLab;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *sendButtonLab;
//@property (weak, nonatomic) IBOutlet UIButton *panButton;
//@property (weak, nonatomic) IBOutlet UIButton *drawModeSaveBtn;
//@property (weak, nonatomic) IBOutlet UIButton *textButton;
//@property (weak, nonatomic) IBOutlet UIButton *clipButton;
//@property (weak, nonatomic) IBOutlet UIButton *paperButton;

@property (nonatomic, strong) WBGDrawTool *drawTool;
@property (nonatomic, strong) WBGTextTool *textTool;

@property (nonatomic, copy  ) UIImage   *originImage;

@property (nonatomic, assign) CGFloat clipInitScale;
@property (nonatomic, assign) BOOL barsHiddenStatus;
@property (nonatomic, strong) WBGMoreKeyboard *keyboard;

@end

@implementation WBGImageEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init
{
    self = [self initWithNibName:@"WBGImageEditorViewController" bundle:[NSBundle bundleForClass:self.class]];
    if (self){
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image delegate:nil dataSource:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource;
{
    self = [self init];
    if (self){
        _originImage = image;
        self.delegate = delegate;
        self.dataSource = dataSource;
    }
    return self;
}

- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    CGFloat tempColorPanX = ([UIScreen mainScreen].bounds.size.width - self.colorPan.bounds.size.width) / 2.0;
    
    CGFloat tempColorPanY = [UIScreen mainScreen].bounds.size.height - self.colorPan.bounds.size.height - 20.0;
    
    self.colorPan.frame = CGRectMake(tempColorPanX, tempColorPanY, self.colorPan.bounds.size.width, self.colorPan.bounds.size.height);
    self.colorPan.dataSource = self.dataSource;
    [self.view addSubview:_colorPan];*/
    [self.view addSubview:self.hzColorPan];
    [self.hzColorPan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150.0);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@(368.0));
        make.width.equalTo(@(60.0));
    }];
    [self.hzColorPan initAll];
    
    [self initImageScrollView];
    
//    self.panButton.hidden = YES;
//    self.textButton.hidden = YES;
//    self.clipButton.hidden = YES;
//    self.paperButton.hidden = YES;
//    self.hzColorPan.hidden = YES;
//    self.drawModeSaveBtn.hidden = YES;
    
    self.backButton.hidden = NO;
    self.backImage.hidden = NO;
    
    self.undoButton.hidden = YES;
    self.undoLab.hidden = YES;
    
    self.hzColorPan.hidden = NO;
    
    self.sendButton.hidden = NO;
    self.sendButtonLab.hidden = NO;
    
    if(self.state == WBGImageEditorStateEditFeed)
    {
        self.sendButton.hidden = YES;
        self.sendButtonLab.hidden = YES;
    }
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        if([self.dataSource respondsToSelector:@selector(imageEditorCompoment)] &&
           [self.dataSource imageEditorCompoment] & WBGImageEditorDrawComponent)
        {
            [self panAction:nil];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshImageView];
    });
    
    [self configCustomComponent];
}

- (void)configCustomComponent
{
    //WBGImageEditorComponent curComponent = WBGImageEditorCustomComponent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.drawingView) {
        self.drawingView = [[UIImageView alloc] initWithFrame:self.imageView.superview.frame];
        self.drawingView.contentMode = UIViewContentModeCenter;
        self.drawingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        [self.imageView.superview addSubview:self.drawingView];
        self.drawingView.userInteractionEnabled = YES;
    } else {
        //self.drawingView.frame = self.imageView.superview.frame;
    }
}

#pragma mark - 初始化 &getter
- (WBGDrawTool *)drawTool {
    if (_drawTool == nil) {
        _drawTool = [[WBGDrawTool alloc] initWithImageEditor:self];
        
        __weak typeof(self)weakSelf = self;
        _drawTool.drawToolStatus = ^(BOOL canPrev) {
            if(canPrev)
            {
                weakSelf.undoButton.hidden = NO;
                weakSelf.undoLab.hidden = NO;
            }
            else
            {
                weakSelf.undoButton.hidden = YES;
                weakSelf.undoLab.hidden = YES;
            }
            
            if(self.state == WBGImageEditorStateEditFeed)
            {
                if(canPrev)
                {
                    weakSelf.sendButton.hidden = NO;
                    weakSelf.sendButtonLab.hidden = NO;
                }
                else
                {
                    weakSelf.sendButton.hidden = YES;
                    weakSelf.sendButtonLab.hidden = YES;
                }
            }
        };
        _drawTool.drawingCallback = ^(BOOL isDrawing) {
            //[weakSelf hiddenTopAndBottomBar:isDrawing animation:YES];
        };
        _drawTool.drawingDidTap = ^(void) {
            for(UIView *subView in weakSelf.drawingView.subviews)
            {
                if([subView isKindOfClass:[WBGTextToolView class]])
                {
                    [WBGTextToolView setInactiveTextView:(WBGTextToolView *)subView];
                }
            }
            
            //[weakSelf hiddenTopAndBottomBar:!weakSelf.barsHiddenStatus animation:YES];
        };
        _drawTool.pathWidth = [self.dataSource respondsToSelector:@selector(imageEditorDrawPathWidth)] ? [self.dataSource imageEditorDrawPathWidth].floatValue : 5.0f;
    }
    
    return _drawTool;
}

- (WBGTextTool *)textTool {
    if (_textTool == nil) {
        _textTool = [[WBGTextTool alloc] initWithImageEditor:self];
        __weak typeof(self)weakSelf = self;
        _textTool.dissmissTextTool = ^(NSString *currentText) {
            [weakSelf hiddenColorPan:YES animation:YES];
            weakSelf.currentMode = EditorNonMode;
            weakSelf.currentTool = nil;
            
            for(UIView *subView in weakSelf.drawingView.subviews)
            {
                if([subView isKindOfClass:[WBGTextToolView class]])
                {
                    [WBGTextToolView setInactiveTextView:(WBGTextToolView *)subView];
                }
            }
            
            [weakSelf calEditStateSendBtnShow];
        };
    }
    
    return _textTool;
}

- (void)initImageScrollView {
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];

}

- (void)refreshImageView {
    if (self.imageView.image == nil) {
        self.imageView.image = self.originImage;
    }
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
    [self viewDidLayoutSubviews];
}

- (void)resetImageViewFrame {
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width > 0 && size.height > 0 ) {
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 3);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark- ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{ }

#pragma mark - Property
- (void)setCurrentTool:(WBGImageToolBase *)currentTool {
    if(_currentTool != currentTool) {
        [_currentTool cleanup];
        _currentTool = currentTool;
        [_currentTool setup];
        
    }
    
    [self swapToolBarWithEditting];
}

#pragma mark- ImageTool setting
+ (NSString*)defaultIconImagePath {
    return nil;
}

+ (CGFloat)defaultDockedNumber {
    return 0;
}

+ (NSString *)defaultTitle {
    return @"";
}

+ (BOOL)isAvailable {
    return YES;
}

+ (NSArray *)subtools {
    return [NSArray new];
}

+ (NSDictionary*)optionalInfo {
    return nil;
}


#pragma mark - Actions
- (void)onClickDeleteWidgetBtn
{
    [self calEditStateSendBtnShow];
}

- (void)calEditStateSendBtnShow
{
    NSInteger tempDrawCount = [self.drawTool.allLineMutableArray count];
    
    NSInteger tempWidgetCount = 0;
    
    for(UIView *subView in self.drawingView.subviews)
    {
        if([subView isKindOfClass:[WBGTextToolView class]])
        {
            tempWidgetCount++;
        }
    }
    
    if(self.state == WBGImageEditorStateEditFeed)
    {
        BOOL isHide = NO;
        if(tempDrawCount + tempWidgetCount > 0)
        {
            isHide = NO;
        }
        else
        {
            isHide = YES;
        }
        
        self.sendButton.hidden = isHide;
        self.sendButtonLab.hidden = isHide;
    }
}

///发送
- (IBAction)sendAction:(UIButton *)sender {

    [self buildClipImageShowHud:YES clipedCallback:^(UIImage *clipedImage) {
        if ([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)]) {
            [self.delegate imageEditor:self didFinishEdittingWithImage:clipedImage];
        }
    }];
    
}

///涂鸦模式
- (IBAction)panAction:(UIButton *)sender {
    if (_currentMode == EditorDrawMode) {
        return;
    }
    //先设置状态，然后在干别的
    self.currentMode = EditorDrawMode;
    
    self.currentTool = self.drawTool;
    
    for(UIView *subView in self.drawingView.subviews)
    {
        if([subView isKindOfClass:[WBGTextToolView class]])
        {
            [WBGTextToolView setInactiveTextView:(WBGTextToolView *)subView];
        }
    }
    
    [self hiddenColorPan:NO animation:YES];
    
    //self.backButton.hidden = YES;
    //self.textButton.hidden = YES;
    //self.panButton.hidden = YES;
    //self.paperButton.hidden = YES;
    
    //self.drawModeSaveBtn.hidden = NO;
}

//涂鸦模式结束
- (IBAction)onClickDrawModeSaveBtn:(id)sender
{
    self.currentMode = EditorNonMode;
    
    self.currentTool = nil;
    
    [self hiddenColorPan:YES animation:YES];
    
    //self.backButton.hidden = NO;
    //self.textButton.hidden = NO;
    //self.panButton.hidden = NO;
    //self.paperButton.hidden = NO;
    
    //self.drawModeSaveBtn.hidden = YES;
    
    [self calEditStateSendBtnShow];
}

///裁剪模式
- (IBAction)clipAction:(UIButton *)sender {
    
    [self buildClipImageShowHud:NO clipedCallback:^(UIImage *clipedImage) {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:clipedImage];
        cropController.delegate = self;
        __weak typeof(self)weakSelf = self;
        CGRect viewFrame = [self.view convertRect:self.imageView.frame toView:self.navigationController.view];
        [cropController presentAnimatedFromParentViewController:self
                                                      fromImage:clipedImage
                                                       fromView:nil
                                                      fromFrame:viewFrame
                                                          angle:0
                                                   toImageFrame:CGRectZero
                                                          setup:^{
                                                              [weakSelf refreshImageView];
                                                              weakSelf.hzColorPan.hidden = YES;
                                                              weakSelf.currentMode = EditorClipMode;
                                                              [weakSelf setCurrentTool:nil];
                                                          }
                                                     completion:^{
                                                     }];
    }];
    
}

//文字模式
- (IBAction)textAction:(UIButton *)sender {
    if (_currentMode == EditorTextMode) {
        return;
    }
    //先设置状态，然后在干别的
    self.currentMode = EditorTextMode;
    
    self.currentTool = self.textTool;
    [self hiddenColorPan:YES animation:YES];
}

//贴图模式
- (IBAction)paperAction:(UIButton *)sender {
    if (_currentMode == EditorTextMode) {
        return;
    }
    self.currentMode = EditorPaperMode;
    
    NSArray<WBGMoreKeyboardItem *> *sources = nil;
    if (self.dataSource) {
        sources = [self.dataSource imageItemsEditor:self];
    }
    //贴图模块
    [self.keyboard setChatMoreKeyboardData:sources];
    [self.keyboard showInView:self.view withAnimation:YES];
}

- (IBAction)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(imageEditorDidCancel:)])
    {
        [self.delegate imageEditorDidCancel:self];
    }
}

- (IBAction)undoAction:(UIButton *)sender {
    if (self.currentMode == EditorDrawMode) {
        WBGDrawTool *tool = (WBGDrawTool *)self.currentTool;
        [tool backToLastDraw];
    }
}


- (void)editTextAgain {
    //WBGTextTool 钩子调用
    
    if (_currentMode == EditorTextMode) {
        return;
    }
    //先设置状态，然后在干别的
    self.currentMode = EditorTextMode;
    
    if(_currentTool != self.textTool) {
        [_currentTool cleanup];
        _currentTool = self.textTool;
        [_currentTool setup];

    }
    
    [self hiddenColorPan:YES animation:YES];
}

- (void)resetCurrentTool {
    self.currentMode = EditorNonMode;
    self.currentTool = nil;
}

- (WBGMoreKeyboard *)keyboard {
    if (!_keyboard) {
        WBGMoreKeyboard *keyboard = [WBGMoreKeyboard keyboard];
        [keyboard setKeyboardDelegate:self];
        [keyboard setDelegate:self];
        _keyboard = keyboard;
    }
    return _keyboard;
}

#pragma mark - WBGMoreKeyboardDelegate
- (void) moreKeyboard:(id)keyboard didSelectedFunctionItem:(WBGMoreKeyboardItem *)funcItem {
    WBGMoreKeyboard *kb = (WBGMoreKeyboard *)keyboard;
    [kb dismissWithAnimation:YES];
    
    
    WBGTextToolView *view = [[WBGTextToolView alloc] initWithTool:self.textTool text:@"" font:nil orImage:funcItem.image];
    view.borderColor = [UIColor whiteColor];
    view.image = funcItem.image;
    view.center = [self.imageView.superview convertPoint:self.imageView.center toView:self.drawingView];
    view.userInteractionEnabled = YES;
    [self.drawingView addSubview:view];
    [WBGTextToolView setActiveTextView:view];
    
    [self calEditStateSendBtnShow];
}

#pragma mark - WBGKeyboardDelegate

#pragma mark - Cropper Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    self.imageView.image = image;
    __unused CGFloat drawingWidth = self.drawingView.bounds.size.width;
    CGRect bounds = cropViewController.cropView.foregroundImageView.bounds;
    bounds.size = CGSizeMake(bounds.size.width/self.clipInitScale, bounds.size.height/self.clipInitScale);
    
    [self refreshImageView];
    [self viewDidLayoutSubviews];


    self.navigationItem.rightBarButtonItem.enabled = YES;
    __weak typeof(self)weakSelf = self;
    if (cropViewController.croppingStyle != TOCropViewCroppingStyleCircular) {

        [cropViewController dismissAnimatedFromParentViewController:self
                                                   withCroppedImage:image
                                                             toView:self.imageView
                                                            toFrame:CGRectZero
                                                              setup:^{
                                                                  [weakSelf refreshImageView];
                                                                  [weakSelf viewDidLayoutSubviews];
                                                                  weakSelf.hzColorPan.hidden = NO;
                                                              }
                                                         completion:^{
                                                             weakSelf.hzColorPan.hidden = NO;
                                                         }];
    }
    else {
        
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    //生成图片后，清空画布内容
    [self.drawTool.allLineMutableArray removeAllObjects];
    [self.drawTool drawLine];
    [_drawingView removeAllSubviews];
    self.undoButton.hidden = YES;
    self.undoLab.hidden = YES;
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    __weak typeof(self)weakSelf = self;
    [cropViewController dismissAnimatedFromParentViewController:self
                                               withCroppedImage:self.imageView.image
                                                         toView:self.imageView
                                                        toFrame:CGRectZero
                                                          setup:^{
                                                              [weakSelf refreshImageView];
                                                              [weakSelf viewDidLayoutSubviews];
                                                              weakSelf.hzColorPan.hidden = NO;
                                                          }
                                                     completion:^{
                                                         [UIView animateWithDuration:.3f animations:^{
                                                             weakSelf.hzColorPan.hidden = NO;
                                                         }];
                                                         
                                                     }];
}

#pragma mark -
- (void)swapToolBarWithEditting {
    switch (_currentMode) {
        case EditorDrawMode:
        {
            //self.panButton.selected = YES;
            if (self.drawTool.allLineMutableArray.count > 0) {
                self.undoButton.hidden  = NO;
                self.undoLab.hidden = NO;
            }
        }
            break;
        case EditorTextMode:
        case EditorClipMode:
        case EditorNonMode:
        {
            //self.panButton.selected = NO;
            self.undoButton.hidden  = YES;
            self.undoLab.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)hiddenTopAndBottomBar:(BOOL)isHide animation:(BOOL)animation {
    if (self.keyboard.isShow) {
        [self.keyboard dismissWithAnimation:YES];
        return;
    }
    
    [UIView animateWithDuration:animation ? .25f : 0.f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:isHide ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn animations:^{
        if(isHide)
        {
            //self.bottomBar.alpha = 0.0;
            //self.topBar.alpha = 0.0;
            self.backButton.alpha = 0.0;
            self.backImage.alpha = 0.0;
            //self.panButton.alpha = 0.0;
            //self.textButton.alpha = 0.0;
            //self.paperButton.alpha = 0.0;
            self.undoButton.alpha = 0.0;
            self.undoLab.alpha = 0.0;
            self.sendButton.alpha = 0.0;
            self.sendButtonLab.alpha = 0.0;
            //self.drawModeSaveBtn.alpha = 0.0;
            self.hzColorPan.alpha = 0.0;
        }
        else
        {
            //self.bottomBar.alpha = 1.0;
            //self.topBar.alpha = 1.0;
            self.backButton.alpha = 1.0;
            self.backImage.alpha = 1.0;
            //self.panButton.alpha = 1.0;
            //self.textButton.alpha = 1.0;
            //self.paperButton.alpha = 1.0;
            self.undoButton.alpha = 1.0;
            self.undoLab.alpha = 1.0;
            self.sendButton.alpha = 1.0;
            self.sendButtonLab.alpha = 1.0;
            //self.drawModeSaveBtn.alpha = 1.0;
            self.hzColorPan.alpha = 1.0;
        }
        _barsHiddenStatus = isHide;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenColorPan:(BOOL)yesOrNot animation:(BOOL)animation {
    [UIView animateWithDuration:animation ? .25f : 0.f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:yesOrNot ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn animations:^{
        self.hzColorPan.hidden = yesOrNot;
    } completion:^(BOOL finished) {
    
    }];
}

+ (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    shareView.layer.affineTransform = shareView.transform;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)buildClipImageShowHud:(BOOL)showHud clipedCallback:(void(^)(UIImage *clipedImage))clipedCallback {
    if (showHud) {
        //ShowBusyTextIndicatorForView(self.view, @"生成图片中...", nil);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat WS = self.imageView.width/ self.drawingView.width;
        CGFloat HS = self.imageView.height/ self.drawingView.height;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height),
                                               NO,
                                               self.imageView.image.scale);
        [self.imageView.image drawAtPoint:CGPointZero];
        CGFloat viewToimgW = self.imageView.width/self.imageView.image.size.width;
        CGFloat viewToimgH = self.imageView.height/self.imageView.image.size.height;
        __unused CGFloat drawX = self.imageView.left/viewToimgW;
        CGFloat drawY = self.imageView.top/viewToimgH;
        [_drawingView.image drawInRect:CGRectMake(0, -drawY, self.imageView.image.size.width/WS, self.imageView.image.size.height/HS)];
        
        for (UIView *subV in _drawingView.subviews) {
            if ([subV isKindOfClass:[WBGTextToolView class]]) {
                WBGTextToolView *textLabel = (WBGTextToolView *)subV;
                //进入正常状态
                [WBGTextToolView setInactiveTextView:textLabel];
                
                //生成图片
                 __unused UIView *tes = textLabel.archerBGView;
                UIImage *textImg = [self.class screenshot:textLabel.archerBGView orientation:UIDeviceOrientationPortrait usePresentationLayer:YES];
                CGFloat rotation = textLabel.archerBGView.layer.transformRotationZ;
                textImg = [textImg imageRotatedByRadians:rotation];
                
                CGFloat selfRw = self.imageView.bounds.size.width / self.imageView.image.size.width;
                CGFloat selfRh = self.imageView.bounds.size.height / self.imageView.image.size.height;
                
                CGFloat sw = textImg.size.width / selfRw;
                CGFloat sh = textImg.size.height / selfRh;
                
                [textImg drawInRect:CGRectMake(textLabel.left/selfRw, (textLabel.top/selfRh) - drawY, sw, sh)];
            }
        }
        
        UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //HideBusyIndicatorForView(self.view);
            UIImage *image = [UIImage imageWithCGImage:tmp.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            clipedCallback(image);
            
        });
    });
}

+ (UIImage *)screenshot:(UIView *)view orientation:(UIDeviceOrientation)orientation usePresentationLayer:(BOOL)usePresentationLayer
{
    CGSize size = view.bounds.size;
    CGSize targetSize = CGSizeMake(size.width * view.layer.transformScaleX, size.height *  view.layer.transformScaleY);
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    [view drawViewHierarchyInRect:CGRectMake(0, 0, targetSize.width, targetSize.height) afterScreenUpdates:NO];
    CGContextRestoreGState(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

#pragma mark - Class WBGWColorPan
/*
@interface WBGColorPan ()
@property (nonatomic, strong) UIColor *currentColor;
@property (strong, nonatomic) IBOutletCollection(ColorfullButton) NSArray *colorButtons;

@property (weak, nonatomic) IBOutlet ColorfullButton *redButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *orangeButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *yellowButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *greenButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *blueButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *pinkButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *whiteButton;

@end

@implementation WBGColorPan

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if(self)
    {
    }
    
    return self;
}

- (UIColor *)currentColor
{
    if (_currentColor == nil)
    {
        _currentColor = ([self.dataSource respondsToSelector:@selector(imageEditorDefaultColor)] && [self.dataSource imageEditorDefaultColor]) ? [self.dataSource imageEditorDefaultColor] : UIColor.redColor;
    }
    return _currentColor;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)panSelectColor:(UIPanGestureRecognizer *)recognizer {
    
    NSLog(@"recon = %@", NSStringFromCGPoint([recognizer translationInView:self]));
}

- (IBAction)buttonAction:(UIButton *)sender {
    ColorfullButton *theBtns = (ColorfullButton *)sender;
    
    for (ColorfullButton *button in _colorButtons) {
        if (button == theBtns) {
            button.isUse = YES;
            self.currentColor = theBtns.color;
            [[NSNotificationCenter defaultCenter] postNotificationName:kColorPanNotificaiton object:self.currentColor];
        } else {
            button.isUse = NO;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSLog(@"point: %@", NSStringFromCGPoint([touch locationInView:self]));
    NSLog(@"view=%@", touch.view);
    CGPoint touchPoint = [touch locationInView:self];
    for (ColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //NSLog(@"move->point: %@", NSStringFromCGPoint([touch locationInView:self]));
    CGPoint touchPoint = [touch locationInView:self];
    
    for (ColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

@end
*/
