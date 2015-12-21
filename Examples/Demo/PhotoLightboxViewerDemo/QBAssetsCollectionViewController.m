//
//  QBAssetsCollectionViewController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewController.h"

// Views
#import "QBAssetsCollectionViewCell.h"
#import "QBAssetsCollectionFooterView.h"

@interface QBAssetsCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;
@property (nonatomic, assign) NSInteger numberOfNewPhotos;
@property (nonatomic, assign) NSInteger numberOfNewVideos;

@end

@implementation QBAssetsCollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        // View settings
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        // Register cell class
        [self.collectionView registerClass:[QBAssetsCollectionViewCell class]
                forCellWithReuseIdentifier:@"AssetsCell"];
        [self.collectionView registerClass:[QBAssetsCollectionFooterView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:@"FooterView"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Scroll to bottom --- iOS 7 differences
    CGFloat topInset;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        topInset = ((self.edgesForExtendedLayout && UIRectEdgeTop) && (self.collectionView.contentInset.top == 0)) ? (20.0 + 44.0) : 0.0;
    } else {
        topInset = (self.collectionView.contentInset.top == 0) ? (20.0 + 44.0) : 0.0;
    }
    
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.collectionViewLayout.collectionViewContentSize.height - self.collectionView.frame.size.height + topInset)
                                 animated:NO];
    
    // Validation
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.imagePickerController.selectedAssetURLs.count];
    }
}


#pragma mark - Accessors

- (void)setFilterType:(QBImagePickerControllerFilterType)filterType
{
    _filterType = filterType;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Set title
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    // Get the number of photos and videos
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    self.numberOfPhotos = self.assetsGroup.numberOfAssets;
    self.numberOfNewPhotos = 0;
    
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
    self.numberOfVideos = self.assetsGroup.numberOfAssets;
    self.numberOfNewVideos = 0;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
    
    // Load assets
    self.assets = [NSMutableArray array];
    
    //__weak typeof(self) weakSelf = self;
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.assets addObject:result];
        }
    }];
    
    // Update view
    [self.collectionView reloadData];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    self.collectionView.allowsMultipleSelection = allowsMultipleSelection;
    
    // Show/hide done button
    if (allowsMultipleSelection) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (BOOL)allowsMultipleSelection
{
    return self.collectionView.allowsMultipleSelection;
}


#pragma mark - Actions

- (void)done:(id)sender
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewControllerDidFinishSelection:)]) {
        [self.delegate assetsCollectionViewControllerDidFinishSelection:self];
    }
}


#pragma mark - Managing Selection

- (void)selectAssetHavingURL:(NSURL *)URL
{
    for (NSInteger i = 0; i < self.assets.count; i++) {
        ALAsset *asset = [self.assets objectAtIndex:i];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        
        if ([assetURL isEqual:URL]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            return;
        }
    }
}


#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        return (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return YES;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsGroup.numberOfAssets;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QBAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetsCell" forIndexPath:indexPath];
    [cell clearButtons];   // clear button from cell...
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    NSString * mediaType = [asset valueForProperty:ALAssetPropertyType];
    
    cell.showsOverlayViewWhenSelected = self.allowsMultipleSelection;
    cell.asset = asset;

   BOOL _video = FALSE;
    
    // NSLog(@"asset media type is %@", mediaType);
    if ([mediaType isEqualToString:ALAssetTypeVideo]) {
        [cell markVideo:TRUE];
        _video = TRUE;
        //NSLog(@"asset is a video - %@", asset);

    } else {
        [cell markVideo:FALSE];
        _video = FALSE;
        //NSLog(@"asset is a photo - %@", asset);
    }
    
    // mark new assets...
    if ([self isAssetNew:asset]) {
        //NSLog(@"mark NEW...");
        [cell markNew:TRUE];
        
        if (_video) {
            ++self.numberOfNewVideos;
            //NSLog(@"asset is a new video - %@", asset);
        } else {
            ++self.numberOfNewPhotos;
            //NSLog(@"asset is a new photo - %@", asset);
        }
        
    } else {
        //NSLog(@"mark not NEW...");
        [cell markNew:FALSE];
    }
    
    return cell;
}

- (BOOL)isAssetNew:(ALAsset *)asset
{
    BOOL result = FALSE;
    
    NSDate * theDate = [asset valueForProperty:ALAssetPropertyDate];
    
    if (theDate == nil) {
        //NSLog(@"1theDate is nil so skipping...");
        
        return result;
    }
    
    NSInteger dayDiff = (int)[theDate timeIntervalSinceNow] / (60*60*24);
    
    /**
     if (self.newMediaAge == 3)
        NSLog(@"new media is from today, yesterday or day before yesterday...");
    else if (self.newMediaAge == 2)
        NSLog(@"new media is from today or yesterday..");
    else if (self.newMediaAge == 1)
        NSLog(@"new media is from today...");
    **/

    //NSLog(@"checking asset %@ for new date %@...", asset, theDate);
    //NSLog(@"day diff is %d", dayDiff);
    
    // if today, always want it...
    if (dayDiff == 0) {
        //NSLog(@"%@ (%@) is from today...", asset, theDate);
        result = TRUE;
        
    // if yesterday, want if 'today or yesterday' OR 'today, yesterday or day before yesterday'
    } else if (dayDiff == -1 && (self.newMediaAge == 2 || self.newMediaAge == 3)) {
        //NSLog(@"%@ (%@) is from yesterday...", asset, theDate);
        result = TRUE;
        
    // if day before yesterday, want if 'day before yesterday'
    } else if (dayDiff == -2 && self.newMediaAge == 3) {
        //NSLog(@"%@ (%@) is from day before yesterday...", asset, theDate);
        result = TRUE;
        
    } else {
        // NSLog(@"%@ (%@) from %d days ago...", dayDiff, asset, theDate);
    }
    
    return result;
}

- (NSDate *)getYesterday {
	NSDate * yesterday = nil;
	
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
	yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 7)];
	NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
	NSDate *thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    //NSLog(@"yesterday=%@",yesterday);
	
	return yesterday;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 46.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        QBAssetsCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                      withReuseIdentifier:@"FooterView"
                                                                                             forIndexPath:indexPath];
        
        switch (self.filterType) {
            case QBImagePickerControllerFilterTypeNone:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_photos_and_videos",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfPhotos,
                                             self.numberOfVideos,
                                             self.numberOfNewPhotos,
                                             self.numberOfNewVideos
                                             ];
                
                break;
                
            case QBImagePickerControllerFilterTypePhotos:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_photos",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfPhotos,
                                             self.numberOfNewPhotos
                                             ];
                break;
                
            case QBImagePickerControllerFilterTypeVideos:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_videos",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfVideos,
                                             self.numberOfNewVideos
                                             ];
                break;
        }
        
        return footerView;
    }
    
    return nil;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(77.5, 77.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self validateMaximumNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    // Validation
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didSelectAsset:)]) {
        [self.delegate assetsCollectionViewController:self didSelectAsset:asset];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    // Validation
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count - 1)];
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didDeselectAsset:)]) {
        [self.delegate assetsCollectionViewController:self didDeselectAsset:asset];
    }
}

@end
