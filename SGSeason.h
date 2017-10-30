//
//  SGSeason.h
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGEpisode.h"

@interface SGSeason : NSObject
//эпизоды сезона
@property (nonatomic, strong) NSArray * episodes;
//описание сезона
@property (nonatomic, strong) NSString * seasonDescription;
//номер сезона
@property (nonatomic, strong) NSString * seasoneNumber;
//отсортированные серии сезона
@property (nonatomic, strong) NSMutableArray * sortedEpisodes;

//возвращаем сезон по номеру
+ (SGSeason *) seasonWithNumber:(NSInteger)season;

@end
