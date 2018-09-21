//
//  ClassInfoCollectionViewCell.h
//  LLB
//
//  Created by iOSdeveloper on 2018/9/18.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "ClassInofoModel.h"
@interface ClassInfoCollectionViewCell : BaseCollectionCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;

@end
