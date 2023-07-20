package objs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Flash extends FlxSprite // why not
{
	public function new()
	{
		super();
		makeGraphic(FlxG.width, FlxG.height);
		alpha = 0;
	}

	public function flash(flashTime:Float)
	{
		alpha = 1;
		FlxTween.tween(this, {alpha: 0}, flashTime, {ease: FlxEase.linear});
	}
}
