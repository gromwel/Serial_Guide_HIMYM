//
//  SGEpisode.h
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGEpisode : NSObject

//описание серии
@property (nonatomic, strong) NSString * epDescription;
@property (nonatomic, strong) NSMutableAttributedString * epDescriptionAttributed;

//название эпизода
@property (nonatomic, strong) NSString * epName;
@property (nonatomic, strong) NSMutableAttributedString * epNameAttributed;

//назвние на английском
@property (nonatomic, strong) NSString * epNameEng;
@property (nonatomic, strong) NSAttributedString * epNameEngAttributed;

//номер эпизода
@property (nonatomic, strong) NSString * epNumber;

//рейтинг по imdb
@property (nonatomic, strong) NSString * epRating;

//дата выхода эпизода
@property (nonatomic, strong) NSString * epDate;

@end
