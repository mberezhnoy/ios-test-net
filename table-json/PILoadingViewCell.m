//
//  PILoadingViewCell.m
//  table-json
//
//  Created by Maxim Berezhnoy on 16.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PILoadingViewCell.h"
#import "PINetImageView.h"

@implementation PILoadingViewCell

-(void)animatimate
{
    if( !_loadingIm.animationImages )
    {
        _loadingIm.image = nil;
        _loadingIm.animationImages = [PINetImageView getLoadingFrames];
        _loadingIm.animationDuration = 1;
    }
    [_loadingIm startAnimating];
}

@end
