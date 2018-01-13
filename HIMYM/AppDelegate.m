//
//  AppDelegate.m
//  HIMYM
//
//  Created by Clyde Barrow on 22.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SGSeasonTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//метод вызывается по нажатию 3д на иконку
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
    
    //отправляем нажатие на обработку
    completionHandler([self handleQuickAction:shortcutItem]);
}


//обработка нажатия
- (BOOL) handleQuickAction:(UIApplicationShortcutItem *)shortcutItem {
    //булевое значение по которому понимаем может ли быть обработано нажатие
    BOOL quickActionHandled = NO;
    
    //определяем тип кнопки нажатия
    NSString * type = [shortcutItem.type componentsSeparatedByString:@"."].lastObject;
    
    //берем навигейшн контролеер
    UINavigationController * navController = (UINavigationController *)self.window.rootViewController;
    
    //берем активный вью и убираем его (алерт контроллер)
    if ([[navController visibleViewController] isKindOfClass:[UIAlertController class]]) {
        [[navController visibleViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    //возвращаемся к самому первому вью
    [navController popToRootViewControllerAnimated:NO];
    ViewController * popController = (ViewController *)[navController.viewControllers objectAtIndex:0];
    
    //запуск первого экрана с активным серч баром
    if ([type isEqualToString:@"Search"]) {
        quickActionHandled = YES;
        //
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [popController.navigationItem.searchController.searchBar becomeFirstResponder];
        });
        //
        
    //запуск первого экрана и вызов рандомной серии
    } else if ([type isEqualToString:@"Random"]) {
        quickActionHandled = YES;
        //
        [popController showEpisode];
        //
    }
    return quickActionHandled;
}

@end
