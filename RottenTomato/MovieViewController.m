//
//  MovieViewController.m
//  RottenTomato
//
//  Created by Xiangnan Xu on 1/20/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailsViewController.h"
#import "SVProgressHUD.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dyctekewh8hgxyjg44c26saa"];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // time-consuming task
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSDictionary *responseDict = [ NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSLog(@"%@", responseDict);
            self.movies = responseDict[@"movies"];
            [self.tableView reloadData];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
        
    });
    
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 128;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCellID"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCellID"];
    
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    //NSLog(@"%@", [movie valueForKeyPath:@"posters.thumbnail"]);
    [cell.posterView setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
/*
 - (void)show {
 [SVProgressHUD show];
 }
 
 static float progress = 0.0f;
 
 - (IBAction)showWithProgress:(id)sender {
 progress = 0.0f;
 [SVProgressHUD showProgress:0 status:@"Loading"];
 [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
 }
 
 - (void)increaseProgress {
 progress+=0.1f;
 [SVProgressHUD showProgress:progress status:@"Loading"];
 
 if(progress < 1.0f)
 [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
 else
 [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];
 }
 
 
 - (void)dismiss {
 [SVProgressHUD dismiss];
 }
 */


@end
