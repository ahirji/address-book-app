//
//  MasterViewController.h
//  AddressBook
//
//  Created by A Hirji on 2015-02-22.
//  Copyright (c) 2015 A Hirji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AddressBookController : UITableViewController <NSURLConnectionDelegate>

-(void) getContactsWithCompletionCallback:(void (^)(BOOL success))callback;

@property (retain, nonatomic) NSURLConnection *currentConnection;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSArray *results;

@end

