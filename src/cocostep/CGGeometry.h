#import <Foundation/NSGeometry.h>


typedef NSRect CGRect;
typedef NSPoint CGPoint;
typedef NSSize CGSize;


typedef NSAffineTransformStruct CGAffineTransform;


#define CGPointFromString NSPointFromString
#define CGRectFromString NSRectFromString
#define CGSizeFromString NSSizeFromString
#define CGRectMake NSMakeRect
#define CGPointMake NSMakePoint
#define CGSizeMake NSMakeSize
#define CGSizeZero NSZeroSize
#define CGPointZero NSZeroPoint
#define CGRectZero NSZeroRect

#define CGPointEqualToPoint NSEqualPoints  

#define CGSizeEqualToSize NSEqualSizes


CGAffineTransform CS_CGAffineTransformRotate(CGAffineTransform transform_ , CGFloat rotation_);
CGAffineTransform CS_CGAffineTransformScale(CGAffineTransform transform_ , CGFloat scaleX_, CGFloat scaleY);
CGAffineTransform CS_CGAffineTransformConcat(CGAffineTransform a,CGAffineTransform b);
CGAffineTransform CS_CGAffineTransformInvert( CGAffineTransform inCGAffineTransform);
CGAffineTransform CS_CGAffineTransformMake(float a,float b,float c,float d,float tx,float ty);
CGAffineTransform CS_CGAffineTransformTranslate(CGAffineTransform transform_, CGFloat anchorPointInPixelsx, CGFloat anchorPointInPixelsy);


CGPoint CS_CGPointApplyAffineTransform(CGPoint point,CGAffineTransform transform) ;
CGSize  CS_CGSizeApplyAffineTransform(CGSize point,CGAffineTransform transform) ;
CGRect  CS_CGRectApplyAffineTransform(CGRect point,CGAffineTransform transform) ;




#define  CGAffineTransformRotate(transform_ ,  rotation_) CS_CGAffineTransformRotate( transform_ ,  rotation_)
#define CGAffineTransformScale( transform_ ,  scaleX_,  scaleY)  CS_CGAffineTransformScale( transform_ ,  scaleX_,  scaleY)
#define CGAffineTransformConcat( a, b) CS_CGAffineTransformConcat(a,b)
#define CGAffineTransformInvert(inCGAffineTransform) CS_CGAffineTransformInvert(inCGAffineTransform)
#define CGAffineTransformMake( a, b, c, d, tx, ty)  CS_CGAffineTransformMake( a, b, c, d, tx, ty)

#define CGAffineTransformTranslate( transform_,  anchorPointInPixelsx,  anchorPointInPixelsy) CS_CGAffineTransformTranslate(transform_,  anchorPointInPixelsx,  anchorPointInPixelsy)

#define CGPointApplyAffineTransform  CS_CGPointApplyAffineTransform
#define CGSizeApplyAffineTransform CS_CGSizeApplyAffineTransform
#define CGRectApplyAffineTransform CS_CGRectApplyAffineTransform




 extern CGAffineTransform CGAffineTransformIdentity;


enum 
{
kEAGLColorFormatRGBA8,
kEAGLColorFormatRGB,
kEAGLColorFormatRGB565
};

enum {
UIInterfaceOrientationPortrait,
UIInterfaceOrientationLandscapeRight,
UIInterfaceOrientationLandscapeLeft,
};


#define CGRectContainsPoint(rect,point)  NSPointInRect(point,rect) 

#define NSUIntegerMax  INT32_MAX
