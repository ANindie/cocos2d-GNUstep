/* TouchesTest (c) Valentin Milea 2009
 */
#import "cocos2d.h"

@class Paddle;

@interface Ball : CCSprite {
@private
	CGPoint velocity;
}
DeclareProperty_rw_as_na(CGPoint,velocity,Velocity);
DeclareProperty_ro_as_na(float,radius,Radius);


+ (id)ballWithTexture:(CCTexture2D *)texture;

- (void)move:(ccTime)delta;
- (void)collideWithPaddle:(Paddle *)paddle;
@end
