//
//  CustomCollectionViewFlowLayout.h
//  TextUICollectViewController
//
//  Created by huangshuni on 16/1/15.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewFlowLayout : UICollectionViewFlowLayout

-(instancetype)initWithColumn:(NSInteger)column Margin:(NSInteger)margin cellMinHeight:(CGFloat)cellMinHeight cellMaxHeight:(CGFloat)cellMaxHeight;
@end
