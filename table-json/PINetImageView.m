//
//  PINetImageView.m
//  table-json
//
//  Created by Maxim Berezhnoy on 11.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PINetImageView.h"

@implementation PINetImageView
@synthesize imgUrl = _imgUrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    self.image = nil;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: _imgUrl]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self.image = [UIImage imageWithData: data];
        });
    });
    
}


@end
