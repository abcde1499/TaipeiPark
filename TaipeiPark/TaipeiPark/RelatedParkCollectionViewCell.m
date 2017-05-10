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
    self.relatedParkName.text = [data objectForKey:@"Name"];
    self.relatedParkImageView.image = nil;
    self.tag = [[data objectForKey:@"_id"] integerValue];

    NSURL *imageURL = [NSURL URLWithString:[data objectForKey:@"Image"]];

    __weak RelatedParkCollectionViewCell *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *img = [UIImage imageWithData:imageData];

        UIImage *newImage = [Utility imageCompressWithSimple:img scaledToSize:weakSelf.relatedParkImageView.bounds.size];

        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            if(weakSelf.tag == [[data objectForKey:@"_id"] integerValue]) {
                weakSelf.relatedParkImageView.image = newImage;
            }
        });
    });

}


@end
