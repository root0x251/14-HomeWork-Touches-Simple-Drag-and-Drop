//
//  ViewController.m
//  14-HomeWork-Touches-Simple-Drag-and-Drop
//
//  Created by Slava on 14.04.17.
//  Copyright © 2017 Slava. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // создаем большое поле
    UIView *bigBlackRect = [UIView new];                                        // создаем черный квадрат
    CGFloat widthBigBlackRect = CGRectGetWidth(self.view.bounds) - 10;          // даем ему ширину (с отступом 10 от края экрана (слева/справа)
    CGFloat x = (CGRectGetWidth(self.view.bounds) - widthBigBlackRect) / 2;     // координата Х от которой отнимается ширина квадрата и все это / на 2 (для центровки)
    CGFloat y = (CGRectGetHeight(self.view.bounds) - widthBigBlackRect) / 2;    // то же самое что и на строку выше
    bigBlackRect = [self create:[UIColor blackColor] withX:x withY:y withWidth:widthBigBlackRect withHeight:widthBigBlackRect]; // создаем
    bigBlackRect.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;   // делаем его изменяемым при повороте экрана
    [self.view addSubview:bigBlackRect];    // выводим его на экран
    
    
    // создаем белый квадрат (он же сабвью у черного)
    UIView *bigWhiteRect = [UIView new];
    CGFloat widthBigWhiteRect = CGRectGetWidth(bigBlackRect.bounds) - 2;
    bigWhiteRect = [self create:[UIColor whiteColor] withX:CGRectGetMinX(bigWhiteRect.bounds) + 1
                                                      withY:CGRectGetMinY(bigWhiteRect.bounds) + 1
                                                  withWidth:widthBigWhiteRect
                                                 withHeight:widthBigWhiteRect];
    bigWhiteRect.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [bigBlackRect addSubview:bigWhiteRect];
    
    // черный маленький квадрат
    CGFloat sizeSmallBlackRect = CGRectGetWidth(bigWhiteRect.bounds) / 8 - 0.5;      // размер малого квадрата
    CGRect fieldForBlackRect = CGRectMake(CGRectGetMinX(bigWhiteRect.bounds) + 2,           // его координаты
                              CGRectGetMinY(bigWhiteRect.bounds) + 2,
                              sizeSmallBlackRect,
                              sizeSmallBlackRect);
    // белый маленький квадрат
    CGFloat sizeSmallWhiteRect = CGRectGetWidth(bigWhiteRect.bounds) / 8 - 0.5;      // размер малого квадрата
    CGRect fieldForWhiteRect = CGRectMake(CGRectGetMinX(bigWhiteRect.bounds) + 2 + sizeSmallWhiteRect,           // его координаты
                                          CGRectGetMinY(bigWhiteRect.bounds) + 2,
                                          sizeSmallWhiteRect,
                                          sizeSmallWhiteRect);

    for (int i = 0; i < 8; i++) {                                                           // черные и "белые" (пропуски) квадраты
        for (int j = 0; j < 4; j++) {                                                       // спускаемся на шаг ниже
            // создаем поле из черных квадратов
            UIView *createBlacView = [[UIView alloc] initWithFrame:fieldForBlackRect];      // создаем квадрат
            createBlacView.backgroundColor = [UIColor blackColor];                          // цвет
            fieldForBlackRect.origin.x += sizeSmallBlackRect * 2;                           // идем по X
            [bigWhiteRect addSubview:createBlacView];                                       // добавляем его в subview
            // создаем шашки
            UIImageView *whiteChess = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            UIImage *whiteChassImg = [UIImage imageNamed:@"whiteChess.png"];
            whiteChess.image = whiteChassImg;
            [createBlacView addSubview:whiteChess];
            
            // создаем поле из белых квадратов
            UIView *createWhiteView = [[UIView alloc] initWithFrame:fieldForWhiteRect];
            createWhiteView.backgroundColor = [UIColor whiteColor];
            fieldForWhiteRect.origin.x += sizeSmallWhiteRect * 2;
            [bigWhiteRect addSubview:createWhiteView];
        }
        if (i % 2) {                                                                        // если i четное
            fieldForBlackRect.origin.x = CGRectGetMinX(bigWhiteRect.bounds) + 2;            // добавляем квадрат с отступом (квадрата)
        } else {
            fieldForBlackRect.origin.x = sizeSmallBlackRect + 2;                                 //что и сверху но по У
        }
        fieldForBlackRect.origin.y += sizeSmallBlackRect;                                        //добавляем расстойние в два квадрата по У
        // делаем второй цикл для заполнением whiteRectView
        if (i % 2 == FALSE) {
            fieldForWhiteRect.origin.x = CGRectGetMinX(bigWhiteRect.bounds) + 2;
        } else {
            fieldForWhiteRect.origin.x = sizeSmallWhiteRect + 2;
        }
        fieldForWhiteRect.origin.y += sizeSmallWhiteRect;
    }
}
- (UIView *) create:(UIColor *)color withX:(CGFloat) x withY:(CGFloat) y withWidth:(CGFloat) width withHeight:(CGFloat) height {
    CGRect rect = CGRectMake(x, y, width, height);
    UIView *createRect = [[UIView alloc] initWithFrame:rect];
    createRect.backgroundColor = color;
    return createRect;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//1. Создайте шахматное поле (8х8), используйте черные сабвьюхи
//2. Добавьте балые и красные шашки на черные клетки (используйте начальное расположение в шашках)
//3. Реализуйте механизм драг'н'дроп подобно тому, что я сделал в примере, но с условиями:
//4. Шашки должны ставать в центр черных клеток.
//5. Даже если я отпустил шашку над центром белой клетки - она должна переместиться в центр ближайшей к отпусканию черной клетки.
//6. Шашки не могут становиться друг на друга
//7. Шашки не могут быть поставлены за пределы поля.


@end
