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

@property (unsafe_unretained, nonatomic) IBOutlet UIView *pageControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *point0;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *point1;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *point2;

- (void)initAll;

@end
