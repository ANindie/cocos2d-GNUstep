#import<Foundation/Foundation.h>
#import<Cocoa/Cocoa.h>

@interface UITouch :NSObject
{

 NSView * mView;
 NSPoint  mPoint; 
 NSPoint  mLastPoint;	


}
- (NSPoint)previousLocationInView:(NSView *)view;
-(NSPoint)locationInView:(NSView*) view;
-(NSView*)view; 
-(void)setPoint:(NSPoint) inPoint;

-(id)initWithPoint:(NSPoint) point withView:(NSView*) view;


@end 

