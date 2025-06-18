#import <Foundation/Foundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBXPreviewItemAttribute: NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *name;
@property (nonatomic, assign, readonly) BOOL isDir;
@property (nonatomic, strong, readonly, nullable) NSNumber *size;
@property (nonatomic, strong, readonly, nullable) NSDate *lastUpdate;
@property (nonatomic, strong, readonly, nullable) UTType *type;

+(nullable instancetype)createWithFileUrl:(nonnull NSURL *)url;
+(NSArray<NSURLResourceKey> *)resourceKeys;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
