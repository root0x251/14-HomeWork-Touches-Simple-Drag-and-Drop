//
//  ViewController.m
//  14-HomeWork-Touches-Simple-Drag-and-Drop
//
//  Created by Slava on 14.04.17.
//  Copyright © 2017 Slava. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) UIView* draggingView;
@property (assign, nonatomic) CGPoint touchOffset;
@property (strong, nonatomic) NSMutableArray* arrayChecker;
@property (strong, nonatomic) NSMutableArray* arrayBlackCells;
@property (strong, nonatomic) NSMutableArray* arrayFreeCells;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.arrayChecker = [[NSMutableArray alloc]init];
    self.arrayBlackCells = [[NSMutableArray alloc]init];
    self.arrayFreeCells =[[NSMutableArray alloc]init];
    
    
    
    for (int x=0; x<8; x++) {
        for (int y =0; y<8; y++) {
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(x*50, y*50+20, 50, 50)];
            
            view.layer.borderWidth = 0.9f;
            view.layer.borderColor = [UIColor grayColor].CGColor;
            view.backgroundColor = ((x+y) %2) == 0 ? [UIColor whiteColor] : [UIColor blackColor];
            if ([view.backgroundColor isEqual:[UIColor blackColor]]) {
                [self.arrayBlackCells addObject:view];
                if (y==3 | y== 4) {
                    [self.arrayFreeCells addObject:[NSValue valueWithCGPoint:view.center]];
                }
                
            }
            if ([view.backgroundColor isEqual:[UIColor blackColor]] && y!=3 && y!=4) {
                UIView* viewCheck = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x+5,view.frame.origin.y+5,40,40)];
                
                viewCheck.tag = 2;
                viewCheck.layer.borderWidth = 2.9f;
                viewCheck.layer.borderColor = [UIColor grayColor].CGColor;
                viewCheck.layer.cornerRadius = 20;
                if (y<3) {
                    viewCheck.backgroundColor = [UIColor redColor];
                }
                if (y>4) {
                    viewCheck.backgroundColor = [UIColor whiteColor];
                }
                
                
                [self.arrayChecker addObject:viewCheck];
                [self.view addSubview:viewCheck];
                
            }
            
            [self.view addSubview:view];
            [self.view sendSubviewToBack:view];
        }
    }
    
    //self.view.multipleTouchEnabled = YES;
}

#pragma mark - Private Methods

- (void) logTouches:(NSSet<UITouch *> *)touches withMethod:(NSString *) methodName {
    
    NSMutableString* string = [NSMutableString stringWithString:methodName];
    
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        [string appendFormat:@" %@", NSStringFromCGPoint(point)];
    }
    NSLog(@"%@", string);
}

- (void) ontouchesEnded {
    [UIView animateWithDuration:0.3 animations:^{
        self.draggingView.transform = CGAffineTransformIdentity;
        self.draggingView.alpha = 1.f;
    }];
    self.draggingView = nil;
}

- (CGFloat) getDistanceBetween: (CGPoint) first and: (CGPoint) second
{
    CGFloat x = (second.x - first.x);
    CGFloat y = (second.y - first.y);
    
    return sqrt((x*x) + (y*y));
    
}


#pragma mark - Touches

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logTouches:touches withMethod:@"touchesBegan"];
    
    UITouch* touch = [touches anyObject];
    
    CGPoint pointOnMainView = [touch locationInView:self.view];
    
    UIView* view = [self.view hitTest:pointOnMainView withEvent:event];
    
    if (view.tag == 2) {
        self.draggingView = view;
        [self.view bringSubviewToFront:self.draggingView];
        CGPoint touchPoint = [touch locationInView:self.draggingView];
        self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x, CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
        [UIView animateWithDuration:0.3 animations:^{
            self.draggingView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
            self.draggingView.alpha = 0.5f;
        }];
    } else {
        self.draggingView = nil;
    }
    [self.arrayFreeCells addObject:[NSValue valueWithCGPoint:self.draggingView.center]];
    
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logTouches:touches withMethod:@"touchesMoved"];
    
    if (self.draggingView) {
        UITouch* touch = [touches anyObject];
        CGPoint pointOnMainView = [touch locationInView:self.view];
        CGPoint correction = CGPointMake(pointOnMainView.x + self.touchOffset.x, pointOnMainView.y+self.touchOffset.y);
        self.draggingView.center = correction;
        
    }
    
    
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logTouches:touches withMethod:@"touchesEnded"];
    //CGPoint correction ;
    if (self.draggingView) {
        UITouch* touch = [touches anyObject];
        CGPoint pointOnBoard = [touch locationInView:self.view];
        
        CGFloat minDistance = MAXFLOAT;
        CGPoint cellWithMinDistance = CGPointZero;
        
        
        for (NSValue* cells in self.arrayFreeCells) {
            
            
            CGPoint cellPoint = [cells CGPointValue];
            
            
            CGFloat getCellWithMinDistance = [self getDistanceBetween:cellPoint and:pointOnBoard];
            
            if (getCellWithMinDistance < minDistance)
            {
                minDistance = getCellWithMinDistance;
                cellWithMinDistance = cellPoint;
            }
            
            CGPoint correction = CGPointMake(cellWithMinDistance.x, cellWithMinDistance.y);
            self.draggingView.center = correction;
            
        }
        
        
    }
    
    
    [self.arrayFreeCells removeObject:[NSValue valueWithCGPoint:self.draggingView.center]];
    [self ontouchesEnded];
    
    
}


- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logTouches:touches withMethod:@"touchesCancelled"];
    [self ontouchesEnded];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
