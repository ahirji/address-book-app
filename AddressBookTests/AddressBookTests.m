//
//  AddressBookTests.m
//  AddressBookTests
//
//  Created by A Hirji on 2015-02-22.
//  Copyright (c) 2015 A Hirji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AppDelegate.h"
#import "AddressBookController.h"
#import "DetailViewController.h"

@interface AddressBookTests : XCTestCase {

@private
    UIApplication *app;
    AppDelegate *appDelegate;
    AddressBookController *addressBookController;
    DetailViewController *detailViewController;
}
@end

@implementation AddressBookTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetContacts {
    [addressBookController getContactsWithCompletionCallback:^(BOOL success){
        XCTAssert(success);
    }];
}

- (void)testAddressBookListsAllUsers {
    NSInteger expectedRows = 100;
    [addressBookController getContactsWithCompletionCallback:^(BOOL success) {
        XCTAssertTrue([addressBookController tableView:addressBookController.tableView numberOfRowsInSection:expectedRows]);
    }];
}

-(void)testAddressBookTableViewReturnsCellClass {
    [addressBookController getContactsWithCompletionCallback:^(BOOL success){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [addressBookController tableView:addressBookController.tableView cellForRowAtIndexPath:indexPath];
        XCTAssertTrue(cell);
    }];
}

- (void)testGetUserImage {
    [addressBookController getContactsWithCompletionCallback:^(BOOL success){}];
    [detailViewController getImageWithCompletionCallback:^(BOOL success){
        XCTAssert(success);
    }];
}

@end
