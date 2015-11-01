//
//  MZAlubumReader.h
//  photoline
//
//  Created by Muhammed Salih on 01/11/15.
//  Copyright © 2015 Muhammed Salih T A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import"ALAsset+ALAsset.h"
#import <UIKit/UIKit.h>
@interface MZAlubumReader : NSObject

@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, strong) NSMutableArray *media;
@property (nonatomic, strong) NSMutableArray *ordermedia;
@property (nonatomic, strong) NSDate *startdate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) Boolean *allAlbum;
@property (nonatomic) Boolean *errorAlert;
typedef void (^success)( NSMutableArray *response);
@property (nonatomic,strong) success succBlock;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic) NSInteger count;
-(void)fetch:(success)handler;
-(UIImage *)getImage:(ALAsset *)image;
-(void)getImage:(ALAsset *)alAsset :(void(^)( UIImage * image))response;

@end
