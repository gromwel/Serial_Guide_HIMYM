//
//  NSMutableAttributedString+Select.m
//  HIMYM
//
//  Created by Clyde Barrow on 29.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "NSMutableAttributedString+Select.h"

@implementation NSMutableAttributedString (Select)


- (void) colorSelectTextWithRange:(NSRange)selectRange {
    
    UIColor * foregroundColor = [UIColor blueColor];
    //UIColor * backgroundColor = [UIColor colorWithWhite:0.77f alpha:0.5];
    UIColor * backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:0.f alpha:1.f];
    
    [self addAttribute:NSForegroundColorAttributeName
                       value:foregroundColor
                       range:selectRange];
    [self addAttribute:NSBackgroundColorAttributeName
                       value:backgroundColor
                       range:selectRange];
}


@end
