//
//  DetailViewController.m
//  AddressBook
//
//  Created by A Hirji on 2015-02-22.
//  Copyright (c) 2015 A Hirji. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (copy) void (^callback) (BOOL success);

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *name = [self.user valueForKey:@"name"];
    
    NSString *fullname = [[name valueForKey:@"first"] stringByAppendingFormat:@" %@", [name valueForKey:@"last"]];
    [self.lblContactName setText:[fullname capitalizedString]];
    
    [self getImageWithCompletionCallback:nil];
}

-(void)getImageWithCompletionCallback:(void (^)(BOOL success))callback {
    self.callback = callback;
    
    NSDictionary *pics = [self.user valueForKey:@"picture"];
    
    NSString *imageUrlString = [pics valueForKey:@"thumbnail"];
    NSURL *url = [NSURL URLWithString:imageUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Cancel any current connections
    if (self.currentConnection) {
        [self.currentConnection cancel];
        self.currentConnection = nil;
        self.responseData = nil;
    }
    
    self.currentConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // If successful, get returned JSON
    self.responseData = [NSMutableData data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"URL connection has failed!");
    self.currentConnection = nil;
    if (self.callback != nil)
        self.callback(NO);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *userThumb = [UIImage imageWithData:self.responseData];
    
    if (userThumb != nil) {
        if (self.callback != nil)
            self.callback(YES);
        [self.imgContactImage setImage:userThumb];
    } else {
        if (self.callback != nil)
            self.callback(NO);
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
    
        case 0: {
            // populate address
            NSDictionary *address = [self.user valueForKey:@"location"];
            NSString *fullAddr = [[address valueForKey:@"street"] stringByAppendingFormat:@",\n%@, %@\n%@", [address valueForKey:@"city"], [address valueForKey:@"state"], [address valueForKey:@"zip"]];
            [cell.textLabel setText:[fullAddr capitalizedString]];
            cell.textLabel.numberOfLines = 3;
            [cell.detailTextLabel setText:@""];
            break;
        }
            
        case 1: {
            // populate email
            [cell.textLabel setText:[self.user valueForKey:@"email"]];
            [cell.detailTextLabel setText:@""];
            break;
        }
        
        case 2: {
            // populate phone
            [cell.textLabel setText:@"Main"];
            [cell.detailTextLabel setText:[self.user valueForKey:@"phone"]];
            break;
        }
            
        case 3: {
            // populate mobile
            [cell.textLabel setText:@"Mobile"];
            [cell.detailTextLabel setText:[self.user valueForKey:@"cell"]];
            break;
        }
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Address";
    }
    else if (section == 1) {
        return @"Email";
    }
    else if (section == 2) {
        return @"Phone Numbers";
    }
    else {
        return @"";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSString *phone = [[[self.user valueForKey:@"phone"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *phoneString = [NSString stringWithFormat:@"tel://%@", phone];
        NSURL *phoneUrl = [NSURL URLWithString:phoneString];
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else if (indexPath.section == 3) {
        NSString *mobile = [[[self.user valueForKey:@"cell"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *phoneString = [NSString stringWithFormat:@"tel://%@", mobile];
        NSURL *phoneUrl = [NSURL URLWithString:phoneString];
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

@end
