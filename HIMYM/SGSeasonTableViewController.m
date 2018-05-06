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
#import "SGResultSeasonTableViewController.h"


@interface SGSeasonTableViewController () <UISearchBarDelegate, UISearchResultsUpdating>


@property (nonatomic, strong) SGSeason * season;
@property (nonatomic, strong) NSArray * arrayEpisodesSearch;
@property (nonatomic, assign) NSInteger list;

@property (nonatomic, strong) SGResultSeasonTableViewController * resultController;


@end


@implementation SGSeasonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*______________*/
    /*              */
    /*______________*/
    self.definesPresentationContext = YES;
    
    //создание резалт контроллера
    self.resultController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    
    
    //создание и настройка серч контроллера
    UISearchController * search = [[UISearchController alloc] initWithSearchResultsController:self.resultController];
    search.searchBar.placeholder = @"Поиск по сериям сезона";
    search.searchBar.delegate = self;
    search.searchResultsUpdater = self;
    
    //настройка резалт контроллера
    self.resultController.searchBar = search.searchBar;
    self.resultController.numberSeason = self.numberSeason;
    self.resultController.searching = seasonSearching;
    
    self.navigationItem.searchController = search;
    /*______________*/
    /*              */
    /*______________*/
    
    
    //создание массива
    self.arrayEpisodesSearch = [[NSArray alloc] init];
    
    //загрузка тайтла
    self.navigationItem.title = [NSString stringWithFormat:@"Сезон %li", self.numberSeason];
    //заполнение сериями сезона
    self.season = [SGSeason seasonWithNumber:self.numberSeason];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
        self.resultController.arrayEpisodesSearch = self.arrayEpisodesSearch;
        [self.resultController.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    [self.navigationItem.searchController.searchBar resignFirstResponder];
    //отмена выделения
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (self.navigationItem.searchController.searchBar.isFirstResponder) {
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
