//
//  WBGCustomColorPan.h
//  ZMJImageEditor
//
//  Created by LUOHUA_Think on 2018/2/24.
//

#import <UIKit/UIKit.h>

@interface WBGCustomColorPan : UIView

@property (nonatomic, strong) IBOutlet UICollectionView *contentView;
@property (nonatomic, strong) UIColor *currentColor;

- (void)initAll;

@end
