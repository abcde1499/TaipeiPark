//
//  ParkDetailViewController.m
//  TaipeiPark
//
//  Created by Bill Chen on 2017/5/9.
//  Copyright © 2017年 home. All rights reserved.
//

#import "ParkDetailViewController.h"
#import "Utility.h"
#import "RelatedParkCollectionViewCell.h"

@interface ParkDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *parkImage;
@property (weak, nonatomic) IBOutlet UILabel *parkName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *openTime;
@property (weak, nonatomic) IBOutlet UITextView *introduction;
@property (weak, nonatomic) IBOutlet UICollectionView *relatedParkCollectionView;

@property (strong, nonatomic) NSMutableArray *copiedRelatedParkData;

@end

static NSString *cellID = @"RelatedParkCollectionViewCell";

@implementation ParkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.copiedRelatedParkData = [[NSMutableArray alloc] initWithArray:self.relatedParkData];

    for (int i = 0; i < self.relatedParkData.count; i++) {
        if (self.relatedParkData[i] == self.parkDetailData) {
            //NSLog(@"Removing Object: %d", i);
            [self.copiedRelatedParkData removeObjectAtIndex:i];
        }
    }

    self.relatedParkCollectionView.delegate = self;
    self.relatedParkCollectionView.dataSource = self;

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

    self.title = [self.parkDetailData objectForKey:@"ParkName"];
}

- (void)viewDidLayoutSubviews {
    [self.introduction setContentOffset:CGPointZero animated:NO];
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.copiedRelatedParkData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    RelatedParkCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    // Configure the cell
    NSURL *imageURL = [NSURL URLWithString:[self.copiedRelatedParkData[indexPath.row] objectForKey:@"Image"]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *img = [UIImage imageWithData:imageData];

        UIImage *newImage = [Utility imageCompressWithSimple:img scaledToSize:cell.relatedParkImageView.bounds.size];

        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            cell.relatedParkImageView.image = newImage;
        });
    });

    cell.relatedParkName.text = [self.copiedRelatedParkData[indexPath.row] objectForKey:@"Name"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.relatedParkCollectionView performBatchUpdates:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
