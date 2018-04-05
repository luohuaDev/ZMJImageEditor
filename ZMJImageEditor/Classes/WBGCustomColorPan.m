//
//  WBGCustomColorPan.m
//  ZMJImageEditor
//
//  Created by LUOHUA_Think on 2018/2/24.
//

#import "WBGCustomColorPan.h"
#import "WBGCustomColorPanCell.h"
#import "Masonry.h"

@interface WBGCustomColorPan () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *colorArray;

@end

@implementation WBGCustomColorPan

- (void)initAll
{
    self.currentColor = [self colorWithHex:0xffffff alpha:1.0];
    
    self.selectIndex = 0;
    
    self.colorArray = [[NSMutableArray alloc] init];
    [self setUpColorArray];
    
    [self.contentView registerNib:[UINib nibWithNibName:@"WBGCustomColorPanCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"WBGCustomColorPanCell"];
}

- (void)setUpColorArray
{
    [self.colorArray removeAllObjects];
    
    [self.colorArray addObject:[self colorWithHex:0xffffff alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x000000 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x3897f0 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x70c050 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xfdcb5c alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xfd8d32 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xed4956 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xd10869 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xa307ba alpha:1.0]];
    
    [self.colorArray addObject:[self colorWithHex:0xed0013 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xed858e alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xffd2d3 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xffdbb4 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xffc382 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xd28f46 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x996439 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x5d4242 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x1c4a29 alpha:1.0]];
    
    [self.colorArray addObject:[self colorWithHex:0x262626 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x363636 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x555555 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x737373 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0x999999 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xb2b2b2 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xc7c7c7 alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xdbdbdb alpha:1.0]];
    [self.colorArray addObject:[self colorWithHex:0xefefef alpha:1.0]];
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 27;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat h = 368.0;
    
    return (h - 9 * 32.0) / 9.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBGCustomColorPanCell *cell = [self.contentView dequeueReusableCellWithReuseIdentifier:@"WBGCustomColorPanCell" forIndexPath:indexPath];
    
    [cell setup];
    
    cell.smallView.backgroundColor = [self.colorArray objectAtIndex:indexPath.row];
    cell.smallView.hidden = self.selectIndex == indexPath.row ? YES : NO;
    
    cell.bigView.backgroundColor = [self.colorArray objectAtIndex:indexPath.row];
    cell.bigView.hidden = self.selectIndex == indexPath.row ? NO : YES;
    
    BOOL isShow = self.selectIndex == indexPath.row;
    BOOL isBlack = self.selectIndex == 0;
    
    [cell updateUI:isShow isBlack:isBlack];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    
    self.currentColor = [self.colorArray objectAtIndex:indexPath.row];
    
    [self.contentView reloadData];
}

- (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGFloat y = offset.y;
    [self updateupdatePageControlUI:y];
}

- (void)updateupdatePageControlUI:(CGFloat)y
{
    NSInteger index = 0;
    if(y == 0)
    {
        index = 0;
    }
    if(y == 368)
    {
        index = 1;
    }
    if(y == 727)
    {
        index = 2;
    }
    
    NSArray *points = [[NSArray alloc] initWithObjects:self.point0, self.point1, self.point2, nil];
    
    for(int i = 0; i < 3; i++)
    {
        UIView *point = [points objectAtIndex:i];
        
        UIColor *color = [self colorWithHex:0xd8d8d8 alpha:1.0];
        
        if(i == index)
        {
            color = [self colorWithHex:0xffffff alpha:1.0];
        }
        
        [point setBackgroundColor:color];
    }
}

@end
