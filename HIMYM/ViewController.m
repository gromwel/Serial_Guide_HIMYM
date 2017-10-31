//
//  ViewController.m
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "ViewController.h"
#import "SGSeasonTableViewController.h"
#import "SGEpisode.h"
#import "SGSeason.h"
#import "EpisodeTableViewCell.h"
#import "SGHelpFunction.h"
#import "AppDelegate.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>


@property (nonatomic, strong) NSArray * arraySeasons;
@property (nonatomic, strong) NSArray * arrayEpisodesSearch;
@property (nonatomic, strong) NSArray * arrayEpisodesBySeason;
@property (nonatomic, assign) NSInteger list;


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //тайтл
    self.navigationItem.title = @"#HIMYM";
    //формирование массива сезонов
    self.arraySeasons = [[NSArray alloc] init];
    self.arraySeasons = [self createArraySeasons];
    //формирование массива серий по поиску
    self.arrayEpisodesSearch = [[NSArray alloc] init];
    [self sortedEpisodesWithFilter:self.searchBar.text IsDelite:NO];
    //решение о том что оттобразить, сезоны или серии
    if (!self.arrayEpisodesSearch) {
        self.list = SGListSeason;
    } else {
        self.list = SGListEpisodes;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
//по нажатию на ячейку
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //скрываем клавиатуру
    [self.searchBar resignFirstResponder];
    //отмена выделения
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.list == SGListSeason) {
        
        //запускаем новый контролеер с определенным сезоном
        SGSeasonTableViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Season"];
        controller.numberSeason = indexPath.row + 1;
        [self.navigationController pushViewController:controller animated:YES];
        //
        
        
    //переход в сезон если список серий найденных
    } else if (self.list == SGListSearchEpisodes) {
        
        SGSeason * season = [self.arrayEpisodesBySeason objectAtIndex:indexPath.section];
        SGEpisode * episode = [season.sortedEpisodes objectAtIndex:indexPath.row];
        NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"xх"];
        NSArray * arrayInfo = [episode.epNumber componentsSeparatedByCharactersInSet:set];
        NSInteger seas = [[arrayInfo objectAtIndex:0] intValue];
        NSInteger ep = [[arrayInfo objectAtIndex:1] intValue];
        
        SGSeasonTableViewController * seasonVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Season"];
        seasonVC.numberSeason = seas;
        seasonVC.numberEpisode = ep;
        
        [self.navigationController pushViewController:seasonVC animated:YES];
    }
}


#pragma mark - UITableViewDataSource
//добавляем тайтл сбоку для быстрого перехода
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //если отображение найденных эпизодов
    if (self.list == SGListEpisodes) {
        //собираем массив строк с сокращенным номером сезона
        NSMutableArray * titleArray = [[NSMutableArray alloc] init];
        for (SGSeason * season in self.arrayEpisodesBySeason) {
            NSString * title = [NSString stringWithFormat:@"s%@", season.seasoneNumber];
            [titleArray addObject:title];
        }
        return titleArray;
    }
    //если отображение сезонов то  тайтл с боку не показываем
    return nil;
}

//сколько секций в таблице
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //по умолчанию одна секция
    NSInteger section = 1;
    //если показываем найденные эпизоды, то секций столько сколько сезонов
    if (self.list == SGListEpisodes) {
        section = self.arrayEpisodesBySeason.count;
    }
    return section;
}

//футер к секциям
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    //по умолчанию футер пустой
    NSString * footer = @"";
    return footer;
}

//хедер к секциям
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //по умолчанию хедер пустой
    NSString * header = @"";
    //если показываем найденные эписоды  то хедер содержит номер сезона
    if (self.list == SGListEpisodes) {
        SGSeason * season = [self.arrayEpisodesBySeason objectAtIndex:section];
        header = [NSString stringWithFormat:@"Сезон %@", season.seasoneNumber];
    }
    return header;
}

//сколоко ячеек в каждой секции
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //по умолчанию 9 ячеек в таблице
    NSInteger rows = self.arraySeasons.count;
    //если показываем эпизоды то количество ячеек пересчитывается
    if (self.list == SGListEpisodes) {
        SGSeason * season = [self.arrayEpisodesBySeason objectAtIndex:section];
        rows = season.sortedEpisodes.count;
    }
    return rows;
}

//заполнение ячеек
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * identifier = nil;
    
    
    //таблица сезонов
    if (self.list == SGListSeason) {
        identifier = @"SeasonCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        //просто заполняем названиями сезонов
        cell.textLabel.text = [self.arraySeasons objectAtIndex:indexPath.row];
        return cell;
        
    //таблица эпизодов
    } else if (self.list == SGListEpisodes) {
        SGSeason * season = [self.arrayEpisodesBySeason objectAtIndex:indexPath.section];
        
        identifier = @"EpisodeCell";
        EpisodeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        SGEpisode * episode = [season.sortedEpisodes objectAtIndex:indexPath.row];
        
        cell.epName.text = [NSString stringWithFormat:@"«%@»", episode.epName];
        cell.epName.attributedText = episode.epNameAttributed;
        
        cell.epNameEng.text = [NSString stringWithFormat:@"«%@»", episode.epNameEng];
        cell.epNameEng.attributedText = episode.epNameEngAttributed;
        
        cell.epDescription.numberOfLines = 0;
        cell.epDescription.text = [NSString stringWithFormat:@"  %@", episode.epDescription];
        cell.epDescription.attributedText = episode.epDescriptionAttributed;
        
        cell.epNumber.text = episode.epNumber;
        //cell.userInteractionEnabled = NO;
        return cell;
    }
    return nil;
}

#pragma mark - UISearchBarDelegate
//начало редактирования
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

//завершение редактирования
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

//по нажатию на cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //опустошаем поле поиска еще раз ищем эпизоды, перезагружаем таблицу
    searchBar.text = @"";
    [self sortedEpisodesWithFilter:searchBar.text IsDelite:NO];
    [self.tableViewList reloadData];
    [searchBar resignFirstResponder];
}

//нажатие на "найти"
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

//заводим так что бы при нажатии на крест обнавлялась таблица
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //если пустая строка
    if (searchText.length == 0) {
        [self sortedEpisodesWithFilter:searchText IsDelite:NO];
        [self.tableViewList reloadData];
    }
    
}


//изменение текста
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString * resultString = [[NSString alloc] init];
    
    //определяем измененный текст
    if ([text isEqualToString:@"\n"]) {
        resultString = searchBar.text;
    } else {
        resultString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    }
    
    //если текст меньше исходного то отправяляем на поиск как удаление
    [self sortedEpisodesWithFilter:resultString IsDelite:(resultString.length < searchBar.text.length)];
    
    //перезагружаем таблицу
    [self.tableViewList reloadData];
    
    return YES;
}

#pragma mark - SortedEpisodes
//сортировка эпизодов по фильтру
- (void) sortedEpisodesWithFilter:(NSString*)filterString IsDelite:(BOOL)delite {
    //если фильтр есть то ищем эпизоды в общем списке эпизодов
    if (filterString.length > 0) {
        
        //ищем серии
        //если удаление символа то ищем по всем эпизодам
        if (delite) {
            self.arrayEpisodesSearch = nil;
            self.arrayEpisodesSearch = [SGHelpFunction searchEpisodeByString:filterString InSeason:0 OrEpisodes:self.arrayEpisodesSearch];
        
        //если не удаление то ищем по уже найденным сериям
        } else {
            self.arrayEpisodesSearch = [SGHelpFunction searchEpisodeByString:filterString InSeason:0 OrEpisodes:self.arrayEpisodesSearch];
        }

        
        //устанавливаем переменные
        self.arrayEpisodesBySeason = [self sortedEpisodesBySeason];
        self.list = SGListEpisodes;
        self.navigationItem.title = [NSString stringWithFormat:@"%li эпизода", self.arrayEpisodesSearch.count];
        
        
        //если фильтра нет то устанавливаем список сезонов
    } else {
        self.arrayEpisodesSearch = nil;
        self.list = SGListSeason;
        self.navigationItem.title = @"#HIMYM";
    }
    
    NSLog(@"%li", self.arrayEpisodesSearch.count);
}


//возвращаем массив эпизодов со всех сезонов по порядку
- (NSArray*) createArrayEpisodes {
    NSMutableArray * arraySeries = [[NSMutableArray alloc] init];
    //берем каждый сезон
    for (int i = 1; i < 10; i++) {
        SGSeason * season = [SGSeason seasonWithNumber:i];
        //каждую серию в сезоне
        for (int i = 0; i < season.episodes.count; i++) {
            SGEpisode * episode = [season.episodes objectAtIndex:i];
            [arraySeries addObject:episode];
        }
    }
    return arraySeries;
}

//создаем массив названий сезонов
- (NSArray*) createArraySeasons {
    NSArray * array = [[NSArray alloc] initWithObjects:@"Сезон 1 (2005-2006)", @"Сезон 2 (2006-2007)", @"Сезон 3 (2007-2008)", @"Сезон 4 (2008-2009)",
       @"Сезон 5 (2009-2010)", @"Сезон 6 (2010-2011)", @"Сезон 7 (2011-2012)",@"Сезон 8 (2012-2013)",
                               @"Сезон 9 (2013-2014)", nil];
    return array;
}

//возвращаем массив сезонов внутри которых массив эпизодов
- (NSArray*) sortedEpisodesBySeason {
    //создаем массив сортированных эпизодов по сезонам
    NSMutableArray * sortedArray = [[NSMutableArray alloc] init];
    //текущий сезон
    NSString * currentSeason = nil;
    //для каждого эпизода из общего массива
    for (SGEpisode * episode in self.arrayEpisodesSearch) {
        //берем номер сезона этого эпизода
        NSString * numberSeason = [episode.epNumber substringWithRange:NSMakeRange(0, 1)];
        //если номер сезона эпизода такой же как номер текущего эпизода
        //значит массив сезона есть, добавляем туда серию
        if ([numberSeason isEqualToString:currentSeason]) {
            SGSeason * season = [sortedArray lastObject];
            [season.sortedEpisodes addObject:episode];
            
        //иначе создаем массив нового сезона и добавляем туда эпизод
        //сезон кладем в общий массив
        } else {
            SGSeason * season = [[SGSeason alloc] init];
            season.seasoneNumber = numberSeason;
            season.sortedEpisodes = [[NSMutableArray alloc] init];
            [season.sortedEpisodes addObject:episode];
            [sortedArray addObject:season];
            currentSeason = numberSeason;
        }
    }
    return sortedArray;
}


#pragma mark - ShakeGesture
//жест шейк
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //если жест шейк
    if(event.type == UIEventSubtypeMotionShake)
    {
        [self showEpisode];
    }
}


//алерт
- (void) showEpisode {
    //закрываем клавиатуру если она закрыта
    if (self.searchBar.isFirstResponder) {
        [self.view endEditing:YES];
    }
    
    
    //рандомный эпизод
    SGEpisode * episode = [SGHelpFunction showRandomEpisodeWithSeason:0];
    
    //получаем алерт c изображением эпизода и описанием
    UIAlertController * alert = [SGHelpFunction showAlertWithEpisode:episode];
    
    //добавляем кнопку перехода к сезону
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"Перейти к сезону"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         //переход к сезону
                                                         SGSeasonTableViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Season"];
                                                         NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"xх"];
                                                         NSArray * arrayDetail = [episode.epNumber componentsSeparatedByCharactersInSet:set];
                                                         NSString * numberSeason = [arrayDetail objectAtIndex:0];
                                                         NSString * numberEpisode = [arrayDetail objectAtIndex:1];
                                                         NSInteger season = [numberSeason intValue];
                                                         NSInteger episode = [numberEpisode intValue];
                                                         controller.numberSeason = season;
                                                         controller.numberEpisode = episode;
                                                         [self.navigationController pushViewController:controller animated:YES];
                                                     }];
    [alert addAction:action1];
    
    //добавление кнопки другая серия
    UIAlertAction * actionOk = [UIAlertAction actionWithTitle:@"Другая"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self showEpisode];
                                                     }];
    
    //добавление кнопки закрыть
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"Закрыть"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    
    [alert addAction:actionOk];
    [alert addAction:actionCancel];
    
    
    //показываем алерт
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //код который выполнится по появлению алерта
                     }];
}


@end
