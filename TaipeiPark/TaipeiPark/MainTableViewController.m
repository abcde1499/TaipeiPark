//
//  MainTableViewController.m
//  TaipeiPark
//
//  Created by Bill Chen on 2017/5/8.
//  Copyright © 2017年 home. All rights reserved.
//

#import "MainTableViewController.h"
#import "ParkDataTableViewCell.h"
#import "AFNetworking.h"
#import "ParkDetailViewController.h"
#import "Utility.h"

@interface MainTableViewController ()

@property (strong, nonatomic) NSMutableArray *parkDataArray;

@end

static NSString *const API_URL = @"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=bf073841-c734-49bf-a97f-3757a6013812";

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (IBAction)getParkDataButtonClicked:(UIBarButtonItem *)sender {
    NSLog(@"getParkDataButtonClicked");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *responseDict = responseObject;
                 /* do something with responseDict */
                 NSLog(@"isKindOfClass Dict: ");
                 //NSLog(@"RESULT: %@", [[responseObject objectForKey:@"result"] objectForKey:@"results"]);
                 //TODO: Memory Cycle?
                 self.parkDataArray = [[responseObject objectForKey:@"result"] objectForKey:@"results"];
                 [self.tableView reloadData];
             }
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             // TODO: show alert to ask for retry
         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parkDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.parkName.text = [self.parkDataArray[indexPath.row] objectForKey:@"ParkName"];
    cell.parkName.adjustsFontSizeToFitWidth = NO;
    cell.name.text = [self.parkDataArray[indexPath.row] objectForKey:@"Name"];
    //cell.name.adjustsFontSizeToFitWidth = YES;
    cell.introduction.text = [self.parkDataArray[indexPath.row] objectForKey:@"Introduction"];
    cell.thumbnail.image = nil;

    NSURL *imageURL = [NSURL URLWithString:[self.parkDataArray[indexPath.row] objectForKey:@"Image"]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *img = [UIImage imageWithData:imageData];

        UIImage *newImage = [Utility imageCompressWithSimple:img scaledToSize:cell.thumbnail.bounds.size];

        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            cell.thumbnail.image = newImage;
        });
    });

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showParkDetailSegue" sender:indexPath];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showParkDetailSegue"]) {
        //NSLog(@"showParkDetailSegue");
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        ParkDetailViewController *destVC = segue.destinationViewController;
        destVC.parkDetailData = self.parkDataArray[indexPath.row];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
