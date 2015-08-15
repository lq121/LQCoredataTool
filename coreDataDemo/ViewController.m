//
//  ViewController.m
//  coreDataDemo
//
//  Created by leyi on 15/8/15.
//  Copyright (c) 2015年 LQ. All rights reserved.
//

#import "ViewController.h"
#import "coreDataTools.h"
#import "Person.h"
#import "Company.h"

@interface ViewController ()<NSFetchedResultsControllerDelegate>
// coreData结果控制器
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,assign)int  i;

@end

@implementation ViewController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors = @[sort];
        _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext: [coreDataTools shareCoreDataTools].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        // 设置代理
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fetchedResultsController performFetch:NULL];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
#pragma mark -插入数据
      Person *p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[coreDataTools shareCoreDataTools].managedObjectContext];
        p.name = [NSString stringWithFormat:@"demo---%d",self.i];
        p.age =@(self.i++);
        p.phoneNo = @"12345678901";
        [[coreDataTools shareCoreDataTools]saveContext];

        NSSortDescriptor *d = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *des = @[d];
        NSPredicate *per = [NSPredicate predicateWithFormat:@"age > 2 && name CONTAINS %@",@"3"];
    
#pragma mark - 查询数据
        NSArray *array = [[coreDataTools shareCoreDataTools]selectDataWithEntityForName:@"Person" andSortDescriptors:des andPerdicate:per];
        for (Person *p in array)
        {
            NSLog(@"%@",p);
        }
    
    
#pragma mark -删除数据
    [[coreDataTools shareCoreDataTools]deleteDataWithentityForName:@"Person" Predicate:nil];
    
#pragma mark -修改数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"demo" forKey:@"name"];
    [[coreDataTools shareCoreDataTools]updateDataWithEntityForName:@"Person" andPredicate:per andDict:dict];
    
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"发生了变化");
  }




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
