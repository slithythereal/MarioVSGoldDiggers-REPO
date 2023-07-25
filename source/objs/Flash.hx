package objs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objs.GameSprite;

/**
 * a flash effect used for transitioning
 */
class Flash extends GameSprite
{
	public var flashTween:FlxTween;

	public function new()
	{
		super();
		makeGraphic(FlxG.width, FlxG.height);
		alpha = 0;
	}

	public function flash(flashTime:Float)
	{
		alpha = 1;
		flashTween = FlxTween.tween(this, {alpha: 0}, flashTime, {ease: FlxEase.linear});
	}
}
