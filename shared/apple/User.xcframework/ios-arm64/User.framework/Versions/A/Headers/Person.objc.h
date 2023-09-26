// Objective-C API for talking to appbricks.io/gomobiletest/person Go package.
//   gobind -lang=objc appbricks.io/gomobiletest/person
//
// File is generated by gobind. Do not edit.

#ifndef __Person_H__
#define __Person_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class PersonPerson;
@protocol PersonIdentity;
@class PersonIdentity;

@protocol PersonIdentity <NSObject>
- (NSString* _Nonnull)username;
@end

@interface PersonPerson : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nullable instancetype)init:(id<PersonIdentity> _Nullable)identity;
@property (nonatomic) NSString* _Nonnull fullName;
@property (nonatomic) NSString* _Nonnull address;
@property (nonatomic) NSString* _Nonnull dob;
- (NSString* _Nonnull)age;
@end

FOUNDATION_EXPORT PersonPerson* _Nullable PersonNewPerson(id<PersonIdentity> _Nullable identity);

@class PersonIdentity;

@interface PersonIdentity : NSObject <goSeqRefInterface, PersonIdentity> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (NSString* _Nonnull)username;
@end

#endif