//
//  FlickDetailsViewController.h
//  Flick
//
//  Created by  Santosh Sharanappa Mandi on 1/27/17.
//  Copyright © 2017  Santosh Sharanappa Mandi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickDetailsViewController : UIViewController
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSString *flickDescription;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *flickTitle;

@property (weak, nonatomic) IBOutlet UIImageView *flickDetailImageView;
@property (weak, nonatomic) IBOutlet UILabel *flickDetailTitle;
@property (weak, nonatomic) IBOutlet UITextView *flickTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *flickScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *flickDetailScrollView;
@property (weak, nonatomic) IBOutlet UIView *flickDetailContentView;


@end
