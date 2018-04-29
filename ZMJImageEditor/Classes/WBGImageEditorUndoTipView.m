//
//  WBGImageEditorUndoTipView.m
//  ZMJImageEditor
//
//  Created by LUOHUA_Think on 2018/4/25.
//

#import "WBGImageEditorUndoTipView.h"
#import "Masonry.h"
#import "UIcolor+JKHEX.h"

@interface WBGImageEditorUndoTipView ()

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIButton *abandonBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation WBGImageEditorUndoTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self addSubview:self.backGroundView];
    
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.tipLab];
    [self.whiteView addSubview:self.abandonBtn];
    [self.whiteView addSubview:self.cancelBtn];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView).offset(17.0);
        make.leading.equalTo(self.whiteView).offset(37.0);
        make.trailing.equalTo(self.whiteView).offset(-37.0);
        make.bottom.equalTo(self.abandonBtn.mas_top).offset(-20.0);
    }];
    
    [self.abandonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@183.0);
        make.height.equalTo(@44.0);
        make.leading.equalTo(self.whiteView).offset(48.0);
        make.trailing.equalTo(self.whiteView).offset(-48.0);
        make.top.equalTo(self.tipLab.mas_bottom).offset(20.0);
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-2.0);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@183.0);
        make.height.equalTo(@44.0);
        make.leading.equalTo(self.whiteView).offset(48.0);
        make.trailing.equalTo(self.whiteView).offset(-48.0);
        make.top.equalTo(self.abandonBtn.mas_bottom).offset(2.0);
        make.bottom.equalTo(self.whiteView);
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(self.tipLab.mas_top).offset(17.0);
        make.leading.equalTo(self.abandonBtn.mas_leading).offset(48.0);
        make.trailing.equalTo(self.abandonBtn.mas_trailing).offset(48.0);
        make.bottom.equalTo(self.cancelBtn.mas_bottom);
    }];
}

- (UIView *)backGroundView
{
    if(_backGroundView == nil)
    {
        _backGroundView = [[UIView alloc] init];
        
        _backGroundView.backgroundColor = [UIColor jk_colorWithHex:0x000000 andAlpha:0.5];
    }
    
    return _backGroundView;
}

- (UIView *)whiteView
{
    if(_whiteView == nil)
    {
        _whiteView = [[UIView alloc] init];
        
        _whiteView.backgroundColor = [UIColor whiteColor];
        
        _whiteView.layer.cornerRadius = 7.5;
    }
    
    return _whiteView;
}

- (UILabel *)tipLab
{
    if(_tipLab == nil)
    {
        _tipLab = [[UILabel alloc] init];
        
        _tipLab.text = @"Are you sure you want to abandon?";
        _tipLab.font = [UIFont systemFontOfSize:18.0];
        _tipLab.textColor = [UIColor blackColor];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.numberOfLines = 0;
    }
    
    return _tipLab;
}

- (UIButton *)abandonBtn
{
    if(_abandonBtn == nil)
    {
        _abandonBtn = [[UIButton alloc] init];
        
        _abandonBtn.layer.cornerRadius = 11.0;
        _abandonBtn.backgroundColor = [UIColor jk_colorWithHex:0x0DADFF];
        [_abandonBtn setTitle:@"Abandon" forState:UIControlStateNormal];
        [_abandonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_abandonBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_abandonBtn addTarget:self action:@selector(onClickAbandonBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _abandonBtn;
}

- (UIButton *)cancelBtn
{
    if(_cancelBtn == nil)
    {
        _cancelBtn = [[UIButton alloc] init];
        
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor jk_colorWithHex:0x0DADFF] forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_cancelBtn addTarget:self action:@selector(onClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelBtn;
}

- (void)onClickAbandonBtn
{
    if(self.clickBlock)
    {
        self.clickBlock(YES, self);
    }
}

- (void)onClickCancelBtn
{
    if(self.clickBlock)
    {
        self.clickBlock(NO, self);
    }
}

@end
