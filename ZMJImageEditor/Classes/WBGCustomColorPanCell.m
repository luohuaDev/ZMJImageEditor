//
//  WBGCustomColorPanCell.m
//  ZMJImageEditor
//
//  Created by LUOHUA_Think on 2018/2/24.
//

#import "WBGCustomColorPanCell.h"

@implementation WBGCustomColorPanCell

- (void)setup
{
    self.smallView.layer.cornerRadius = self.smallView.frame.size.width / 2.0;
    self.smallView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.smallView.layer.borderWidth = 1.0;
    self.smallView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.smallView.layer.shadowOpacity = 0.5f;
    self.smallView.layer.shadowRadius = 2.0;
    self.smallView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    self.bigView.layer.cornerRadius = self.bigView.frame.size.width / 2.0;
    self.bigView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bigView.layer.borderWidth = 1.5;
}

- (void)updateUI:(BOOL)isShow isBlack:(BOOL)isBlack
{
    NSString *imageName = isBlack ? @"Edit_color_picker_black" : @"Edit_color_picker_white";
    
    UIImage *image = [UIImage imageNamed:imageName];
                      
    [self.img setImage:image];
    
    self.img.hidden = !isShow;
}

@end
