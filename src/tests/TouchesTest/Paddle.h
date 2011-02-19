/* TouchesTest (c) Valentin Milea 2009
 */ 
#import "cocos2d.h"

typedef enum tagPaddleState {
	kPaddleStateGrabbed,
	kPaddleStateUngrabbed
} PaddleState;

@interface Paddle : CCSprite <CCTargetedTouchDelegate> {
@private
	PaddleState state;
}

DeclareProperty_ro_as_na(CGRect,rect,rect);


+ (id)paddleWithTexture:(CCTexture2D *)texture;
@end
