//
//  ViewController.m
//  ASTableViewEditingHW
//
//  Created by Alex Sergienko on 04.03.15.
//  Copyright (c) 2015 Alexandr Sergienko. All rights reserved.
//

#import "ViewController.h"
#import "ASGroup.h"
#import "ASStudent.h"
#import "ASSimpleAnimationViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrayOfGroups;
@property (weak,   nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger startNumbersOfGroup;

@end

@implementation ViewController

-(void)loadView {
    
    [super loadView];
    
    self.navigationItem.title = @"Students register";
    
    CGRect frameForTableView = self.view.bounds;
    frameForTableView.origin = CGPointZero;
    UITableView *newTableView = [[UITableView alloc]initWithFrame:frameForTableView style:UITableViewStylePlain];
    self.tableView = newTableView;
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Edit! Behavior define in editTableView method.
/*//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewGroup:)];
//    self.navigationItem.leftBarButtonItem = leftItem;*/
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableView:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.arrayOfGroups = [NSMutableArray array];
    
    self.startNumbersOfGroup = 1;
    for (int i = 0; i < self.startNumbersOfGroup; i ++) {
        
        ASGroup *newGroup = [[ASGroup alloc]init];
        newGroup.name = [NSString stringWithFormat:@"Group №%ld", self.startNumbersOfGroup - i];
        NSMutableArray *tempArrayOfStudents = [NSMutableArray array];
        NSInteger randomNumberOfStudents = arc4random() % 6 + 5;
        for (int k = 0; k < randomNumberOfStudents; k ++) {
            [tempArrayOfStudents addObject:[ASStudent createNewStudent]];
        }
        newGroup.arrayOfStudents = tempArrayOfStudents;
        [self.arrayOfGroups addObject:newGroup];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource - 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.arrayOfGroups count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ASGroup *group = [self.arrayOfGroups objectAtIndex:section];
    NSInteger numberOfRows = [group.arrayOfStudents count] + 1;
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *regularCellIdentifier = @"CellIdentifier";
    static NSString *specificCellIndentifier = @"CellIndentifierSpesial";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:specificCellIndentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specificCellIndentifier];
            cell.textLabel.text = @"Tap here to add new student";
            cell.textLabel.textColor = [UIColor greenColor];
        }
    }else{
    
    cell = [tableView dequeueReusableCellWithIdentifier:regularCellIdentifier];
    
    if (!cell) {
        
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:regularCellIdentifier];
    }
    
    ASGroup *group = [self.arrayOfGroups objectAtIndex:indexPath.section];
    ASStudent *student = [group.arrayOfStudents objectAtIndex:indexPath.row - 1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",student.firstName, student.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f", student.averageRating];
    cell.detailTextLabel.textColor = [self determineDetailTextColorOfStudent:student];
        cell.imageView.image = [self imageDependStudentGrade:student];
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*ASGroup *group = [self.arrayOfGroups objectAtIndex:indexPath.section];
    ASStudent *student = [group.arrayOfStudents objectAtIndex:indexPath.row];
    return student.averageRating < 4.0;*/
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ASGroup *group = [self.arrayOfGroups objectAtIndex:indexPath.section];
        NSLog(@"%lu", (unsigned long)[group.arrayOfStudents count]);
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:group.arrayOfStudents];
        [tempArray removeObjectAtIndex:indexPath.row - 1];
        group.arrayOfStudents = tempArray;
        NSLog(@"%lu", (unsigned long)[group.arrayOfStudents count]);
        
        //[self.tableView beginUpdates];
        
        if ([group.arrayOfStudents count] > 0) {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else{
            [self.arrayOfGroups removeObject:group];
            NSLog(@"%lu",(unsigned long)[self.arrayOfGroups count]);
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
        }
        
        //[self.tableView endUpdates];

    }
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    ASGroup *sourceGroup = [self.arrayOfGroups objectAtIndex:sourceIndexPath.section];
    ASStudent *student = [sourceGroup.arrayOfStudents objectAtIndex:sourceIndexPath.row - 1];
    
    ASGroup *destinationGroup = [self.arrayOfGroups objectAtIndex:destinationIndexPath.section];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.arrayOfStudents];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        [tempArray removeObjectAtIndex:sourceIndexPath.row -1];
        [tempArray insertObject:student atIndex:destinationIndexPath.row - 1];
        sourceGroup.arrayOfStudents = tempArray;
        
    }else{
        
        [tempArray removeObject:student];
        sourceGroup.arrayOfStudents = tempArray;
        
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.arrayOfStudents];
        [tempArray insertObject:student atIndex:destinationIndexPath.row - 1];
        destinationGroup.arrayOfStudents = tempArray;
    }

    [self.tableView reloadData];
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    ASGroup *group = [self.arrayOfGroups objectAtIndex:section];
    NSString *titleForHeader = group.name;
    return titleForHeader;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    ASGroup *group = [self.arrayOfGroups objectAtIndex:section];
    NSString *titleForFooter = [NSString stringWithFormat:@"Students count: %lu", (unsigned long)[group.arrayOfStudents count]];
    return titleForFooter;
}


#pragma mark - UITableViewDelegate - 

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && self.tableView.isEditing) {
        
        ASGroup *group = [self.arrayOfGroups objectAtIndex:indexPath.section];
        NSInteger studentIndex = 0;
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:group.arrayOfStudents];
        [tempArray insertObject:[ASStudent createNewStudent] atIndex:studentIndex];
        group.arrayOfStudents = tempArray;
        
//        [self.tableView beginUpdates];
//        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:studentIndex+1 inSection:indexPath.section];
//        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        [self.tableView endUpdates];
        
        [self preventionOfFrequentTapsForThisAction];
    } else if (indexPath.row > 0 && !(self.tableView.isEditing)){
        
        ASSimpleAnimationViewController *contr = [[ASSimpleAnimationViewController alloc]init];
        [self.navigationController pushViewController:contr animated:YES];
    }
    [self.tableView reloadData]; //индексы отображаются корректно,но анимации нет.
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
//    CGRectGetWidth([tableView rectForFooterInSection:section]),
//    CGRectGetHeight([tableView rectForFooterInSection:section]))];
//    footerView.backgroundColor = [UIColor colorWithRed:0.429 green:0.795 blue:1.000 alpha:1.000];
//    
//    UILabel *footerTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,
//    CGRectGetWidth([tableView rectForFooterInSection:section]) - 20,
//    CGRectGetHeight([tableView rectForFooterInSection:section]))];
//    footerTextLabel.textColor = [UIColor whiteColor];
//    footerTextLabel.textAlignment = NSTextAlignmentRight;
//    ASGroup *group = [self.arrayOfGroups objectAtIndex:section];
//    footerTextLabel.text = [NSString stringWithFormat:@"Student count: %lu", (unsigned long)[group.arrayOfStudents count]];
//    [footerView addSubview:footerTextLabel];
//    
//    return footerView;
//}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Remove";
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor  =[UIColor cyanColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView*)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat headerHeight = 50.0;
    return headerHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat footerHeight = 30.0;
    return footerHeight;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    }else{
        return proposedDestinationIndexPath;
    }
}



#pragma mark - Private Support methods -

- (void) addNewGroup: (UIBarButtonItem *) sender {
    
        ASGroup *newGroup = [[ASGroup alloc]init];
        newGroup.arrayOfStudents = [NSMutableArray arrayWithObjects:[ASStudent createNewStudent],[ASStudent createNewStudent], nil];

        newGroup.name = [NSString stringWithFormat:@"Group №%lu", [self.arrayOfGroups count] + 1];
        [self.arrayOfGroups insertObject:newGroup atIndex:0];
        
//        [self.tableView beginUpdates];
//        UITableViewRowAnimation animation = [self.arrayOfGroups count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
//        [self.tableView insertSections:indexSet withRowAnimation:animation];
//    
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([newGroup.arrayOfStudents count]-1)inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        
//        [self preventionOfFrequentTapsForThisAction];
//        [self.tableView endUpdates];
    
    [self.tableView reloadData]; //без этого теряется футер,но странное добавление.
}


- (void) editTableView: (UIBarButtonItem *) sender {
    
    BOOL isEditing = self.tableView.isEditing;
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem newItem = isEditing ? UIBarButtonSystemItemEdit : UIBarButtonSystemItemDone;
    
    UIBarButtonItem *switchItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:newItem target:self action:@selector(editTableView:)];
    [self.navigationItem setRightBarButtonItem:switchItem animated:YES];
    
    if (newItem == UIBarButtonSystemItemDone) {
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewGroup:)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }else{
        self.navigationItem.leftBarButtonItem = nil;

    }
    
}


- (UIColor*) determineDetailTextColorOfStudent:(ASStudent*)student {
    
    if (student.averageRating >= 4.0) {
        return [UIColor colorWithRed:0.247 green:0.842 blue:0.178 alpha:1.000];
    }else if (student.averageRating > 3 && student.averageRating < 4.0) {
        return [UIColor colorWithRed:1.000 green:0.908 blue:0.227 alpha:1.000];
    }else{
        return [UIColor colorWithRed:1.000 green:0.041 blue:0.029 alpha:1.000];
    }
    return nil;
}


- (UIImage *)imageDependStudentGrade:(ASStudent*)student {
    
    UIImage *goodStudentImg = [UIImage imageNamed:@"student_good.jpg"];
    UIImage *badStudentImg = [UIImage imageNamed:@"student_bad.jpg"];
    CGSize imageSize = {30, 30};
    
    UIImage *studentImg = student.averageRating >= 4.0 ? goodStudentImg : badStudentImg;
    studentImg = [self imageWithImage:studentImg convertToSize:imageSize];
    
    return studentImg;
}


- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}


- (void) preventionOfFrequentTapsForThisAction {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
}

@end
