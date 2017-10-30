//
//  ImageTableViewCell.h
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString * image;
@property (weak, nonatomic) IBOutlet UIImageView *imageSeason;

@end
