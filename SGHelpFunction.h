//
//  SGHelpFunction.h
//  HIMYM
//
//  Created by Clyde Barrow on 24.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SGSeason.h"
#import "SGEpisode.h"
#import "NSMutableAttributedString+Select.h"

@interface SGHelpFunction : NSObject

+ (SGEpisode *) showRandomEpisodeWithSeason:(NSInteger)seasonNumber;
+ (UIAlertController *) showAlertWithEpisode:(SGEpisode *)episode;


+ (NSArray *) searchEpisodeByString:(NSString *)searchString InSeason:(NSInteger)seasonNumber OrEpisodes:(NSArray *)episodes;
@end
