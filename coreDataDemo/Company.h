//
//  Company.h
//  
//
//  Created by leyi on 15/8/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSSet *persons;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;

@end
