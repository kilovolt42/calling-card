//
//  KVWelcomeViewController.m
//  Calling Card
//
//  Created by Kyle Stevens on 7/1/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "KVSetupViewController.h"

@interface KVSetupViewController() <ABPeoplePickerNavigationControllerDelegate>

@end

@implementation KVSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)chooseContactCard:(UIButton *)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -
#pragma mark ABPeoplePickerNavigationController Delegate Methods

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)ABRecordGetRecordID(person) forKey:@"recordID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return YES;
}

@end
