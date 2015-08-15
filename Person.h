//
//  Person.h
//  
//
//  Created by leyi on 15/8/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNo;
@property (nonatomic, retain) Company *personCompany;

@end
