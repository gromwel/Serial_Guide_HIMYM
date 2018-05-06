//
//  SGHelpFunction.m
//  HIMYM
//
//  Created by Clyde Barrow on 24.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "SGHelpFunction.h"
#import "UIAlertController+Image.h"
#import "SGSeasonTableViewController.h"
#import "NSMutableAttributedString+Select.h"

@implementation SGHelpFunction

//рандомная серия
+ (SGEpisode *) showRandomEpisodeWithSeason:(NSInteger)seasonNumber {
    
    //определяем сезон если он не задан
    if (seasonNumber == 0) {
        seasonNumber = (arc4random() % 900 + 100) / 100;
    }
    SGSeason * season = [SGSeason seasonWithNumber:seasonNumber];
    
    //определяем серию
    NSInteger episodeNumber = arc4random() % season.episodes.count;
    SGEpisode * episode = [season.episodes objectAtIndex:episodeNumber];
    
    return episode;
}

//алерт рандомной серии
+ (UIAlertController *) showAlertWithEpisode:(SGEpisode *)episode {
    //стиль алерта
    UIAlertControllerStyle controllerStyle = UIAlertControllerStyleActionSheet;
    
    //создаем алерт
    NSString * rate = episode.epRating;
    NSString * date = episode.epDate;
    
    
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"xх"];
    NSArray * array = [episode.epNumber componentsSeparatedByCharactersInSet:set];
    NSString * epNumber = [NSString stringWithFormat:@"S%@, Ep%@", [array objectAtIndex:0], [array objectAtIndex:1]];
    NSString * title = [NSString stringWithFormat:@"%@\n«%@»\n«%@»", epNumber, episode.epName, episode.epNameEng];
    NSString * description = [NSString stringWithFormat:@"%@\n\nДата выхода: %@\nРейтинг: %@/10",  episode.epDescription, date, rate];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:description
                                                             preferredStyle:controllerStyle];
    
    //добавляем экшн с иображением
    //определим какое изображение передать
    NSString * numberSeason = [episode.epNumber substringWithRange: NSMakeRange(0, 1)];
    NSString * imageSeason = [NSString stringWithFormat:@"season%@.jpg", numberSeason];
    [alert addImage:[UIImage imageNamed:imageSeason]];

    
    return alert;
}

//сортировка эпизодов по фильтру
+ (NSArray *) searchEpisodeByString:(NSString *)searchString InSeason:(NSInteger)seasonNumber OrEpisodes:(NSArray *)episodes {
    
    //создаем массив всех серий
    NSArray * arrayAllEpisodes; // = [[NSArray alloc] init];
    
    //если массив переданных эпизодов не пустой, то берем его
    if (episodes.count != 0) {
        arrayAllEpisodes = [[NSArray alloc] initWithArray:episodes];
        
    //иначе берем его из сезона
    } else {
        arrayAllEpisodes = [self createArrayAllEpisodesWithSeason:seasonNumber];
    }
    
    //создаем массив найденных в методе серий из массива всех/найденных ранее серий
    NSMutableArray * arrayAllFiteredEpisodes = [[NSMutableArray alloc] initWithArray:arrayAllEpisodes];
    
    //инициализируем атрибуты
    for (SGEpisode * ep in arrayAllFiteredEpisodes) {
        ep.epNameAttributed = [[NSMutableAttributedString alloc] initWithString:ep.epName];
        ep.epNameEngAttributed = [[NSMutableAttributedString alloc] initWithString:ep.epNameEng];
        ep.epDescriptionAttributed = [[NSMutableAttributedString alloc] initWithString:ep.epDescription];
    }
    
    
    //парсим поисковую строку
    NSCharacterSet * parsingSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSArray * searchStrings = [searchString componentsSeparatedByCharactersInSet:parsingSet];
    
    
    //берем поисковое слово
    for (NSString * search in searchStrings) {
        
        //если поисковое слово не пустое
        if (search.length > 0) {
            
            //создаем массив серий в которых ищем из всех/найденных
            NSArray * arrayEp = [[NSArray alloc] initWithArray:arrayAllFiteredEpisodes];
        
            //обнуляем массив всех/найденных
            [arrayAllFiteredEpisodes removeAllObjects];
        
        
            //берем по очереди серии для поиска
            for (SGEpisode * episode in arrayEp) {
                //проверяем эпизод на вхождение слова
                BOOL epAdd = [self checkEpisode:episode ForString:search];
            
                //если есть строка в серии добавляем в найденные
                if (epAdd) {
                    [arrayAllFiteredEpisodes addObject:episode];
                }
            }
        }
    }
    
    return arrayAllFiteredEpisodes;
}



//поиск эпизода
+ (BOOL) checkEpisode:(SGEpisode *)episode ForString:(NSString *)search {
    BOOL isYES = NO;
    
    //создаем массив текстов эпизода
    NSArray * arrayEpisodeTexts = @[episode.epName, episode.epNameEng, episode.epDescription];
    
    
    //создаем массив атрибутов эпизода
    NSArray * arrayEpisodeAttributes = @[episode.epNameAttributed, episode.epNameEngAttributed, episode.epDescriptionAttributed];
    
    //для каждого текста из эпизода
    for (int i = 0; i < arrayEpisodeTexts.count; i++) {
        
        NSString * text = [arrayEpisodeTexts objectAtIndex:i];
        
        //ищем совпадение в тексте
        NSRange range = [text rangeOfString:search options:NSCaseInsensitiveSearch];
        //если нашли
        if (range.location != NSNotFound) {
            
            isYES = YES;
            //отправляем текст на поиск всех входжений и добавления аттрибутов
            [self searchAllEntrySearchString:search
                                      InText:text
                                   FromRange:NSMakeRange(0, 0)
                                  Attributed:[arrayEpisodeAttributes objectAtIndex:i]];
         
        //если совпадения нет
        }
    }
    
    return isYES;
}


//поиск всех вхождений слова
+ (void) searchAllEntrySearchString:(NSString *)search InText:(NSString *)string FromRange:(NSRange)range Attributed:(NSMutableAttributedString *)attributed {
    
    //вычисление range для поиска
    NSRange receiverRange = NSMakeRange(range.location + range.length, string.length - range.location - range.length);
    
    //range найденного слова
    NSRange searchRange = [string rangeOfString:search
                                        options:NSCaseInsensitiveSearch
                                          range:receiverRange];
    
    //если слово найдено
    if (searchRange.location != NSNotFound) {
        
        //добавление атрибута
        [attributed colorSelectTextWithRange:searchRange];
        
        //поиск еще раз
        [self searchAllEntrySearchString:search
                                  InText:string
                               FromRange:searchRange
                              Attributed:attributed];
    }
    //если не найдено - выход
}


//создание массива серий по номеру сезона
+ (NSArray *) createArrayAllEpisodesWithSeason:(NSInteger)number {
    NSMutableArray * arrayEpisodes = [[NSMutableArray alloc] init];
    
    //если пришел ноль, ищем во всем сезоне
    if (number == 0) {
        for (int i = 1; i < 10; i++) {
            SGSeason * season = [SGSeason seasonWithNumber:i];
            [arrayEpisodes addObjectsFromArray:season.episodes];
        }
        
    //иначе в конкретном
    } else {
        SGSeason * season = [SGSeason seasonWithNumber:number];
        [arrayEpisodes addObjectsFromArray:season.episodes];
    }
    return arrayEpisodes;
}



@end
