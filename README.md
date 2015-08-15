# LQCoredataTool
对coredata的一些（删改查）的封装
## LQCoredataTool
对coreData 插入、删除、修改进行操作

## 使用步骤
* 1 在xode创建一个codedata的data Model 然后创建需要的实体以及实体间的关系
* 2 在AppDelegate 的
* 3 引入头文件"coreDataTools.h"
* ···objc
* 4 在以下方法中
* -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[coreDataTools shareCoreDataTools]setUpCoreDataWithModelName:@"Model" andDBName:@"demo.db"]; // 创建模型的名字以及数据库的名字
return YES;
}
* 5 对数据进行相关的数据


## 插入数据
Person *p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[coreDataTools shareCoreDataTools].managedObjectContext];
        p.name = [NSString stringWithFormat:@"demo---%d",self.i];
        p.age =@(self.i++);
        p.phoneNo = @"12345678901";
        [[coreDataTools shareCoreDataTools]saveContext];
        
## 查询数据
/*
 * 根据指定的条件去查询某数据
 * entityForName 查询的数据表
 * sortDescriptors 查询的数据排序规则（coreData中要求必须传递至少一个）
 * predicate 查询的条件（用到谓词）
 */
- (NSArray*)selectDataWithEntityForName:(NSString *)entityForName andSortDescriptors:(NSArray*)sortDescriptors andPerdicate:(NSPredicate*)predicate;

 NSArray *array = [[coreDataTools shareCoreDataTools]selectDataWithEntityForName:@"Person" andSortDescriptors:des andPerdicate:per];
        for (Person *p in array)
        {
            NSLog(@"%@",p);
        }
##  删除数据
/*
 * 删除指定的数据
 * entityForName 实体的名字（删除的数据表）
 * predicate 删除的条件 (用到谓词)
 */

[[coreDataTools shareCoreDataTools]deleteDataWithentityForName:@"Person" Predicate:nil];

## 更新数据
/*
 * 根据条件修改指定的数据
 * entityForName 操作的数据表
 * predicate 修改对应数据的条件
 * dict 修改的内容
 */
- (void)updateDataWithEntityForName:(NSString*)entityForName andPredicate:(NSPredicate*)predicate andDict:(NSDictionary*)dict;

  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"demo" forKey:@"name"];
    [[coreDataTools shareCoreDataTools]updateDataWithEntityForName:@"Person" andPredicate:per andDict:dict];
    
# 更新数据中需要写对应的实体类
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
# coredata有自己的代理方法可以设置代理方法去监听数据的变化
