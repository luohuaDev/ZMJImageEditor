//
//  WBGMoreKeyboard+CollectionView.m
//  WBGKeyboards
//
//  Created by Jason on 2016/10/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "WBGMoreKeyboard+CollectionView.h"
#import "WBGMoreKeyboardCell.h"
#import <Masonry/Masonry.h>
#import "YYCategories.h"

#define     WIDTH_CELL       40

@implementation WBGMoreKeyboard (CollectionView)

- (void)registerCellClass
{
    [self.collectionView registerClass:[WBGMoreKeyboardCell class] forCellWithReuseIdentifier:@"WBGMoreKeyboardCell"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.chatMoreKeyboardData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBGMoreKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WBGMoreKeyboardCell" forIndexPath:indexPath];
    
    [cell setItem:[self.chatMoreKeyboardData objectAtIndex:indexPath.row]];
    
    __weak typeof(self) weakSelf = self;
    [cell setClickBlock:^(WBGMoreKeyboardItem *sItem) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(moreKeyboard:didSelectedFunctionItem:)]) {
            [weakSelf.delegate moreKeyboard:weakSelf didSelectedFunctionItem:sItem];
        }
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_CELL, WIDTH_CELL);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0, 10.0, 0.0, 10.0);
}

@end
