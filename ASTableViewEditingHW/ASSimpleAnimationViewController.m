//
//  ASSimpleAnimationViewController.m
//  ASTableViewEditingHW
//
//  Created by Alex Sergienko on 10.04.15.
//  Copyright (c) 2015 Alexandr Sergienko. All rights reserved.
//

#import "ASSimpleAnimationViewController.h"

@interface ASSimpleAnimationViewController ()

@end

@implementation ASSimpleAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    CGRect gomerImgFrame = CGRectMake(CGRectGetMidX(self.view.frame)-100, -200, 200, 200);
    UIImageView *gomerImg = [[UIImageView alloc]initWithFrame:gomerImgFrame];
    gomerImg.image = [UIImage imageNamed:@"HomerChase"];
    
    CGRect donatImgFrame = CGRectMake(CGRectGetMidX(self.view.frame)-50, -100, 100, 100);
    UIImageView *donatImg = [[UIImageView alloc]initWithFrame:donatImgFrame];
    donatImg.image = [UIImage imageNamed:@"donat"];
    
    CGRect gomerEatImgFrame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.frame) + 250, 250, 250);
    UIImageView *gomerEatImg = [[UIImageView alloc]initWithFrame:gomerEatImgFrame];
    gomerEatImg.image = [UIImage imageNamed:@"HomerCatchTheDonat"];
    
    [self.view addSubview:gomerImg];
    [self.view addSubview:donatImg];
    [self.view addSubview:gomerEatImg];
    
    
    [UIView animateWithDuration:5.0
                     animations:^{
                         
                         donatImg.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 50, CGRectGetHeight(self.view.frame) + 100, 100, 100);
                         donatImg.transform = CGAffineTransformMakeRotation(M_PI);
                     }];
    
    
    [UIView animateWithDuration:4.0
                          delay:2.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         gomerImg.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 150, CGRectGetHeight(self.view.frame) + 250, 250, 250);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:2.0
                                          animations:^{
                                              gomerEatImg.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 100, CGRectGetHeight(self.view.frame) - 250, 250, 250);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:3.0
                                                                    delay:2.0
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   gomerEatImg.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.frame) + 250, 250, 250);
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                                               }];
                                          }];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
