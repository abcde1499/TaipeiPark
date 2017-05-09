//
//  ParkDetailViewController.m
//  TaipeiPark
//
//  Created by Bill Chen on 2017/5/9.
//  Copyright © 2017年 home. All rights reserved.
//

#import "ParkDetailViewController.h"
#import "Utility.h"

@interface ParkDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *parkImage;
@property (weak, nonatomic) IBOutlet UILabel *parkName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *openTime;
@property (weak, nonatomic) IBOutlet UITextView *introduction;

@end

@implementation ParkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSURL *imageURL = [NSURL URLWithString:[self.parkDetailData objectForKey:@"Image"]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *img = [UIImage imageWithData:imageData];

        UIImage *newImage = [Utility imageCompressWithSimple:img scaledToSize:self.parkImage.bounds.size];

        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.parkImage.image = newImage;
        });
    });

    self.parkName.text = [self.parkDetailData objectForKey:@"ParkName"];
    self.name.text = [self.parkDetailData objectForKey:@"Name"];
    self.openTime.text = [self.parkDetailData objectForKey:@"OpenTime"];
    self.introduction.text = [self.parkDetailData objectForKey:@"Introduction"];
}

- (void)viewDidLayoutSubviews {
    [self.introduction setContentOffset:CGPointZero animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
