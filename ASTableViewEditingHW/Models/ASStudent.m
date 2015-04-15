//
//  ASStudent.m
//  ASTableViewEditingHW
//
//  Created by Alex Sergienko on 04.03.15.
//  Copyright (c) 2015 Alexandr Sergienko. All rights reserved.
//

#import "ASStudent.h"

static NSString *firstNames [] = {
    @"Aiden",   @"Jackson",  @"Ethan",  @"Liam",    @"Mason",
    @"Noah",    @"Lucas",    @"Jacob",  @"Jayden",  @"Jack",
    @"Logan",   @"Ryan",     @"Caleb",  @"Benjamin",@"William",
    @"Michael", @"Alexander",@"Elijah", @"Matthew", @"Dylan",
    @"James",   @"Owen",     @"Connor", @"Brayden", @"Carter",
    @"Joshua",  @"Luke",     @"Daniel", @"Gabriel", @"Nicholas"
};


static NSString *lastNames [] = {
    
    @"Bender",   @"Benjamin",  @"Bennett", @"Benson",   @"Bentley",
    @"Clayton",  @"Clements",  @"Clemons", @"Cleveland",@"Flynn",
    @"Foley",    @"Forbes",    @"Ford",    @"Howell",   @"Hubbard",
    @"Huber",    @"Hudson",    @"Mann",    @"Manning",  @"Marks",
    @"Sergienko",@"Petrov",    @"Bugaenko",@"Petrenko", @"Kroul",
    @"Jason",    @"Nottingem", @"Demitrov",@"Dubenko",  @"Reilly"
};

static int firstNamesAndLastNamesCount = 30;


@implementation ASStudent

+ (ASStudent*) createNewStudent {
    
    ASStudent *newStudent = [[ASStudent alloc]init];
    
    newStudent.firstName = firstNames [arc4random() % firstNamesAndLastNamesCount];
    newStudent.lastName  = lastNames  [arc4random() % firstNamesAndLastNamesCount];
    newStudent.averageRating = (CGFloat)(arc4random() % 191 + 270) / 100;
    
    return newStudent;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end

