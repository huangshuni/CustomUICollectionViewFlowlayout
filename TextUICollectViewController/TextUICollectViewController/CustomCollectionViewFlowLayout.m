//
//  CustomCollectionViewFlowLayout.m
//  TextUICollectViewController
//
//  Created by huangshuni on 16/1/15.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface CustomCollectionViewFlowLayout ()

//section的数量
@property (nonatomic) NSInteger numberOfSections;

//section中Cell的数量
@property (nonatomic) NSInteger numberOfCellsInSections;

//瀑布流的行数
@property (nonatomic) NSInteger columnCount;

//cell边距
@property (nonatomic) NSInteger padding;

//cell的最小高度
@property (nonatomic) NSInteger cellMinHeight;

//cell的最大高度，最大高度比最小高度小，以最小高度为准
@property (nonatomic) NSInteger cellMaxHeight;

//cell的宽度
@property (nonatomic) CGFloat cellWidth;

//存储每列Cell的X坐标
@property (strong, nonatomic) NSMutableArray *cellXArray;

//存储每个cell的随机高度，避免每次加载的随机高度都不同
@property (strong, nonatomic) NSMutableArray *cellHeightArray;

//记录每列Cell的最新Cell的Y坐标
@property (strong, nonatomic) NSMutableArray *cellYArray;


@end


@implementation CustomCollectionViewFlowLayout

//    _columnCount = 5;//瀑布流的行数
//    _padding = 2;//cell的边距
//    _cellMinHeight = 50;//cell最小的高度
//    _cellMaxHeight = 200;//cell最大的高度

-(instancetype)initWithColumn:(NSInteger)column Margin:(NSInteger)margin cellMinHeight:(CGFloat)cellMinHeight cellMaxHeight:(CGFloat)cellMaxHeight
{
    if (self = [super init]) {
        _columnCount = column;
        _padding = margin;
        _cellMinHeight = cellMinHeight;
        _cellMaxHeight = cellMaxHeight;
    }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    //初始化数据
    _numberOfSections = [self.collectionView numberOfSections];//多少组
    _numberOfCellsInSections = [self.collectionView numberOfItemsInSection:0];//每组多少个cell
    
    //计算出每个cell的宽度
    _cellWidth = (SCREEN_WIDTH - (_columnCount - 1)*_padding)/_columnCount;
    
    //为每个cell计算x坐标
    _cellXArray = [NSMutableArray arrayWithCapacity:_columnCount];
    for (int i = 0; i<_columnCount; i++) {
        CGFloat tempX = i * (_cellWidth + _padding);
        [_cellXArray addObject:@(tempX)];
    }
    
    //随机生成cell的高度
    _cellHeightArray = [NSMutableArray arrayWithCapacity:_numberOfCellsInSections];
    for (int i = 0; i<_numberOfCellsInSections; i++) {
        CGFloat cellHeight = arc4random() % (_cellMaxHeight - _cellMinHeight) + _cellMinHeight;// (0~150 + 50)=(50~200)
        [_cellHeightArray addObject:@(cellHeight)];
    }
    
}

#pragma mark == CollectionView // contentSize大小
//Cell的Y轴坐标数组的最大值，因为在Cell都加载完毕后，Cell数组中最大值就是CollectionView的ContentSize的Height的值
//在刚进来的时候会走一次，，为每个可见cell重新赋值frame之后又会走一次
-(CGSize)collectionViewContentSize
{
    CGFloat height = [self maxCellYArrayWithArray:_cellYArray];
    return CGSizeMake(SCREEN_WIDTH, height);
}

#pragma mark === 求cellY中的最大值并返回
-(CGFloat)maxCellYArrayWithArray:(NSMutableArray *)arr
{
    if (arr.count == 0) {
        return 0.0f;
    }
    
    CGFloat max = [arr[0] floatValue];
    for (NSNumber *num in arr) {
        
        CGFloat temp = [num floatValue];
        if (max < temp) {
            max = temp;
        }
    }
    return max;
}

#pragma mark === 为每一个cell加一个layout属性
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    [self initCellYArray];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i<_numberOfCellsInSections; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [array addObject:attribute];
    }
    return array;
}

#warning mark === the most important --- 通过给每个cell的frame重新赋值来改变cell的坐标 ---
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame = CGRectZero;
    CGFloat cellHeight = [_cellHeightArray[indexPath.row] floatValue];//cell的高度
    
    NSInteger minYIndex = [self minCellYArrayWithArray:_cellYArray];//cellY最小值的索引
    CGFloat tempX = [_cellXArray[minYIndex] floatValue];//x坐标
    CGFloat tempY = [_cellYArray[minYIndex] floatValue];//y坐标
    
    frame = CGRectMake(tempX, tempY, _cellWidth, cellHeight);//通过哪列最新的Y最大坐标，判断哪列的cell最短，就在哪列加一个cell

    //修改列里面的Y坐标
    _cellYArray[minYIndex] = @(tempY + cellHeight + _padding);
    
    attribute.frame = frame;

    
    return attribute;
}

#pragma mark === 求cellY数组中最小值的索引
-(NSInteger)minCellYArrayWithArray:(NSMutableArray *)array
{
    if (array.count == 0) {
        return 0.0f;
    }
    
    NSInteger minIndex = 0;
    CGFloat min = [array[0] floatValue];
    
    for (int i = 0; i<array.count; i++) {
        CGFloat temp = [array[i] floatValue];
        if (min > temp) {
            min = temp;
            minIndex = i;
        }
    }
    
    return minIndex;
}

#pragma mark === 初始化每列cell的Y坐标
-(void)initCellYArray
{
    _cellYArray = [[NSMutableArray alloc]initWithCapacity:_columnCount];
    for (int i = 0; i<_columnCount; i++) {
        [_cellYArray addObject:@(0)];
    }
}

@end
