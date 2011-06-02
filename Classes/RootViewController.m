//
//  RootViewController.m
//  DrinkMixer
//
//  Created by Gustavo Barbosa on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DrinkDetailViewController.h"
#import "AddDrinkViewController.h"
#import "DrinkConstants.h"


@implementation RootViewController

@synthesize drinks;
@synthesize addButtonItem;

#pragma mark -
#pragma mark View lifecycle

- (IBAction)addButtonPressed:(id)sender {
	NSLog(@"Add button pressed!");
	AddDrinkViewController *addViewController = [[AddDrinkViewController alloc] 
												 initWithNibName:@"DrinkDetailViewController" bundle:nil];
	addViewController.drinkArray = self.drinks;
	UINavigationController *addNavigationController = [[UINavigationController alloc] 
													   initWithRootViewController:addViewController];
	[self presentModalViewController:addNavigationController animated:YES];
	[addViewController release];
	[addNavigationController release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"DrinksDirections" ofType:@"plist"];
	drinks = [[NSMutableArray alloc] initWithContentsOfFile:path];
	
	// Registar o observer de fim da aplicação
	[[NSNotificationCenter defaultCenter] addObserver:self 
									      selector:@selector(applicationWillTerminate:) 
										  name:UIApplicationWillTerminateNotification
   									      object: nil];
	
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	NSLog(@"applicationWillTerminate !!!");
	// WARNING !
	// Este código dá problema num aparelho real... mais tarde descobrirei o motivo. Parece ser permisão de escrita.
	NSString *path = [[NSBundle mainBundle] pathForResource:@"DrinksDirections" ofType:@"plist"];
	[self.drinks writeToFile:path atomically:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.drinks count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	cell.textLabel.text = [[drinks objectAtIndex:indexPath.row] objectForKey:NAME_KEY];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source.
		[self.drinks removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
	}   
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.editing) {
		DrinkDetailViewController *detailViewController = 
			[[DrinkDetailViewController alloc] initWithNibName:@"DrinkDetailViewController" bundle:nil];
		
		detailViewController.drink = [drinks objectAtIndex:indexPath.row];
		
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	} else {
		AddDrinkViewController *editViewController = [[AddDrinkViewController alloc] 
													  initWithNibName:@"DrinkDetailViewController" bundle:nil];
		editViewController.drinkArray = self.drinks;
		editViewController.drink = [self.drinks objectAtIndex:indexPath.row];
		
		UINavigationController *editNavigationController = [[UINavigationController alloc] 
															initWithRootViewController:editViewController];		
		[self presentModalViewController:editNavigationController animated:YES];
		
		[editViewController release];
		[editNavigationController release];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Remove os observers dessa classe
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
	[drinks release];
	[addButtonItem release];
    [super dealloc];
}

@end
