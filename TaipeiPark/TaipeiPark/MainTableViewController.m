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
#import "SVProgressHUD.h"
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

    self.parkDataArray = [NSMutableArray array];
}

- (IBAction)getParkDataButtonClicked:(UIBarButtonItem *)sender {
    NSLog(@"getParkDataButtonClicked");
    __weak MainTableViewController *weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    [manager GET:API_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             [SVProgressHUD dismiss];
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *responseDict = responseObject;
                 NSArray *resultsArray = [[responseDict objectForKey:@"result"] objectForKey:@"results"];

                 // Sort reulstsArray by ParkName
                 NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"ParkName" ascending:YES];
                 resultsArray = [resultsArray sortedArrayUsingDescriptors:@[sd1]];

                 NSMutableArray *tmpArray = [NSMutableArray array];

                 for(int i = 0; i < resultsArray.count; i++) {
                     if (i > 0) {
                         if ([[resultsArray[i] objectForKey:@"ParkName"] isEqualToString: [resultsArray[i-1] objectForKey:@"ParkName"]]) {
                             [tmpArray addObject:resultsArray[i]];
                         }
                         else {
                             [weakSelf.parkDataArray addObject:[NSArray arrayWithArray:tmpArray]];
                             [tmpArray removeAllObjects];
                             [tmpArray addObject:resultsArray[i]];
                         }
                     }
                     else {
                         [tmpArray addObject:resultsArray[i]];
                     }
                 }

                 [weakSelf.tableView reloadData];
             }
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [SVProgressHUD dismiss];
             NSLog(@"Error: %@", error);
             // TODO: show alert to ask for retry
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"伺服器錯誤" message:@"請重新取得一次" preferredStyle:  UIAlertControllerStyleAlert];

             [alert addAction:[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil ]];

             [weakSelf presentViewController:alert animated:true completion:nil];
         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.parkDataArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.parkDataArray[section][0] objectForKey:@"ParkName"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *data = self.parkDataArray[section];
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkCell" forIndexPath:indexPath];

    [cell configureWithData:self.parkDataArray[indexPath.section][indexPath.row]];

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
        destVC.parkDetailData = self.parkDataArray[indexPath.section][indexPath.row];
        destVC.relatedParkData = self.parkDataArray[indexPath.section];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
