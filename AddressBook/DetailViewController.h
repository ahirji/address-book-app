//
//  DetailViewController.h
//  AddressBook
//
//  Created by A Hirji on 2015-02-22.
//  Copyright (c) 2015 A Hirji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>

-(void)getImageWithCompletionCallback:(void (^)(BOOL success))callback ;

@property (nonatomic, weak) IBOutlet UILabel *lblContactName;
@property (nonatomic, weak) IBOutlet UIImageView *imgContactImage;
@property (nonatomic, weak) IBOutlet UITableView *tblContactDetails;
@property (nonatomic, strong) NSDictionary *user;
@property (retain, nonatomic) NSURLConnection *currentConnection;
@property (retain, nonatomic) NSMutableData *responseData;

@end

