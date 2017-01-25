//
//  ViewController.m
//  Flick
//
//  Created by  Santosh Sharanappa Mandi on 1/23/17.
//  Copyright © 2017  Santosh Sharanappa Mandi. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTableView.dataSource = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // num of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell* cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    [cell.titleLabel setText:[NSString stringWithFormat:@"Title - %ld", indexPath.row]];
    [cell.posterImage setImage:[UIImage imageNamed:@"spotlight-yo-yahoo.jpg"]];
    [cell.overviewLabel setText:[NSString stringWithFormat:@"Overview - %ld", indexPath.row]];
    return cell;
}

@end
