#import "SBXPreviweDefine.h"
#import "SBXPreviewItemAttribute.h"
#import "SBXPreviewViewController.h"
#import "SBXPreviewTableViewCell.h"

@interface SBXPreviewViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSURL *currentUrl;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<SBXPreviewItemAttribute *> *subpaths;

@property (nonatomic, assign) BOOL showHiddenFiles;

@end

@implementation SBXPreviewViewController

#pragma mark - Convenience init

+ (SBXPreviewViewController *)createWithSandboxUrl:(NSURL *)url {
    SBXPreviewViewController *vc = [[SBXPreviewViewController alloc] init];
    vc.currentUrl = url;
    return vc;
}

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showHiddenFiles = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadSubpaths];
}

#pragma mark - UI

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[SBXPreviewTableViewCell class] forCellReuseIdentifier:SBXPreviewTableViewCellName];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

#pragma mark - Data process

- (void)loadSubpaths {
    NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationProducesRelativePathURLs;
    if (!self.showHiddenFiles) {
        options = NSDirectoryEnumerationSkipsHiddenFiles | options;
    }
    NSArray<NSURLResourceKey> *keys = @[NSURLNameKey, NSURLIsDirectoryKey, NSURLFileSizeKey, NSURLContentModificationDateKey, NSURLContentTypeKey];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:self.currentUrl includingPropertiesForKeys:keys options:options errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
        NSLog(@"Enumerate error at %@, %@", url, error.localizedDescription);
        return YES;
    }];
    
    NSMutableArray<SBXPreviewItemAttribute *> *attrs = [NSMutableArray array];
    for (NSURL *fileUrl in enumerator) {
        SBXPreviewItemAttribute *attr = [SBXPreviewItemAttribute createWithFileUrl:fileUrl];
        if (attr) {
            [attrs addObject:attr];
        }
    }
    self.subpaths = [attrs copy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subpaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBXPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SBXPreviewTableViewCellName forIndexPath:indexPath];
    SBXPreviewItemAttribute *attr = self.subpaths[indexPath.row];
    [cell setupItemAttribute:attr];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SBXPreviewItemAttribute *attr = self.subpaths[indexPath.row];
    NSURL *newUrl = [self.currentUrl URLByAppendingPathComponent:attr.name isDirectory:attr.isDir];
    
    if (attr.isDir) {
        SBXPreviewViewController *vc = [SBXPreviewViewController createWithSandboxUrl:newUrl];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // TODO: Share view controller
    }
    
}


@end
