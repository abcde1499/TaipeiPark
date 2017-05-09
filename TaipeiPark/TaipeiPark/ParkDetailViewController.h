//
//  ParkDetailViewController.h
//  TaipeiPark
//
//  Created by Bill Chen on 2017/5/9.
//  Copyright © 2017年 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *parkDetailData;
@property (strong, nonatomic) NSMutableArray *relatedParkData;

@end
