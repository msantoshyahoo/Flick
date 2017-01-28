//
//  FlickItem.m
//  Flick
//
//  Created by  Santosh Sharanappa Mandi on 1/24/17.
//  Copyright © 2017  Santosh Sharanappa Mandi. All rights reserved.
//

#import "FlickItem.h"

@implementation FlickItem

- (instancetype) initWithDictionary: (NSDictionary *) jsonDictionary{
    self = [super init];
    if(self){
        self.title = jsonDictionary[@"original_title"];
        self.summary = jsonDictionary[@"overview"];
        self.flickId = ((NSNumber*)jsonDictionary[@"id"]).stringValue;
        NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", jsonDictionary[@"poster_path"]];
        //NSLog(@">>>image urlString: %@", urlString);
        self.posterURL = [NSURL URLWithString:urlString];
        self.posterPath = jsonDictionary[@"poster_path"];
    }
    return self;
}
@end
