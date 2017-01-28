//
//  FlickItem.h
//  Flick
//
//  Created by  Santosh Sharanappa Mandi on 1/24/17.
//  Copyright © 2017  Santosh Sharanappa Mandi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickItem : NSObject
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *flickId;
@property (nonatomic, strong) NSString *posterPath;
- (instancetype) initWithDictionary: (NSDictionary *) jsonDictionary;
//- (NSString*) getDescription;
@end
