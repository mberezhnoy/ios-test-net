//
//  PIPostTableCell.h
//  table-json
//
//  Created by Maxim Berezhnoy on 10.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PINetImageView.h"

@interface PIPostTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PINetImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *postContent;

@end
