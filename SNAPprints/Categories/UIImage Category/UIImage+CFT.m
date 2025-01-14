//
//  UIImage+CFT.m
//  SNAPprints
//
//  Created by Etay Luz on 10/19/13.
//  Copyright (c) 2013 Etay Luz. All rights reserved.
//

#import "UIImage+CFT.h"

CGFloat DegreesToRadians(CGFloat degrees) { return degrees * M_PI / 180; };
CGFloat RadiansToDegrees(CGFloat radians) { return radians * 180 / M_PI; };

@implementation UIImage (CFT)

- (UIImage *)crop:(CGRect)rect {

  rect =
      CGRectMake(rect.origin.x * self.scale, rect.origin.y * self.scale,
                 rect.size.width * self.scale, rect.size.height * self.scale);

  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef
                                        scale:self.scale
                                  orientation:self.imageOrientation];
  CGImageRelease(imageRef);
  return result;
}

// http://www.catamount.com/forums/viewtopic.php?f=21&t=967
- (UIImage *)imageAtRect:(CGRect)rect {

  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *subImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);

  return subImage;
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {

  UIImage *sourceImage = self;
  UIImage *newImage = nil;

  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;

  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;

  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;

  CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {

    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;

    if (widthFactor > heightFactor)
      scaleFactor = widthFactor;
    else
      scaleFactor = heightFactor;

    scaledWidth = width * scaleFactor;
    scaledHeight = height * scaleFactor;

    // center the image

    if (widthFactor > heightFactor) {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    } else if (widthFactor < heightFactor) {
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
  }

  // this is actually the interesting part:

  UIGraphicsBeginImageContext(targetSize);

  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width = scaledWidth;
  thumbnailRect.size.height = scaledHeight;

  [sourceImage drawInRect:thumbnailRect];

  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  if (newImage == nil)
    NSLog(@"could not scale image");

  return newImage;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {

  UIImage *sourceImage = self;
  UIImage *newImage = nil;

  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;

  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;

  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;

  CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {

    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;

    if (widthFactor < heightFactor)
      scaleFactor = widthFactor;
    else
      scaleFactor = heightFactor;

    scaledWidth = width * scaleFactor;
    scaledHeight = height * scaleFactor;

    // center the image

    if (widthFactor < heightFactor) {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    } else if (widthFactor > heightFactor) {
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
  }

  // this is actually the interesting part:

  UIGraphicsBeginImageContext(targetSize);

  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width = scaledWidth;
  thumbnailRect.size.height = scaledHeight;

  [sourceImage drawInRect:thumbnailRect];

  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  if (newImage == nil)
    NSLog(@"could not scale image");

  return newImage;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {

  UIImage *sourceImage = self;
  UIImage *newImage = nil;

  //   CGSize imageSize = sourceImage.size;
  //   CGFloat width = imageSize.width;
  //   CGFloat height = imageSize.height;

  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;

  //   CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;

  CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

  // this is actually the interesting part:

  UIGraphicsBeginImageContext(targetSize);

  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width = scaledWidth;
  thumbnailRect.size.height = scaledHeight;

  [sourceImage drawInRect:thumbnailRect];

  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  if (newImage == nil)
    NSLog(@"could not scale image");

  return newImage;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians {
  return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
  // calculate the size of the rotated view's containing box for our drawing
  // space
  UIView *rotatedViewBox = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
  CGAffineTransform t =
      CGAffineTransformMakeRotation(DegreesToRadians(degrees));
  rotatedViewBox.transform = t;
  CGSize rotatedSize = rotatedViewBox.frame.size;

  // Create the bitmap context
  UIGraphicsBeginImageContext(rotatedSize);
  CGContextRef bitmap = UIGraphicsGetCurrentContext();

  // Move the origin to the middle of the image so we will rotate and scale
  // around the center.
  CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);

  //   // Rotate the image context
  CGContextRotateCTM(bitmap, DegreesToRadians(degrees));

  // Now, draw the rotated/scaled image into the context
  CGContextScaleCTM(bitmap, 1.0, -1.0);
  CGContextDrawImage(bitmap,
                     CGRectMake(-self.size.width / 2, -self.size.height / 2,
                                self.size.width, self.size.height),
                     [self CGImage]);

  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage *)imageByCorrectingOrientation {

  // No-op if the orientation is already correct
  if (self.imageOrientation == UIImageOrientationUp)
    return self;

  // We need to calculate the proper transformation to make the image upright.
  // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
  CGAffineTransform transform = CGAffineTransformIdentity;

  switch (self.imageOrientation) {
  case UIImageOrientationDown:
  case UIImageOrientationDownMirrored:
    transform = CGAffineTransformTranslate(transform, self.size.width,
                                           self.size.height);
    transform = CGAffineTransformRotate(transform, M_PI);
    break;

  case UIImageOrientationLeft:
  case UIImageOrientationLeftMirrored:
    transform = CGAffineTransformTranslate(transform, self.size.width, 0);
    transform = CGAffineTransformRotate(transform, M_PI_2);
    break;

  case UIImageOrientationRight:
  case UIImageOrientationRightMirrored:
    transform = CGAffineTransformTranslate(transform, 0, self.size.height);
    transform = CGAffineTransformRotate(transform, -M_PI_2);
    break;
  case UIImageOrientationUp:
  case UIImageOrientationUpMirrored:
    break;
  }

  switch (self.imageOrientation) {
  case UIImageOrientationUpMirrored:
  case UIImageOrientationDownMirrored:
    transform = CGAffineTransformTranslate(transform, self.size.width, 0);
    transform = CGAffineTransformScale(transform, -1, 1);
    break;

  case UIImageOrientationLeftMirrored:
  case UIImageOrientationRightMirrored:
    transform = CGAffineTransformTranslate(transform, self.size.height, 0);
    transform = CGAffineTransformScale(transform, -1, 1);
    break;
  case UIImageOrientationUp:
  case UIImageOrientationDown:
  case UIImageOrientationLeft:
  case UIImageOrientationRight:
    break;
  }

  // Now we draw the underlying CGImage into a new context, applying the
  // transform
  // calculated above.
  CGContextRef ctx = CGBitmapContextCreate(
      NULL, self.size.width, self.size.height,
      CGImageGetBitsPerComponent(self.CGImage), 0,
      CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
  CGContextConcatCTM(ctx, transform);
  switch (self.imageOrientation) {
  case UIImageOrientationLeft:
  case UIImageOrientationLeftMirrored:
  case UIImageOrientationRight:
  case UIImageOrientationRightMirrored:
    // Grr...
    CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width),
                       self.CGImage);
    break;

  default:
    CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height),
                       self.CGImage);
    break;
  }

  // And now we just create a new UIImage from the drawing context
  CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
  UIImage *img = [UIImage imageWithCGImage:cgimg];
  CGContextRelease(ctx);
  CGImageRelease(cgimg);
  return img;
}

/*
-(UIImage*)imageByCorrectingOrientation
{
    CGImageRef imgRef = self.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),
CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            return self;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width,
imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height,
imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid
image orientation"];

    }
    // Create the bitmap context
    CGContextRef    context = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;

    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (bounds.size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * bounds.size.height);
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        return nil;
    }

    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imgRef);
    context = CGBitmapContextCreate
(bitmapData,bounds.size.width,bounds.size.height,8,bitmapBytesPerRow,
                                     colorspace, kCGBitmapAlphaInfoMask &
kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorspace);

    if (context == NULL)
        // error creating context
        return nil;

    CGContextScaleCTM(context, -1.0, -1.0);
    CGContextTranslateCTM(context, -bounds.size.width, -bounds.size.height);

    CGContextConcatCTM(context, transform);

    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context, CGRectMake(0,0,width, height), imgRef);

    CGImageRef imgRef2 = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    free(bitmapData);
    UIImage * image = [UIImage imageWithCGImage:imgRef2 scale:self.scale
orientation:UIImageOrientationUp];
    CGImageRelease(imgRef2);
    return image;
}
 */

@end
