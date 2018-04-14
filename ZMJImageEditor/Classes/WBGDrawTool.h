//
//  WBGDrawTool.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/28.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageToolBase.h"
@class WBGPath;

@interface WBGDrawTool : WBGImageToolBase
@property (nonatomic, copy) void (^drawToolStatus)(BOOL canPrev);
@property (nonatomic, copy) void (^drawingCallback)(BOOL isDrawing);
@property (nonatomic, copy) void (^drawingDidTap)(void);
@property (nonatomic, strong) NSMutableArray<WBGPath *> *allLineMutableArray;
@property (nonatomic, assign) CGFloat pathWidth;
//撤销
- (void)backToLastDraw;
- (void)drawLinePathEx;
@end

#pragma mark - HBPath
@interface WBGPath : NSObject

@property (nonatomic, strong) CAShapeLayer *shape;
@property (nonatomic, strong) UIColor *pathColor;//画笔颜色

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth;
- (void)drawPath;//绘制

//参考
- (void)pathExTouchesBegan:(CGPoint)point;
- (void)pathExTouchesMoved:(CGPoint)point;

@property (nonatomic, weak) WBGDrawTool *superState;

@end
