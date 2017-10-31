//
//  SGSeasonTableViewController.m
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "SGSeasonTableViewController.h"
#import "EpisodeTableViewCell.h"
#import "ImageTableViewCell.h"
#import "SGSeason.h"
#import "SGEpisode.h"
#import "SGHelpFunction.h"
#import "ViewController.h"


@interface SGSeasonTableViewController () <UISearchBarDelegate>


@property (nonatomic, strong) SGSeason * season;
@property (nonatomic, strong) NSArray * arrayEpisodesSearch;
@property (nonatomic, assign) NSInteger list;


@end


@implementation SGSeasonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //создание массива
    self.arrayEpisodesSearch = [[NSArray alloc] init];
    
    //загрузка тайтла
    self.navigationItem.title = [NSString stringWithFormat:@"Сезон %li", self.numberSeason];
    //заполнение сериями сезона
    self.season = [SGSeason seasonWithNumber:self.numberSeason];
}


- (void)viewDidAppear:(BOOL)animated {
    
    //переход к эпизоду если он указан
    if (self.numberEpisode) {
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.numberEpisode+1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:path
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
        [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
//нажатие на ячейку
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //скрытие клавиатуры
    [self.searchBar resignFirstResponder];
    //отмена выделения
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      
}

//расчет высоты ячейки
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //отпределяем границы текста, ширина не более 344
    CGSize constraintSize = CGSizeMake(344.0f, CGFLOAT_MAX);
    UIFont * font = [UIFont systemFontOfSize:13.0f];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    //первая ячейка всегда изображение
    if (indexPath.row == 0) {
        return 136.f;
        
    //вторая ячейка в зависимости от таблицы
    } else if (indexPath.row == 1) {
        if (self.list == SGListSearchEpisodes) {
            //размер ячейки серии
            SGEpisode * episode = [self.arrayEpisodesSearch objectAtIndex:indexPath.row - 1];
            CGRect frameEpisode = [episode.epDescription boundingRectWithSize:constraintSize
                                                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                   attributes:dict
                                                                      context:nil];
            return frameEpisode.size.height + 68.f;
        }
        
        //размер ячейки описания
        CGRect frameDescription = [self.season.seasonDescription boundingRectWithSize:constraintSize
                                                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                           attributes:dict
                                                                              context:nil];
        return frameDescription.size.height + 10;
        
    } else {
        if (self.list == SGListSearchEpisodes) {
            //размер ячейки серии
            SGEpisode * episode = [self.arrayEpisodesSearch objectAtIndex:indexPath.row - 1];
            CGRect frameEpisode = [episode.epDescription boundingRectWithSize:constraintSize
                                                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                   attributes:dict
                                                                      context:nil];
            return frameEpisode.size.height + 68.f;
        }
        
        //размер ячейки серии
        SGEpisode * episode = [self.season.episodes objectAtIndex:indexPath.row - 2];
        CGRect frameEpisode = [episode.epDescription boundingRectWithSize:constraintSize
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                               attributes:dict
                                                                  context:nil];
        return frameEpisode.size.height + 68.f;
        
    }
    return 0.f;
}



#pragma mark - UITableViewDataSource
//сколько ячеек в секции
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * episodes = self.season.episodes;
    NSInteger rows = episodes.count + 2;
    if (self.list == SGListSearchEpisodes) {
        rows = self.arrayEpisodesSearch.count + 1;
    }
    return rows;
}

//заполнение таблицы
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * iCell = @"ImageCell";
    NSString * dCell = @"DescriptionCell";
    NSString * eCell = @"EpisodeCell";
    
    
    
    
    //если загрузка всех эпизодов
    if (self.list == SGListAllEpisodes) {
       //первая ячейка картинка
        if (indexPath.row == 0) {
            ImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iCell];
            cell.imageSeason.image = [UIImage imageNamed:[NSString stringWithFormat:@"season%li.jpg", self.numberSeason]];
            return cell;
            
        //вторая ячейка описание сезона
        } else if (indexPath.row == 1) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dCell];
            cell.textLabel.text = [NSString stringWithFormat:@"  %@", self.season.seasonDescription];
            cell.textLabel.numberOfLines = 0;
            cell.userInteractionEnabled = NO;
            return cell;
            
        //далее серии
        } else {
            EpisodeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:eCell];
            SGEpisode * episode = [self.season.episodes objectAtIndex:indexPath.row - 2];
            cell.epName.text = [NSString stringWithFormat:@"«%@»", episode.epName];
            cell.epNameEng.text = [NSString stringWithFormat:@"«%@»", episode.epNameEng];
            cell.epDescription.numberOfLines = 0;
            cell.epDescription.text = [NSString stringWithFormat:@"  %@", episode.epDescription];
            cell.epNumber.text = episode.epNumber;
            //cell.userInteractionEnabled = NO;
            return cell;
        }
    
    //загрузка только найденных эпизодов
    } else {
        
        //картинка
        if (indexPath.row == 0) {
            ImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iCell];
            cell.imageSeason.image = [UIImage imageNamed:[NSString stringWithFormat:@"season%li.jpg", self.numberSeason]];
            return cell;
            
        //серии
        } else {
            EpisodeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:eCell];
            SGEpisode * episode = [self.arrayEpisodesSearch objectAtIndex:indexPath.row - 1];
            
            cell.epName.text = [NSString stringWithFormat:@"«%@»", episode.epName];
            cell.epName.attributedText = episode.epNameAttributed;
            
            cell.epNameEng.text = [NSString stringWithFormat:@"«%@»", episode.epNameEng];
            cell.epNameEng.attributedText = episode.epNameEngAttributed;
            
            cell.epDescription.numberOfLines = 0;
            cell.epDescription.text = [NSString stringWithFormat:@"  %@", episode.epDescription];
            cell.epDescription.attributedText = episode.epDescriptionAttributed;
            
            cell.epNumber.text = episode.epNumber;
            cell.userInteractionEnabled = NO;
            return cell;
        }
    }
    
    return nil;
}


#pragma mark - UISearchBarDelegate
//начало редактирования текста
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

//завершение редактирования текста
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}


//нажатие на кансел
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //обнуляем строку и перезагружаем таблицу
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self sortedEpisodesWithFilter:@"" IsDelite:NO];
    [self.tableView reloadData];
}

//по нажатию на далее
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


//изменение текста
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString * resultString = [[NSString alloc] init];
    
    //берем финальную строку
    if ([text isEqualToString:@"\n"]) {
        resultString = searchBar.text;
    } else {
        resultString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    };
    
    //если текст меньше исходного то отправляем на поиск как удаление
    [self sortedEpisodesWithFilter:resultString IsDelite:(resultString.length < searchBar.text.length)];
    
    //перезагружаем таблицу
    [self.tableView reloadData];
    
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //если пустая строка
    if (searchText.length == 0) {
        [self sortedEpisodesWithFilter:searchText IsDelite:NO];
        [self.tableView reloadData];
    }
}



#pragma mark - SortedEpisodes
//сортировка эпизодов по фильтру
- (void) sortedEpisodesWithFilter:(NSString*)filterString IsDelite:(BOOL)delite {
    //если поисковая строка не пустая то показываем серии по поиску
    if (filterString.length > 0) {
        
        //ищем серии
        //если удаление символа то ищем по всем эпизодам
        if (delite) {
            self.arrayEpisodesSearch = nil;
            self.arrayEpisodesSearch = [SGHelpFunction searchEpisodeByString:filterString InSeason:self.numberSeason OrEpisodes:self.arrayEpisodesSearch];
            
        //если не удаление то ищем по найденным сериям
        } else {
            self.arrayEpisodesSearch = [SGHelpFunction searchEpisodeByString:filterString InSeason:self.numberSeason OrEpisodes:self.arrayEpisodesSearch];
        }
        
        //self.arraySearchEpisodes = arrayFilerSeries;
        self.list = SGListSearchEpisodes;
        self.navigationItem.title = [NSString stringWithFormat:@"Сезон %li - %li серии", self.numberSeason, self.arrayEpisodesSearch.count];
        
    //иначе все серии сезона
    } else {
        self.list = SGListAllEpisodes;
        self.navigationItem.title = [NSString stringWithFormat:@"Сезон %li", self.numberSeason];
    }
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
    SGEpisode * episode = [SGHelpFunction showRandomEpisodeWithSeason:self.numberSeason];
    
    //получаем алерт
    UIAlertController * alert = [SGHelpFunction showAlertWithEpisode:episode];
    
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
