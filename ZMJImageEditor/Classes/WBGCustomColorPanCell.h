//
//  WBGCustomColorPanCell.h
//  ZMJImageEditor
//
//  Created by LUOHUA_Think on 2018/2/24.
//

#import <UIKit/UIKit.h>

@interface WBGCustomColorPanCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIView *bigView;
@property (nonatomic, strong) IBOutlet UIView *smallView;
@property (nonatomic, strong) IBOutlet UIImageView *img;

- (void)setup;
- (void)updateUI:(BOOL)isShow isBlack:(BOOL)isBlack;

@end
