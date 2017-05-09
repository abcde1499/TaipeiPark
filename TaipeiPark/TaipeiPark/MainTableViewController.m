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

@interface MainTableViewController ()

@property (strong, nonatomic) NSMutableArray *parkDataArray;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
- (IBAction)getParkDataButtonClicked:(UIBarButtonItem *)sender {
    NSLog(@"getParkDataButtonClicked");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=bf073841-c734-49bf-a97f-3757a6013812"
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

        // Create a graphics image context
        UIGraphicsBeginImageContext(cell.thumbnail.bounds.size);
        // Tell the old image to draw in this new context, with the desired
        // new size
        [img drawInRect:CGRectMake(0,0, cell.thumbnail.bounds.size.width, cell.thumbnail.bounds.size.height)];
        // Get the new image from the context
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        // End the context
        UIGraphicsEndImageContext();

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


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
