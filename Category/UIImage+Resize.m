//
//  UIImage+Resize.m
//  HIMYM
//
//  Created by Clyde Barrow on 24.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *) imageWithSize:(CGSize)size { //принимаем размер конечного изображения
    //высчитываем аргумент уменьшения размера изображения
    //для этого делим размер итогового изображения на размер начального изображения
    CGFloat aspectWidth = size.width / self.size.width;
    CGFloat aspectHeight = size.height / self.size.height;
    
    //берем меньший аргумент за общий
    CGFloat aspectRatio = MIN(aspectWidth, aspectHeight);
    
    //новый рект измененного изображения
    CGRect scaledImageRect = CGRectZero;
    
    //высчитываем стороны изображения
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    
    //высчитываем точку установки изображения (убираем погрешность)
    scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
    scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
    
    //
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    //вписываем изображение в рект
    [self drawInRect:scaledImageRect];
    
    //
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //возвращаем уменьшенное изображение
    return scaledImage;
}

@end
