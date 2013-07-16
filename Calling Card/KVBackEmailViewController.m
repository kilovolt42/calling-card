//
//  KVSendScreenViewController.m
//  Calling Card
//
//  Created by Kyle Stevens on 6/30/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "KVBackEmailViewController.h"
#import <MessageUI/MessageUI.h>

@interface KVBackEmailViewController () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectedButtons;
@end

@implementation KVBackEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	for (UIButton *button in self.selectedButtons) {
        [button setSelected:NO];
        [button setAlpha:0.4];
    }
}

- (IBAction)selectButton:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
        [sender setAlpha:0.4];
    } else {
        [sender setSelected:YES];
        [sender setAlpha:1.0];
    }
}
- (IBAction)sendButtonPressed {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIButton *button in self.selectedButtons) {
        if (button.isSelected) {
            [array addObject:button];
        }
    }
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordID recordID = (ABRecordID)[[NSUserDefaults standardUserDefaults] integerForKey:@"recordID"];
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(addressBook, recordID);
    
    NSMutableString *message = [[NSMutableString alloc] initWithString:@"Here's my information:\n\n"];
    
    for (UIButton *button in self.selectedButtons) {
        if (button.isSelected) {
            if ([button.titleLabel.text isEqualToString:@"Email"]) {
                NSString *emailAddress;
                ABMultiValueRef emailRef = (ABMultiValueRef)ABRecordCopyValue(recordRef, kABPersonEmailProperty);
                emailAddress = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emailRef, 0);
                CFRelease(emailRef);
                [message appendFormat:@"Email: %@\n", emailAddress];
            } else if ([button.titleLabel.text isEqualToString:@"Phone"]) {
                NSString *phoneNumber;
                ABMultiValueRef phoneRef = (ABMultiValueRef)ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
                phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneRef, 0);
                CFRelease(phoneRef);
                [message appendFormat:@"Phone: %@\n", phoneNumber];
            }
        }
    }
    
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
    NSString *fullName = [firstName stringByAppendingFormat:@" %@", (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonLastNameProperty)];
    [message appendFormat:@"\n%@", fullName];
    
    CFRelease(addressBook);
    
    MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
    mcvc.mailComposeDelegate = self;
    [mcvc setToRecipients:@[self.emailAddress]];
    [mcvc setSubject:[NSString stringWithFormat:@"Calling Card - %@", fullName]];
    [mcvc setMessageBody:message isHTML:NO];
    [self presentViewController:mcvc animated:YES completion:nil];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
