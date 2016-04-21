//
//  CollectionCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ivAuntPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbAge;
@property (strong, nonatomic) IBOutlet UILabel *lbHometown;
@property (strong, nonatomic) IBOutlet UILabel *lbServerCount;

-(void)setXj:(int)xj;
@end
