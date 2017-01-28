//
//  MovieCell.h
//  Flick
//
//  Created by  Santosh Sharanappa Mandi on 1/23/17.
//  Copyright © 2017  Santosh Sharanappa Mandi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewLabel;

@end
