//
//  ALAssetsLibrary category to handle a custom photo album
//
//  Created by Etay Luz on 10/26/11.
//  Copyright (c) 2011 Etay Luz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (CustomPhotoAlbum)

/*! Write the image data to the assets library (camera roll).
 *
 * \param image The target image to be saved
 * \param albumName Custom album name
 * \param completion Block to be executed when succeed to write the image data to the assets library (camera roll)
 * \param failure Block to be executed when failed to add the asset to the custom photo album
 */
-(void)saveImage:(UIImage *)image
         toAlbum:(NSString *)albumName
      completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
         failure:(ALAssetsLibraryAccessFailureBlock)failure;

/*! write the video to the assets library (camera roll).
 *
 * \param videoUrl The target video to be saved
 * \param albumName Custom album name
 * \param completion Block to be executed when succeed to write the image data to the assets library (camera roll)
 * \param failure block to be executed when failed to add the asset to the custom photo album
 */
-(void)saveVideo:(NSURL *)videoUrl
         toAlbum:(NSString *)albumName
      completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
         failure:(ALAssetsLibraryAccessFailureBlock)failure;

/*! Write the image data with meta data to the assets library (camera roll).
 * 
 * \param imageData The image data to be saved
 * \param albumName Custom album name
 * \param metadata Meta data for image
 * \param completion Block to be executed when succeed to write the image data
 * \param failure block to be executed when failed to add the asset to the custom photo album
 */
- (void)saveImageData:(NSData *)imageData
              toAlbum:(NSString *)albumName
             metadata:(NSDictionary *)metadata
           completion:(ALAssetsLibraryWriteImageCompletionBlock)completion
              failure:(ALAssetsLibraryAccessFailureBlock)failure;

@end