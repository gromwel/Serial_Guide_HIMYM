//
//  NSMutableAttributedString+Select.h
//  HIMYM
//
//  Created by Clyde Barrow on 29.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Select)

- (void) colorSelectTextWithRange:(NSRange)selectRange;

@end
