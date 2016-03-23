//
//  MyCollectionViewController.m
//  TextUICollectViewController
//
//  Created by huangshuni on 16/1/15.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "CustomCollectionViewFlowLayout.h"

@interface MyCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,assign)NSInteger column;
@property (nonatomic,assign)NSInteger margin;
@property (nonatomic,assign)NSInteger cellMinHeight;
@property (nonatomic,assign)NSInteger cellMaxHeight;

@end

@implementation MyCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


-(instancetype)initWithColumn:(NSInteger)column Margin:(NSInteger)margin cellMinHeight:(CGFloat)cellMinHeight cellMaxHeight:(CGFloat)cellMaxHeight
{
    if (self = [super init]) {
        
        self.column = column;
        self.margin = margin;
        self.cellMinHeight = cellMinHeight;
        self.cellMaxHeight = cellMaxHeight;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0 , 100, 100);
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
  }

-(void)backAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 500;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%d.jpg",arc4random()%8+1];
    
    cell.CellImageView.image = [UIImage imageNamed:imageName];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    UICollectionViewTransitionLayout *transition = [[UICollectionViewTransitionLayout alloc]initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transition;
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


#pragma mark === setter / getter 
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CustomCollectionViewFlowLayout *flowlayout = [[CustomCollectionViewFlowLayout alloc]initWithColumn:self.column Margin:self.margin cellMinHeight:self.cellMinHeight cellMaxHeight:self.cellMaxHeight];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

@end
