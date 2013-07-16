//
//  KVViewController.m
//  Calling Card
//
//  Created by Kyle Stevens on 6/30/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "KVFrontViewController.h"
#import "KVBackEmailViewController.h"

@interface KVFrontViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *previousEmailAddress;
@end

@implementation KVFrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    self.textField.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(presentKeyboard) withObject:nil afterDelay:0.1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.previousEmailAddress = textField.text;
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"backEmail" sender:self];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"backEmail"]) {
        if ([segue.destinationViewController isKindOfClass:[KVBackEmailViewController class]]) {
            ((KVBackEmailViewController *)segue.destinationViewController).emailAddress = self.textField.text;
        }
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.textField.text = self.previousEmailAddress;
    }
}

- (void)presentKeyboard {
    [self.textField becomeFirstResponder];
}

@end