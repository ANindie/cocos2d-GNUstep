#import<Foundation/Foundation.h>
#import<Cocoa/Cocoa.h>

@interface UITouch :NSObject
{

 NSView * mView;
 NSPoint  mPoint;  


}

-(NSPoint)locationInView:(NSView*) view;
-(NSView*)view; 
-(void)setPoint:(NSPoint) inPoint;

-(id)initWithPoint:(NSPoint) point withView:(NSView*) view;


@end 

