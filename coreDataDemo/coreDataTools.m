//
//  coreDataTools.m
//  coreData单例
//
//  Created by leyi on 15/8/14.
//  Copyright (c) 2015年 LQ. All rights reserved.
//

#import "coreDataTools.h"
#import "Person.h"

@implementation coreDataTools

/*
 * 创建单例对象
 */
+ (instancetype)shareCoreDataTools
{
    static coreDataTools *coredataTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coredataTool = [[self alloc]init];
    });
    return coredataTool;
}


/*
 * 设置创建的coreData的模型名和数据库的名字
 */
- (void)setUpCoreDataWithModelName:(NSString*)modelName andDBName:(NSString*)DBName
{
    // 1.实例化数据模型
    NSURL *modelURL = [[NSBundle mainBundle]URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    
    // 2.实例化持久化存储调度器
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:managedObjectModel];
    
    // 3.指定存储数据文件的路径以及类型
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    dbPath = [dbPath stringByAppendingString:DBName];
    NSURL *dbURL = [NSURL fileURLWithPath:dbPath];
    [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:NULL];
    
    // 4.被管理的对象的上下文
    _managedObjectContext = [[NSManagedObjectContext alloc]init];
    [_managedObjectContext setPersistentStoreCoordinator:psc];
}


/*
 * 保存上下文（返回保存成功失败的提示）
 */
- (BOOL)saveContext
{
    NSError * error = nil;
    if (  [self.managedObjectContext save: &error])
    {
        return YES;
    }
    else
    {
        NSLog(@"%@",error);
        return NO;
    }
}


/*
 * 删除指定的数据
 * entityForName 实体的名字（删除的数据表）
 * predicate 删除的条件 (用到谓词)
 */
- (void)deleteDataWithentityForName:(NSString *)entityForName Predicate:(NSPredicate *)predicate
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    request.predicate = predicate;
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityForName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError * error = nil;
    NSArray * array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([array count] > 0)
    {
        Class p = NSClassFromString(entityForName);
        for ( p in array)
        {
            [self.managedObjectContext deleteObject:p];
            if ([p isDeleted])
            {
                if ([[coreDataTools shareCoreDataTools]saveContext])
                {
                    NSLog(@"删除操作成功");
                }
                else
                {
                    NSLog(@"删除数据失败error = %@", error);
                }
            }
            else
            {
                NSLog(@"删除数据失败");
            }
            
        }
    }
    else
    {
        NSLog(@"数据不存在");
    }
}



/*
 * 根据指定的条件去查询某数据
 * entityForName 查询的数据表
 * sortDescriptors 查询的数据排序规则（coreData中要求必须传递至少一个）
 * predicate 查询的条件（用到谓词）
 */
- (NSArray*)selectDataWithEntityForName:(NSString *)entityForName andSortDescriptors:(NSArray*)sortDescriptors andPerdicate:(NSPredicate*)predicate
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityForName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    // 设置排序条件
    [request setSortDescriptors:sortDescriptors];
    // 设置查询条件
    request.predicate = predicate;
    NSError * error = nil;
    NSArray * array = [[coreDataTools shareCoreDataTools].managedObjectContext executeFetchRequest:request error:&error];
    if (array.count == 0)
    {
        NSLog(@"数据不存在");
    }
    
    return array;
}



/*
 * 根据条件修改指定的数据
 * entityForName 操作的数据表
 * predicate 修改对应数据的条件
 * dict 修改的内容
 */
- (void)updateDataWithEntityForName:(NSString*)entityForName andPredicate:(NSPredicate*)predicate andDict:(NSDictionary*)dict
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityForName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    request.predicate = predicate;
    NSError * error = nil;
    NSArray *array =  [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([array count] > 0)
    {
        // TODO 在此处写你的需要修改的东西如下方式
        for (Person *ps in array)
        {
            ps.name = @"ghjk";
            ps.name = dict[@"name"];
            ps.age =dict[@"age"];
            
        }
        // 更新数据
        NSError * savingError = nil;
        if ([self saveContext])
        {
            NSLog(@"更改数据成功");
        }
        else
        {
            NSLog(@"更改数据失败error = %@", savingError);
        }
        
        
    }else
    {
        NSLog(@"未找到该数据");
    }
}

- (void)deleteDataWithManagedObject:(NSManagedObject *)managedObject
{
    // 传入需要删除的实体对象
    [self.managedObjectContext deleteObject:managedObject];
    // 将结果同步到数据库
    NSError *error = nil;
    [self.managedObjectContext  save:&error];
    if (error)
    {
        [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
    }
}
@end
