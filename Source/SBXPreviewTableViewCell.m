#import "SBXPreviewTableViewCell.h"

@interface SBXPreviewTableViewCell ()

@property (nonatomic, strong) UILabel *fileNameLabel;
@property (nonatomic, strong) UILabel *updateDateLabel;
@property (nonatomic, strong) UIImageView *fileIconView;

@end

@implementation SBXPreviewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setupUI {
    self.fileNameLabel = [[UILabel alloc] init];
    self.fileNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fileNameLabel setTextColor:[UIColor labelColor]];
    [self.fileNameLabel setFont:[UIFont systemFontOfSize:16]];
    [self.fileNameLabel setNumberOfLines:0];
    [self.fileNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.fileNameLabel];
    
    self.updateDateLabel = [[UILabel alloc] init];
    self.updateDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.updateDateLabel setTextColor:[UIColor secondaryLabelColor]];
    [self.updateDateLabel setFont:[UIFont systemFontOfSize:14]];
    [self.updateDateLabel setNumberOfLines:0];
    [self.updateDateLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.updateDateLabel];
    
    self.fileIconView = [[UIImageView alloc] init];
    self.fileIconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fileIconView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.fileIconView];
    
    NSMutableArray *constraints = [NSMutableArray array];
        
    [constraints addObject:[self.fileIconView.widthAnchor constraintEqualToConstant:24]];
    [constraints addObject:[self.fileIconView.heightAnchor constraintEqualToConstant:24]];
    [constraints addObject:[self.fileIconView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]];
    [constraints addObject:[self.fileIconView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:16]];
    
    [constraints addObject:[self.fileNameLabel.leftAnchor constraintEqualToAnchor:self.fileIconView.rightAnchor constant:8]];
    [constraints addObject:[self.fileNameLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-16]];
    [constraints addObject:[self.fileNameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12]];
    
    [constraints addObject:[self.updateDateLabel.topAnchor constraintEqualToAnchor:self.fileNameLabel.bottomAnchor constant:8]];
    [constraints addObject:[self.updateDateLabel.leftAnchor constraintEqualToAnchor:self.fileNameLabel.leftAnchor]];
    [constraints addObject:[self.updateDateLabel.rightAnchor constraintEqualToAnchor:self.fileNameLabel.rightAnchor]];
    [constraints addObject:[self.updateDateLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-12]];
    
    [constraints addObject:[self.fileNameLabel.heightAnchor constraintGreaterThanOrEqualToConstant:20]];
    [constraints addObject:[self.updateDateLabel.heightAnchor constraintGreaterThanOrEqualToConstant:15]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupItemAttribute:(SBXPreviewItemAttribute *)attr {
    if (attr.isDir) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    [self.fileNameLabel setText:attr.name];
    [self.updateDateLabel setText:[self formattedDateStringFromDate:attr.lastUpdate]];
    
    UTType *fileType = attr.type;
    if (fileType) {
        NSDictionary *iconMap = [[self class] utTypeToIconMap];
        NSString *iconName = iconMap[fileType.identifier];
        [self.fileIconView setImage:[[UIImage systemImageNamed:iconName] imageWithTintColor:[UIColor tertiaryLabelColor] renderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
}

- (nullable NSString *)formattedDateStringFromDate:(nullable NSDate *)date {
    if (date) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [formatter stringFromDate:date];
    } else {
        return nil;
    }
}

+ (NSDictionary<NSString *, NSString *> *)utTypeToIconMap {
    static NSDictionary *iconMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iconMap = @{
            UTTypeFolder.identifier:            @"folder",
            UTTypeVolume.identifier:            @"externaldrive",
            UTTypePackage.identifier:           @"shippingbox",
            
            UTTypeText.identifier:              @"doc.plaintext",
            UTTypeRTF.identifier:               @"doc.richtext",
            UTTypePlainText.identifier:         @"doc.plaintext",
            UTTypePDF.identifier:               @"doc.richtext",
            UTTypeLog.identifier:               @"list.bullet.rectangle",
            
            [UTType typeWithFilenameExtension:@"doc"].identifier:  @"doc.text",
            [UTType typeWithFilenameExtension:@"docx"].identifier: @"doc.text",
            [UTType typeWithFilenameExtension:@"xls"].identifier:  @"tablecells",
            [UTType typeWithFilenameExtension:@"xlsx"].identifier: @"tablecells",
            [UTType typeWithFilenameExtension:@"ppt"].identifier:  @"chart.bar",
            [UTType typeWithFilenameExtension:@"pptx"].identifier: @"chart.bar",
            
            UTTypeImage.identifier:             @"photo",
            UTTypeJPEG.identifier:              @"photo",
            UTTypePNG.identifier:               @"photo",
            UTTypeGIF.identifier:               @"photo",
            UTTypeTIFF.identifier:              @"photo",
            UTTypeRAWImage.identifier:          @"camera",
            UTTypeLivePhoto.identifier:         @"livephoto",
            
            UTTypeAudio.identifier:             @"waveform",
            UTTypeMP3.identifier:               @"waveform",
            UTTypeAudiovisualContent.identifier:@"film",
            UTTypeMovie.identifier:             @"film",
            UTTypeQuickTimeMovie.identifier:    @"film",
            UTTypeMPEG.identifier:              @"film",
            
            UTTypeArchive.identifier:           @"doc.zipper",
//            UTTypeZipArchive.identifier:        @"doc.zipper",
            UTTypeData.identifier:              @"cylinder",
            UTTypeDatabase.identifier:          @"cylinder",
            UTTypeItem.identifier:              @"doc",
            UTTypeContent.identifier:           @"doc",
            UTTypeData.identifier:              @"doc",
            
            UTTypeSourceCode.identifier:        @"chevron.left.forwardslash.chevron.right",
            UTTypeSwiftSource.identifier:       @"swift",
            UTTypeObjectiveCSource.identifier:  @"c.square",
            UTTypeJavaScript.identifier:        @"javascript",
            
            UTTypeVCard.identifier:             @"person.crop.square",
            UTTypeContact.identifier:           @"person.crop.square",
            UTTypeCalendarEvent.identifier:     @"calendar",
            UTTypeURL.identifier:               @"link",
            UTTypeEmailMessage.identifier:      @"envelope",
            UTTypeInternetLocation.identifier:  @"globe"
        };
    });
    return iconMap;
}


@end
