package objs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objs.GameSprite;

/**
 * the bullet projectile that kills enemy hookers
 */
class Bullet extends GameSprite
{
	public var bulletTween:FlxTween;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		makeGraphic(14, 4, FlxColor.YELLOW);
		#if !NO_WAVES
		shootBullet();
		#end
	}

	public function shootBullet()
	{
		bulletTween = FlxTween.tween(this, {x: 1000}, 0.25, {
			ease: FlxEase.linear
		});
	}

	override public function destroy()
	{
		super.destroy();
	}
}
