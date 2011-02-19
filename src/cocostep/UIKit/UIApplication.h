#import <AppKit/AppKit.h>


@protocol UIApplicationDelegate
@end

@protocol UIAccelerometerDelegate @end
@protocol UIAlertViewDelegate @end
@protocol UITextFieldDelegate @end




@interface UIScreen: NSWindow
{
}
-(NSRect)bounds;
+(UIScreen*)mainScreen;
@end 


@interface UIWindow: NSView
{
}

//dummy
-(BOOL) isUserInteractionEnabled;
-(void)setUserInteractionEnabled:(BOOL)status;
-(BOOL) isMultipleTouchEnabled;
-(void)setMultipleTouchEnabled:(BOOL)status;

-(void)makeKeyAndVisible;
-(NSView*)contentView;
@end 



@interface UIApplication: NSApplication
{
  UIScreen * mMainScreen;
}


+(UIApplication*)sharedApplication;


@end

                                                                            
#ifdef __cplusplus                                                           
  extern "C"  {                                                                                                         
#endif                                                                       
           
 
int UIApplicationMain(int argc,  char *argv[], id dummy, NSString * delegateName);

#ifdef __cplusplus                                                           
  } 
#endif                                                                       




