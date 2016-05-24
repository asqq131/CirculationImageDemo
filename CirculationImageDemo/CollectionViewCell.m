//
//  CollectionViewCell.m
//  CirculationImageDemo
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
    }
    
    return self;
}

@end
