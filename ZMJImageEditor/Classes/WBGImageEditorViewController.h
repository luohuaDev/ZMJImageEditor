//
//  WBGImageEditorViewController.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditor.h"
#import "WBGCustomColorPan.h"

typedef NS_ENUM(NSUInteger, EditorMode) {
    EditorNonMode,
    EditorDrawMode,
    EditorTextMode,
    EditorClipMode,
    EditorPaperMode,
};

extern NSString * const kColorPanNotificaiton;

/*
@interface WBGColorPan : UIView
@property (nonatomic, strong, readonly) UIColor *currentColor;
@property (nonatomic, weak) id<WBGImageEditorDataSource> dataSource;
@end
*/

@interface WBGImageEditorViewController : WBGImageEditor

@property (weak,   nonatomic, readonly) IBOutlet UIImageView *imageView;
@property (strong, nonatomic, readonly) IBOutlet UIImageView *drawingView;
@property (weak,   nonatomic, readonly) IBOutlet UIScrollView *scrollView;

//@property (strong, nonatomic, readonly) IBOutlet WBGColorPan *colorPan;
@property (nonatomic, strong, readonly) IBOutlet WBGCustomColorPan *hzColorPan;

@property (nonatomic, assign) EditorMode currentMode;

- (void)resetCurrentTool;

- (void)editTextAgain;
- (void)hiddenTopAndBottomBar:(BOOL)isHide animation:(BOOL)animation;
- (void)onClickDeleteWidgetBtn;

@end
