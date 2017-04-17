//
//  ViewController.m
//  14-HomeWork-Touches-Simple-Drag-and-Drop
//
//  Created by Slava on 14.04.17.
//  Copyright © 2017 Slava. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *field;
@property (strong, nonatomic) UIView *smallBlackRect;
@property (strong, nonatomic) NSMutableArray *arrayWithSmallBlackRect;
@property (strong, nonatomic) NSMutableArray *arrayWithBlackCess;
@property (strong, nonatomic) NSMutableArray *arrayWithWhiteCess;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(float)(233 % 256) / 255
                                                green:(float)(233 % 256) / 255
                                                 blue:(float)(233 % 256) / 255
                                                alpha:1];
    
    [self createBoard];
    [self createField];
    [self createAndSetChass];
}


#pragma mark - Create board
- (void) createBoard {
    CGFloat widthAndHeight = CGRectGetWidth(self.view.bounds);
    CGFloat x = (CGRectGetWidth(self.view.bounds) - widthAndHeight) / 2;
    CGFloat y = (CGRectGetHeight(self.view.bounds) - widthAndHeight) / 2;
    CGRect fieldRect = CGRectMake(x, y, widthAndHeight, widthAndHeight);
    self.field = [[UIView alloc]initWithFrame:fieldRect];
    self.field.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.field];
}

#pragma mark - Create field (black Rect)
- (void) createField {
    self.arrayWithSmallBlackRect = [NSMutableArray new];
    CGFloat widthAngHeight = CGRectGetWidth(self.field.bounds) / 8;
    CGFloat x = CGRectGetMinX(self.field.bounds);
    CGFloat y = CGRectGetMinY(self.field.bounds);
    CGRect blackRect = CGRectMake(x, y, widthAngHeight, widthAngHeight);

    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 4; j++) {
            self.smallBlackRect = [[UIView alloc]initWithFrame:blackRect];
            self.smallBlackRect.backgroundColor = [UIColor blackColor];
            blackRect.origin.x += widthAngHeight * 2;
            [self.field addSubview:self.smallBlackRect];
            [self.arrayWithSmallBlackRect addObject:self.smallBlackRect];
        }
        if (i % 2) {                                                                        // если i четное
            blackRect.origin.x = CGRectGetMinX(self.field.bounds);            // добавляем квадрат с отступом (квадрата)
        } else {
            blackRect.origin.x = widthAngHeight;                                 //что и сверху но по У
        }
        blackRect.origin.y += widthAngHeight;
    }
    
    
}

#pragma mark - Create an set chass {
- (void) createAndSetChass {
    UIImageView *blackChess = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImage *blackChessImg = [UIImage imageNamed:@"blackChess.png"];
    blackChess.image = blackChessImg;
            [self.smallBlackRect addSubview:blackChess];
    
    UIImageView *whiteChess = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImage *whiteChessImg = [UIImage imageNamed:@"whiteChess.png"];
    whiteChess.image = whiteChessImg;
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
