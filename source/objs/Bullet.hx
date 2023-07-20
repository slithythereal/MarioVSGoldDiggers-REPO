package objs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
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
		FlxTween.tween(this, {x: 1000}, 0.25, {
			ease: FlxEase.linear
		});
	}

	override public function kill()
	{
		super.kill();
	}
}
