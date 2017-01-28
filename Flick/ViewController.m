//
//  ViewController.m
//  Flick
//
//  Created by  Santosh Sharanappa Mandi on 1/23/17.
//  Copyright © 2017  Santosh Sharanappa Mandi. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "FlickItem.h"
#import "CollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FlickDetailsViewController.h"
#import "SystemMessageView.h"
#import <MBProgressHUD.h>


@interface ViewController () <UITableViewDataSource, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (strong, nonatomic) NSArray<FlickItem *> *flicks;
@property (weak, nonatomic) IBOutlet UISegmentedControl *flickCollectionViewModes;
@property (weak, nonatomic) IBOutlet UICollectionView *flickCollectionView;
@property (weak, nonatomic) IBOutlet SystemMessageView *systemMessageView;
@property UIRefreshControl *refreshControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTableView.dataSource = self;
    self.flickCollectionView.dataSource = self;
    self.systemMessageView.hidden = true;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.movieTableView insertSubview:self.refreshControl atIndex:0];
    [self.flickCollectionView insertSubview:self.refreshControl atIndex:0];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];

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
    return self.flicks.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FlickItem *flickItem = [self.flicks objectAtIndex:indexPath.row];
    //NSLog(@"flick item=%@", flickItem);
    MovieCell* cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    [cell.overviewLabel sizeToFit];

    cell.titleLabel.text = flickItem.title;
    cell.overviewLabel.text = [self getSummary:flickItem.summary];
    [cell.posterImage setImageWithURL:flickItem.posterURL];
    return cell;
}

- (void) getFlicks {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *apiKey = @"bb27ab02b48c06816b3916849ce47f08";
    NSString *urlString =
    [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    
    
    NSString *restorationIdentifier = self.restorationIdentifier;
    NSString *topRatedRestorationIdentifier = @"TopRatedRestorationId";
    if([restorationIdentifier isEqualToString:topRatedRestorationIdentifier]){
        urlString = [@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:apiKey];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                NSInteger statusCode = [httpResponse statusCode];
                                                NSInteger success = 201;
                                                if (!error && statusCode == success) {
                                                    NSLog(@"No Error status = %ld", statusCode);
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    //NSLog(@"Response: %@", responseDictionary);
                                                    
                                                    NSArray *results = responseDictionary[@"results"];
                                                    NSMutableArray *flicks = [NSMutableArray array];
                                                    for (NSDictionary *result in results) {
                                                        FlickItem *flick = [[FlickItem alloc] initWithDictionary:result];
                                                        [flicks addObject: flick];
                                                    }
                                                    
                                                    self.flicks = flicks;
                                                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];

                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    self.systemMessageView.hidden = false;

                                                }
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                [self.refreshControl endRefreshing];

                                            }];
    [task resume];
}

- (void)viewWillAppear:(BOOL)animated {
    self.systemMessageView.hidden = true;

    [self getFlicks];
}

- (void) reload{
    float index = self.flickCollectionViewModes.selectedSegmentIndex;
    if(index==0) {
        [self.movieTableView reloadData];
    }
    if(index==1) {
        [self.flickCollectionView reloadData];
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlickItem *flickItem = [self.flicks objectAtIndex:indexPath.row];
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL: flickItem.posterURL];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.flicks.count;
}


- (NSString*) getSummary: (NSString*)longString{
    NSArray *listOfWords = [longString componentsSeparatedByString:@" "];
    NSString *str = @"";
    int counter = 0;
    for (NSString *word in listOfWords) {
        str = [str stringByAppendingString:word];
        str = [str stringByAppendingString:@" "];
        counter++;
        if(counter == 15){
            str = [str stringByAppendingString:@"..."];
            return str;
        }
    }
    return str;
}

- (IBAction)onValueChanged:(id)sender {
    float index = self.flickCollectionViewModes.selectedSegmentIndex;
    NSLog(@"flickCollectionViewModes onValueChange %f", index);
    self.systemMessageView.hidden = true;
    self.movieTableView.hidden = true;
    self.flickCollectionView.hidden = true;
    if(index==0) {
        self.movieTableView.hidden = false;
    }
    if(index==1) {
        self.flickCollectionView.hidden = false;
    }
    [self getFlicks];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue: %@", self.restorationIdentifier);
    if ([sender isKindOfClass:[MovieCell class]] ||
        [sender isKindOfClass:[CollectionViewCell class]]) {
        
        NSIndexPath *indexPath;
        float index = self.flickCollectionViewModes.selectedSegmentIndex;
        if(index==0) {
            MovieCell *cell = sender;
            indexPath = [self.movieTableView indexPathForCell:cell];
        }
        if(index==1) {
            CollectionViewCell *cell = sender;
            indexPath = [self.flickCollectionView indexPathForCell:cell];
        }
        
        FlickDetailsViewController *flickDetail = [segue destinationViewController];
        FlickItem *flickItem = [self.flicks objectAtIndex:indexPath.row];
        flickDetail.posterPath = flickItem.posterPath;
        flickDetail.flickDescription = flickItem.summary;
        flickDetail.flickTitle = flickItem.title;
    }
}


@end
