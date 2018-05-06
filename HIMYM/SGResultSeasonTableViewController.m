//
//  SGResultSeasonTableViewController.m
//  HIMYM
//
//  Created by Clyde Barrow on 10.01.2018.
//  Copyright © 2018 Clyde Barrow. All rights reserved.
//

#import "SGResultSeasonTableViewController.h"
#import "SGSeasonTableViewController.h"
#import "EpisodeTableViewCell.h"
#import "ImageTableViewCell.h"
#import "SGSeason.h"
#import "SGEpisode.h"
#import "SGHelpFunction.h"
#import "ViewController.h"




@interface SGResultSeasonTableViewController ()

@end

@implementation SGResultSeasonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searching == serialSearching) {
        return self.arrayEpisodesSearch.count;
    }
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searching == serialSearching) {
        SGSeason * season = [self.arrayEpisodesSearch objectAtIndex:section];
        return season.sortedEpisodes.count;
    }
    
    return self.arrayEpisodesSearch.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searching == serialSearching) {
        SGSeason * season = [self.arrayEpisodesSearch objectAtIndex:section];
        return [NSString stringWithFormat:@"Сезон %@", season.seasoneNumber];
    }
    
    return nil;
}


//заполнение таблицы
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.searchBar resignFirstResponder];
    
    static NSString * identifier = @"EpisodeCell";
    
    
    
    if (self.searching == serialSearching) {
        EpisodeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        SGSeason * season = [self.arrayEpisodesSearch objectAtIndex:indexPath.section];
        SGEpisode * episode = [season.sortedEpisodes objectAtIndex:indexPath.row];
        
        cell.epName.text = [NSString stringWithFormat:@"«%@»", episode.epName];
        cell.epName.attributedText = episode.epNameAttributed;
        
        cell.epNameEng.text = [NSString stringWithFormat:@"«%@»", episode.epNameEng];
        cell.epNameEng.attributedText = episode.epNameEngAttributed;
        
        cell.epDescription.numberOfLines = 0;
        cell.epDescription.text = [NSString stringWithFormat:@"  %@", episode.epDescription];
        cell.epDescription.attributedText = episode.epDescriptionAttributed;
        
        cell.epNumber.text = episode.epNumber;
        return cell;
    }
    
    EpisodeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    SGEpisode * episode = [self.arrayEpisodesSearch objectAtIndex:indexPath.row];
    
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    } else {
        [self showEpisodeWithIndexPath:indexPath];
    }
}


//алерт
- (void) showEpisodeWithIndexPath:(NSIndexPath *)indexPath {
    //закрываем клавиатуру если она закрыта
    if (self.navigationItem.searchController.searchBar.isFirstResponder) {
        [self.view endEditing:YES];
    }
    
    //берем серию
    SGEpisode * episode= nil;
    
    if (self.searching == serialSearching) {
        SGSeason * season = [self.arrayEpisodesSearch objectAtIndex:indexPath.section];
        episode = [season.sortedEpisodes objectAtIndex:indexPath.row];
    } else {
        episode = [self.arrayEpisodesSearch objectAtIndex:indexPath.row];
    }
    
    
    //получаем алерт
    UIAlertController * alert = [SGHelpFunction showAlertWithEpisode:episode];
    
    
    //создаем path с которым будем работать
    __block NSIndexPath * path = indexPath;
    
    //добавление кнопки следующей серия
    UIAlertAction * actionNextSeries = [UIAlertAction actionWithTitle:@"Следующая серия"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                                  if (self.searching == serialSearching) {
                                                                      
                                                                      NSInteger section = indexPath.section;
                                                                      NSInteger row = indexPath.row;
                                                                      
                                                                      SGSeason * season = [self.arrayEpisodesSearch objectAtIndex:indexPath.section];
                                                                      if (row == (season.sortedEpisodes.count - 1)) {
                                                                          section = section + 1;
                                                                          row = 0;
                                                                      } else {
                                                                          row = row + 1;
                                                                      }
                                                                      
                                                                      path = [NSIndexPath indexPathForRow:row inSection:section];
                                                                      
                                                                      [self showEpisodeWithIndexPath:path];
                                                                      [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                                      
                                                                  } else {
                                                                  
                                                                      path = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
                                                                      
                                                                      [self showEpisodeWithIndexPath:path];
                                                                      [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
                                                                  }
                                                      }];
    
    //добавление кнопки предудущей серия
    UIAlertAction * actionEarlySeries = [UIAlertAction actionWithTitle:@"Предыдущая серия"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   
                                                                   if (self.searching == serialSearching) {
                                                                       
                                                                       NSInteger secttion = indexPath.section;
                                                                       NSInteger row = indexPath.row;
                                                                       if (indexPath.row == 0) {
                                                                           SGSeason * season = [self.arrayEpisodesSearch objectAtIndex:indexPath.section - 1];
                                                                           
                                                                           secttion = secttion - 1;
                                                                           row = season.sortedEpisodes.count - 1;
                                                                           
                                                                       } else {
                                                                           row = row - 1;
                                                                       }
                                                                       
                                                                       path = [NSIndexPath indexPathForRow:row inSection:secttion];
                                                                       
                                                                       [self showEpisodeWithIndexPath:path];
                                                                       [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                                       
                                                                   } else {
                                                                       
                                                                       path = [NSIndexPath indexPathForRow:indexPath.row - 1  inSection:indexPath.section];
                                                                       
                                                                       [self showEpisodeWithIndexPath:path];
                                                                       [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
                                                                   }
                                                        }];
    
    //добавление кнопки закрыть
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"Закрыть"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //[self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                  [self.tableView deselectRowAtIndexPath:path animated:YES];
                                                              });
                                                          }];
    
    
    if (self.searching == serialSearching) {
        SGSeason * firstSeason = [self.arrayEpisodesSearch firstObject];
        if (![episode isEqual:[firstSeason.sortedEpisodes firstObject]]) {
            [alert addAction:actionEarlySeries];
        }
        
        SGSeason * lastSeason = [self.arrayEpisodesSearch lastObject];
        if (![episode isEqual:[lastSeason.sortedEpisodes lastObject]]) {
            [alert addAction:actionNextSeries];
        }
    } else {
        if (![episode isEqual:[self.arrayEpisodesSearch firstObject]]) {
            [alert addAction:actionEarlySeries];
        }
        
        if (![episode isEqual:[self.arrayEpisodesSearch lastObject]]) {
            [alert addAction:actionNextSeries];
        }
    }
    
    
    
    [alert addAction:actionCancel];
    
    
    //показываем алерт
    [self presentViewController:alert
                       animated:YES
                     completion:^{
                         //код который выполнится по появлению алерта
                         [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                     }];
}

@end
