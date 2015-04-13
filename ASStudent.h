//
//  ASStudent.h
//  ASTableViewEditingHW
//
//  Created by Alex Sergienko on 04.03.15.
//  Copyright (c) 2015 Alexandr Sergienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ASStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) CGFloat averageRating;

+ (ASStudent*) createNewStudent;

@end
