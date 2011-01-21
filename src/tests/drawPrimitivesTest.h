
//CLASS INTERFACE
//@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIApplicationDelegate>
@interface AppController : NSObject < UIApplicationDelegate>
{
	UIWindow	*window;
}
@end

@interface TestDemo : CCLayer
{
}
-(NSString*) title;
@end

@interface Test1 : TestDemo
{}
@end
