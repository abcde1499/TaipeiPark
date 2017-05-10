//
//  RelatedParkCollectionViewCell.m
//  TaipeiPark
//
//  Created by Bill Chen on 2017/5/9.
//  Copyright © 2017年 home. All rights reserved.
//

#import "RelatedParkCollectionViewCell.h"
#import "Utility.h"

@implementation RelatedParkCollectionViewCell


- (void)configureWithData:(NSDictionary *)data {
    NSURL *imageURL = [NSURL URLWithString:[data objectForKey:@"Image"]];

    __weak RelatedParkCollectionViewCell *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *img = [UIImage imageWithData:imageData];

        UIImage *newImage = [Utility imageCompressWithSimple:img scaledToSize:weakSelf.relatedParkImageView.bounds.size];

        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            weakSelf.relatedParkImageView.image = newImage;
        });
    });

    self.relatedParkName.text = [data objectForKey:@"Name"];
}


@end
