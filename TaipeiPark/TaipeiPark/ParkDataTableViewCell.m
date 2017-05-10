//
//  ParkDataTableViewCell.m
//  TaipeiPark
//
//  Created by Bill Chen on 2017/5/8.
//  Copyright © 2017年 home. All rights reserved.
//

#import "ParkDataTableViewCell.h"
#import "Utility.h"

@implementation ParkDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithData:(NSDictionary *)data {
    self.parkName.text = [data objectForKey:@"ParkName"];
    self.name.text = [data objectForKey:@"Name"];
    self.introduction.text = [data objectForKey:@"Introduction"];
    self.thumbnail.image = nil;

    NSURL *imageURL = [NSURL URLWithString:[data objectForKey:@"Image"]];

    __weak ParkDataTableViewCell *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *img = [UIImage imageWithData:imageData];

        UIImage *newImage = [Utility imageCompressWithSimple:img scaledToSize:weakSelf.thumbnail.bounds.size];

        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            weakSelf.thumbnail.image = newImage;
        });
    });
}

@end
