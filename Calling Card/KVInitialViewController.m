//
//  KVInitialViewController.m
//  Calling Card
//
//  Created by Kyle Stevens on 7/12/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "KVInitialViewController.h"

@interface KVInitialViewController ()

@end

@implementation KVInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    ABRecordID recordID = (ABRecordID)[[NSUserDefaults standardUserDefaults] integerForKey:@"recordID"];
    if (recordID) {
        [self performSegueWithIdentifier:@"front" sender:self];
    } else {
        [self performSegueWithIdentifier:@"setup" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
