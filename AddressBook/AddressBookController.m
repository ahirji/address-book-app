//
//  MasterViewController.m
//  AddressBook
//
//  Created by A Hirji on 2015-02-22.
//  Copyright (c) 2015 A Hirji. All rights reserved.
//

#import "AddressBookController.h"
#import "DetailViewController.h"

static int maxResultsCount = 100;  // max=100

@interface AddressBookController ()

@property (copy) void (^callback) (BOOL success);

@end

@implementation AddressBookController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getContactsWithCompletionCallback:nil];
}

- (void)getContactsWithCompletionCallback:(void (^)(BOOL success))callback {
    
    self.callback = callback;
    // Make Random Users API call
    NSString *restCallString = [NSString stringWithFormat:@"http://api.randomuser.me/?results=%d", maxResultsCount];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    
    // Cancel any current connections
    if (self.currentConnection) {
        [self.currentConnection cancel];
        self.currentConnection = nil;
        self.responseData = nil;
    }
    
    self.currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    
    // If successful, get JSON response
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
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&localError];
    
    self.results = [parsedObject valueForKey:@"results"];

    if (localError == nil && self.results.count > 0) {
        if (self.callback != nil)
            self.callback(YES);
        [self.tableView reloadData];
    } else {
        if(self.callback != nil)
            self.callback(NO);
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *details = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        details.user = [[self.results objectAtIndex:indexPath.row] valueForKey:@"user"];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *user = [[self.results objectAtIndex:indexPath.row] valueForKey:@"user"];
    NSDictionary *name = [user valueForKey:@"name"];
    
    NSString *fullname = [[name valueForKey:@"first"] stringByAppendingFormat:@" %@", [name valueForKey:@"last"]];
    [cell.textLabel setText:[fullname capitalizedString]];
    return cell;
}


@end
