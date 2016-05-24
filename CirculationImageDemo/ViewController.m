//
//  ViewController.m
//  CirculationImageDemo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSArray *_imagesArray;
    NSInteger _currentImageIndex; //当前图片索引
    NSInteger _leftImageIndex;
    NSInteger _rightImageIndex;
    UIPageControl *_pageControl;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagesArray = @[@"0.jpg", @"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg", @"8.jpg"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    //添加分页控件
    [self addPageControl];
    
    _leftImageIndex = _imagesArray.count - 1;
    _currentImageIndex = 0;
    // 当只有两张图片时，左右页都显示最后一张的图片，防止崩溃
    _rightImageIndex = _imagesArray.count == 2 ? _leftImageIndex : _currentImageIndex + 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.collectionView.frame), 0) animated:NO];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 添加分页控件
-(void)addPageControl{
    _pageControl=[[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size = [_pageControl sizeForNumberOfPages:_imagesArray.count];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(kScreenSize.width / 2, kScreenSize.height - 50);
    //设置颜色
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _pageControl.numberOfPages = _imagesArray.count;
    
    [self.view addSubview:_pageControl];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imagesArray.count > 1 ? 3 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    @try {
        UIImage *image;
        if (indexPath.row == 0) {
            image = [UIImage imageNamed:_imagesArray[_leftImageIndex]];
        } else if (indexPath.row == 1) {
            image = [UIImage imageNamed:_imagesArray[_currentImageIndex]];
        } else if (indexPath.row == 2) {
            image = [UIImage imageNamed:_imagesArray[_rightImageIndex]];
        }
        cell.imageView.image = image;
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(_collectionView.frame), CGRectGetHeight(_collectionView.frame));
}

#pragma mark 滚动停止事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.collectionView.frame), 0) animated:NO];
    
    [_collectionView reloadData];
    
    //设置分页
    _pageControl.currentPage = _currentImageIndex;
    //设置描述
//    NSString *imageName = [NSString stringWithFormat:@"%li.jpg",(long)_currentImageIndex];
//    _label.text=_imageData[imageName];
}

#pragma mark 重新加载图片
- (void)reloadImage {
    NSInteger imageCount = _imagesArray.count;
    CGPoint offset = [_collectionView contentOffset];
    CGFloat scrollRangeWidth = CGRectGetWidth(self.collectionView.frame);
    
    if (offset.x > scrollRangeWidth) { //向右滑动
        _currentImageIndex = (_currentImageIndex + 1) % imageCount;
    } else if(offset.x < scrollRangeWidth) { //向左滑动
        _currentImageIndex = (_currentImageIndex + imageCount - 1) % imageCount;
    }
    
//    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%li.jpg",(long)_currentImageIndex]];
    
    //重新设置左右图片
    _leftImageIndex = (_currentImageIndex + imageCount - 1) % imageCount;
    _rightImageIndex = (_currentImageIndex + 1) % imageCount;
    
//    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",leftImageIndex]];
//    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",rightImageIndex]];
}

@end
