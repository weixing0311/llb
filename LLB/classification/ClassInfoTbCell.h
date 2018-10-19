//
//  ClassInfoTbCell.h
//  LLB
//
//  Created by iOSdeveloper on 2018/10/17.
//  Copyright © 2018年 -call Me WeiXing. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassInfoTbCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UILabel *textlb;

@end

NS_ASSUME_NONNULL_END
