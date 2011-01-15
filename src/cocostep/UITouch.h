#import<Foundation/Foundation.h>
#import<Cocoa/Cocoa.h>

@interface UITouch :NSObject
{

 NSView * mView;
 NSEvent*  mEvent;  


}

-(NSPoint)locationInView:(NSView*) view;
-(NSView*)view; 


-(id)initWithPoint:(NSEvent*) point withView:(NSView*) view;


@end 

