//
//  WBGMoreKeyboard.m
//  WBGKeyboards
//
//  Created by Jason on 2016/10/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "WBGMoreKeyboard.h"
#import "WBGMoreKeyboard+CollectionView.h"
#import "WBGChatMacros.h"
#import "UIColor+TLChat.h"
#import <Masonry/Masonry.h>
#import "YYCategories.h"

@implementation WBGMoreKeyboard

+ (WBGMoreKeyboard *)keyboard
{
    static WBGMoreKeyboard *moreKB = nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        moreKB = [[WBGMoreKeyboard alloc] init];
    });
    
    return moreKB;
}

- (id)init
{
    if(self = [super init])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.collectionView];
        
        [self p_addMasonry];
        
        [self registerCellClass];
    }
    
    return self;
}

- (CGFloat)keyboardHeight
{
    CGFloat temp = 433.0 / 667.0;
    CGFloat height = temp * [[UIScreen mainScreen] bounds].size.height;
    return height;
}

#pragma mark - # Public Methods
- (void)setChatMoreKeyboardData:(NSMutableArray *)chatMoreKeyboardData
{
    _chatMoreKeyboardData = chatMoreKeyboardData;
    
    [self.collectionView reloadData];
}

- (void)reset
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.width, self.collectionView.height) animated:NO];
}

#pragma mark - # Event Response
- (void)pageControlChanged:(UIPageControl *)pageControl
{
    [self.collectionView scrollRectToVisible:CGRectMake(self.collectionView.width * pageControl.currentPage, 0, self.collectionView.width, self.collectionView.height) animated:YES];
}

#pragma mark - Private Methods -
- (void)p_addMasonry
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, WIDTH_SCREEN, 0);
    CGContextStrokePath(context);
}

#pragma mark - # Getter
- (UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setPagingEnabled:NO];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
    }
    
    return _collectionView;
}

@end
