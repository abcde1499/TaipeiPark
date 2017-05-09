//
//  ParkDataTableViewCell.h
//  TaipeiPark
//
//  Created by Bill Chen on 2017/5/8.
//  Copyright © 2017年 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *parkName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@end
