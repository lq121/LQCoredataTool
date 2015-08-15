//
//  coreDataTools.h
//  coreData单例
//
//  Created by leyi on 15/8/14.
//  Copyright (c) 2015年 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface coreDataTools : NSObject

@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;


/*
 * 创建单例对象
 */
+ (instancetype)shareCoreDataTools;


/*
 * 设置创建的coreData的模型名和数据库的名字
 */
- (void)setUpCoreDataWithModelName:(NSString*)modelName andDBName:(NSString*)DBName;


/*
 * 保存上下文（返回保存成功失败的提示）
 */
- (BOOL)saveContext;


/*
 * 删除指定的数据
 * entityForName 实体的名字（删除的数据表）
 * predicate 删除的条件 (用到谓词)
 */
- (void)deleteDataWithentityForName:(NSString *)entityForName Predicate:(NSPredicate *)predicate;



/*
 * 根据指定的条件去查询某数据
 * entityForName 查询的数据表
 * sortDescriptors 查询的数据排序规则（coreData中要求必须传递至少一个）
 * predicate 查询的条件（用到谓词）
 */
- (NSArray*)selectDataWithEntityForName:(NSString *)entityForName andSortDescriptors:(NSArray*)sortDescriptors andPerdicate:(NSPredicate*)predicate;



/*
 * 根据条件修改指定的数据
 * entityForName 操作的数据表
 * predicate 修改对应数据的条件
 * dict 修改的内容
 */
- (void)updateDataWithEntityForName:(NSString*)entityForName andPredicate:(NSPredicate*)predicate andDict:(NSDictionary*)dict;

/*
 * 删除某个实体
 * managedObject 实体对象
 */
- (void)deleteDataWithManagedObject:(NSManagedObject *)managedObject;
@end
