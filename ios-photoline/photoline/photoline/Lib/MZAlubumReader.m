//
//  MZAlubumReader.m
//  photoline
//
//  Created by Muhammed Salih on 01/11/15.
//  Copyright © 2015 Muhammed Salih T A. All rights reserved.
//

#import "MZAlubumReader.h"
@implementation MZAlubumReader


-(void)completePhotoFetch{
    _count++;
    if( (_assetGroups) &&_count >=[_assetGroups count]){
        [self sortPic];
        //Here Goes All Completed
        _succBlock(_ordermedia);
    }
}
-(UIImage *)getImage:(ALAsset *)alAsset{
    ALAssetRepresentation *representation = [alAsset defaultRepresentation];
    return  [UIImage imageWithCGImage:[representation fullScreenImage]];
}
-(void)getImage:(ALAsset *)alAsset :(void(^)( UIImage *image))response;
{
    ALAssetRepresentation *representation = [alAsset defaultRepresentation];
    response(  [UIImage imageWithCGImage:[representation fullScreenImage]]);
}

-(void)sortPic{
    _ordermedia =[[NSMutableArray alloc]init];
    NSArray *distinct = [self.media valueForKeyPath:@"@distinctUnionOfObjects.day"];
    distinct = [distinct sortedArrayUsingComparator:
                ^(id obj1, id obj2) {
                    return [obj2 compare:obj1];
                }];
    for(NSDate *dateAsString in distinct)
    {
        if(self.startdate && dateAsString<self.startdate ){
            return;
        }
        if(self.endDate && dateAsString>self.endDate ){
            return;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day == %@)", dateAsString];
        NSArray *arrayForTheSameDay = [_media  filteredArrayUsingPredicate: predicate];
        [_ordermedia addObject:arrayForTheSameDay];
    }
}
-(void)fetchImages{
    _media =[[NSMutableArray alloc]init];
    _count =0;
    for (ALAssetsGroup *group in _assetGroups) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset !=  nil) {
                // ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                // UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                [_media addObject:alAsset];
            }
            else{
                [self performSelectorOnMainThread:@selector(completePhotoFetch) withObject:nil waitUntilDone:YES];
            }
        }];
    }
}
-(void)fetchAlbums{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;
    _assetGroups=[[NSMutableArray alloc]init];
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       @autoreleasepool {
                           
                           // Group enumerator Block
                           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                           {
                               if (group == nil) {
                                   [self performSelectorOnMainThread:@selector(fetchImages) withObject:nil waitUntilDone:YES];
                                   return;
                               }
                               
                               // added fix for camera albums order
                               NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                               NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                               
                               if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                                   [self.assetGroups insertObject:group atIndex:0];
                               }
                               else if(_allAlbum) {
                                     [self.assetGroups addObject:group];
                               }
                               
                           };
                           
                           // Group Enumerator Failure Block
                           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                               if(_errorAlert){
                               if ( [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
                                   NSString *errorMessage = NSLocalizedString(@"This app does not have access to your photos or videos. You can enable access in Privacy Settings.", nil);
                                   [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access Denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                                   
                               } else {
                                   NSString *errorMessage = [NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]];
                                   [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                               }
                               }
                                NSLog(@"A problem occured %@", [error description]);
                           };
                           
                           // Enumerate Albums
                           [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                                       usingBlock:assetGroupEnumerator
                                                     failureBlock:assetGroupEnumberatorFailure];
                           
                       }
                   });
    
}
-(void)fetch:(success)handler{
    _succBlock = handler;
    [self fetchAlbums];
}

@end
