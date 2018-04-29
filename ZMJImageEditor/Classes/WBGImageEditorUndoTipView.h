//
//  WBGImageEditorUndoTipView.h
//  ZMJImageEditor
//
//  Created by LUOHUA_Think on 2018/4/25.
//

#import <UIKit/UIKit.h>

@class  WBGImageEditorUndoTipView;

typedef void(^WBGImageEditorUndoTipViewBlock)(BOOL isAbandon, WBGImageEditorUndoTipView *view);

@interface WBGImageEditorUndoTipView : UIView

@property (nonatomic, copy) WBGImageEditorUndoTipViewBlock clickBlock;

@end
