//
//  UIAlertController+Image.m
//  HIMYM
//
//  Created by Clyde Barrow on 24.10.2017.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "UIAlertController+Image.h"
#import "UIImage+Resize.h"

@implementation UIAlertController (Image)

- (void) addImage:(UIImage *)image {
    //определение максимального размера изображения и оригинального размера
    CGFloat widthMaxImage = self.view.frame.size.width - 44;
    CGSize maxSize = CGSizeMake(widthMaxImage, widthMaxImage / 2.67);
    //CGSize maxSize = CGSizeMake(331, 124);
    NSLog(@"%f %f", self.view.frame.size.height, self.view.frame.size.width);
    
    CGSize imgSize = image.size;
    
    //считаем соотношение
    CGFloat ratio;
    //если картинка горизонтальная
    if (imgSize.width > imgSize.height) {
        ratio = maxSize.width / imgSize.width;
        //если вертикальная
    } else {
        ratio = maxSize.height / imgSize.height;
    }
    
    //размер уменьшенной картинки по расчетам
    CGSize scaledSize = CGSizeMake(imgSize.width * ratio, imgSize.height * ratio);
    //картинка нового размера по размерам
    UIImage * resizedImage = [image imageWithSize:scaledSize];
    
    //определение сдвига по x (установка изображения в центр)
    //переопределяем итоговое изображение
    //изображение вертикальное
    if (imgSize.height > imgSize.width) {
        //считаем разницу между максимально возможным и которое есть
        //на половину разницы сдвигаем
        CGFloat left = (maxSize.width - resizedImage.size.width) / 2;
        resizedImage = [resizedImage imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, -left, 0, 0)];
    }
    
    //новый экшн (кнопка)
    UIAlertAction * imageAction = [UIAlertAction actionWithTitle:@""
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    imageAction.enabled = NO; //не активна
    
    //установка в экшн изображения
    [imageAction setValue:[resizedImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forKey:@"image"];
    
    //добавление алерту экшена
    [self addAction:imageAction];
}

@end
