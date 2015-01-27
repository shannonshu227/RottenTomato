//
//  MovieDetailsViewController.m
//  RottenTomato
//
//  Created by Xiangnan Xu on 1/25/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PosterCell.h"
#import "InfoCell.h"
#import "SVProgressHUD.h"

@interface MovieDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *infoList;
@property (strong, nonatomic) NSArray *keyList;
@end

@implementation MovieDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.infoList = @[@"posters.original", @"title", @"mpaa_rating", @"release_dates.theater", @"synopsis", @"abridged_cast.name"];
        self.keyList = @[@"", @"Title", @"MPAA_Rating", @"Release Date", @"Synopsis", @"Actors"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *commentCellNib = [UINib nibWithNibName:@"InfoCell" bundle:nil];
    [self.tableView registerNib:commentCellNib forCellReuseIdentifier:@"InfoCellID"];
    
    UINib *imageCellNib = [UINib nibWithNibName:@"PosterCell" bundle:nil];
    [self.tableView registerNib:imageCellNib forCellReuseIdentifier:@"PosterCellID"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        PosterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosterCellID" forIndexPath:indexPath];
        NSString *origURL = [self.movie valueForKeyPath:self.infoList[indexPath.row]];
        origURL = [origURL stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
        [cell.posterView setImageWithURL: [NSURL URLWithString:origURL]];
//        [SVProgressHUD show];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            // time-consuming task
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:origURL]];
//            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//            
//            [cell.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                });
//            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                });
//            }];
//            
//        });
       
        return cell;
        
    } else {
        
        InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCellID" forIndexPath:indexPath];

        NSString *info;
        if(indexPath.row == 5) {
            NSArray *names = [self.movie valueForKeyPath:self.infoList[indexPath.row]];
            info = [[names valueForKey:@"description"] componentsJoinedByString:@", "];
        } else {
            info = [self.movie valueForKeyPath:self.infoList[indexPath.row]];
        }
        cell.infoLabel.text = [NSString stringWithFormat:@"%@:\n%@", self.keyList[indexPath.row], info];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0 ) {
        return 425;
    } else {
        return 109;
    }
}



@end
