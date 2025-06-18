#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBXPreviewViewController: UIViewController

+(SBXPreviewViewController *)createWithSandboxUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
