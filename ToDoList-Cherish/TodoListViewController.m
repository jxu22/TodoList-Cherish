//
//  TodoListViewController.m
//  ToDoList-Cherish
//
//  Created by Jinyao Xu on 7/29/13.
//  Copyright (c) 2013 Jinyao Xu. All rights reserved.
//

#import "TodoListViewController.h"

@interface TodoListViewController ()

@property (nonatomic, strong) NSMutableArray * toDoText; // an NSString array to store the content of todo list
@property (nonatomic, weak) UITableView * tableView;

-(void)loadData;
-(void)saveData;
-(void)onAddButton;

@end

@implementation TodoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"To Do List";
        self.toDoText = [NSMutableArray array];
      //  [self loadData];
        self.navigationItem.leftBarButtonItem = self.editButtonItem; //edit按钮，左上
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton)]; //+按钮 右上 加入触发函数onAddButton
        
        [self loadData];
        
        if(self.toDoText == nil)
        {
            self.toDoText = [[NSMutableArray alloc] initWithCapacity:0]; //初始化可变数组
        }
        
        NSLog(@"number %d" , self.toDoText.count);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad called");
    // Do any additional setup after loading the view from its nib.
    //[self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//table view source data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView called");
    if(self.tableView == nil)   // 将self.tableView(弱引用)指向实体tableView
        self.tableView = tableView;
    
    return 1;
}

//这个函数的返回值必须和增加row的函数调用相对应,否则RTE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number~ %d" , self.toDoText.count); 
    
    return self.toDoText.count;
}

/*
 *  initialize each cell of tableview with the content of toDoText(mutableArray)
 *
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath called");

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  
    
/*    [self loadData];*/
    
    UITextField * txt = [self.toDoText objectAtIndex:indexPath.row];
    
    txt.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 15, cell.contentView.frame.size.height);
    
    [cell.contentView addSubview:txt];
    
    return cell;
    
}

/*
 *  load the latest data from disk to toDoText(mutableArray)
 *
 */

- (void)loadData
{
    NSUserDefaults *toDoTextDefault = [NSUserDefaults standardUserDefaults];
    NSData *array = [toDoTextDefault objectForKey:@"toDoText"];
    self.toDoText = [NSKeyedUnarchiver unarchiveObjectWithData:array];
}

- (void)saveData
{
    NSUserDefaults *toDoTextDefault = [NSUserDefaults standardUserDefaults];
    NSData *array = [NSKeyedArchiver archivedDataWithRootObject:self.toDoText];
    [toDoTextDefault setObject:array forKey:@"toDoText"];
    [toDoTextDefault synchronize];
}

/*
 *  When the + button is pressed
 *
 */

-(void) onAddButton
{
    NSLog(@"onAddButton called!");
    
    UITextField * newTextField = [[UITextField alloc] init];
    
    newTextField.delegate = self;
    
    [newTextField becomeFirstResponder];
    
    [self.toDoText insertObject:newTextField atIndex:0];
    
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}


/*
 *  End the editing process...
 *
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField becomeFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self saveData];
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
     [self.toDoText removeObjectAtIndex:indexPath.row];
     [self saveData];
     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     
 }
     
 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */





@end
