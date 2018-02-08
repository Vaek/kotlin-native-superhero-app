//
//  CharactersViewController.m
//  SuperheroApp
//
//  Created by Balázs Varga on 2018. 01. 24..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import "CharactersViewController.h"
#import "CharacterDetailViewController.h"
#import "Character.h"
#import "CharactersPresenter.h"

@interface CharactersViewController ()

@property(atomic, strong) NSMutableArray<Character *> *objects;
@property(nonatomic, strong) id<CharactersMvpPresenter> presenter;
@property(nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation CharactersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailViewController = (CharacterDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.tableView.backgroundView = self.indicator;
    
    self.objects = [NSMutableArray array];
    self.presenter = [CharactersPresenter new];
    
    [self.presenter takeView:self];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Character *object = self.objects[indexPath.row];
        CharacterDetailViewController *controller = (CharacterDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Character *object = self.objects[indexPath.row];
    cell.textLabel.text = object.name;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)setLoadingIndicator:(BOOL)active {
    if (active) {
        [self.indicator startAnimating];
    } else {
        [self.indicator stopAnimating];
    }
}

- (void)showCharacterDetails:(NSString *)characterId {
    
}

- (void)showCharacters:(NSArray *)characters {
    
    [self.objects addObjectsFromArray:characters];

    [self.tableView reloadData];
}

- (void)showNoCharacters {
    
}

- (void)showLoadingCharactersError:(NSString *)message {
    
}

@end
