#include "SBXPreviewItemAttribute.h"

@interface SBXPreviewItemAttribute ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, assign, readwrite) BOOL isDir;
@property (nonatomic, strong, readwrite) NSNumber *size;
@property (nonatomic, strong, readwrite) NSDate *lastUpdate;
@property (nonatomic, strong, readwrite) UTType *type;

@end

@implementation SBXPreviewItemAttribute

+ (instancetype)createWithFileUrl:(NSURL *)url {
    NSError *error;
    NSDictionary *dict = [url resourceValuesForKeys:[self resourceKeys] error:&error];
    if (error) {
        NSLog(@"Resource values failed at %@, Error: %@", url.path, error);
        return nil;
    }
    NSString *name = [dict[NSURLNameKey] stringValue];
    BOOL isDir = [dict[NSURLIsDirectoryKey] boolValue];
    id sizeValue = dict[NSURLFileSizeKey];
    NSNumber *size = nil;
    if ([sizeValue isKindOfClass:[NSNumber class]]) {
        size = (NSNumber *)sizeValue;
    }
    id dateValue = dict[NSURLContentModificationDateKey];
    NSDate *date = nil;
    if ([dateValue isKindOfClass:[NSDate class]]) {
        date = (NSDate *)dateValue;
    }
    id typeValue = dict[NSURLContentTypeKey];
    UTType *type = nil;
    if ([typeValue isKindOfClass:[UTType class]]) {
        type = (UTType *)typeValue;
    }
    return [self createWithName:name isDir:isDir itemSize:size updateDate:date type:type];
}

+ (instancetype)createWithName:(NSString *)name isDir:(BOOL)isDir itemSize:(NSNumber *)size updateDate:(NSDate *)date type:(UTType *)type {
    SBXPreviewItemAttribute *attr = [[SBXPreviewItemAttribute alloc] init];
    attr.name = name;
    attr.isDir = isDir;
    attr.size = size;
    attr.lastUpdate = date;
    attr.type = type;
    return attr;
}

+ (NSArray<NSURLResourceKey> *)resourceKeys {
    return @[NSURLNameKey, NSURLIsDirectoryKey, NSURLFileSizeKey, NSURLContentModificationDateKey, NSURLContentTypeKey];
}

- (instancetype)init {
    self = [super init];
    return self;
}

@end
