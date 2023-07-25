package objs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * the game's `FlxSprite` replacement
 * 
 * extends off of the `FlxSprite` class with some new and useful functions
 */
class GameSprite extends FlxSprite
{
	// stolen from @sugarcoatedOwO on twitter :troll:
	public var _dynamic:Dynamic = {};

	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (_dynamic.update != null)
		{
			_dynamic.update(elapsed);
		}
	}

	public function scaleTween(startScale:Float, returnScale:Float, funnyease:(t:Float) -> Float, time:Float)
	{
		FlxTween.tween(this, {"scale.x": startScale, "scale.y": startScale}, time, {
			ease: funnyease,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(this, {"scale.x": returnScale, "scale.y": returnScale}, time, {ease: funnyease});
			}
		});
	}
}

/**
 * the game's `FlxText` replacement
 * 
 * extends off of the `FlxText` class with some new and useful functions
 */
class GameText extends FlxText
{
	public var _dynamic:Dynamic = {};

	public function new(?X:Float = 0, ?Y:Float = 0, ?FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (_dynamic.update != null)
		{
			_dynamic.update(elapsed);
		}
	}

	public function scaleTween(startScale:Float, returnScale:Float, funnyease:(t:Float) -> Float, time:Float)
	{
		FlxTween.tween(this, {"scale.x": startScale, "scale.y": startScale}, time, {
			ease: funnyease,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(this, {"scale.x": returnScale, "scale.y": returnScale}, time, {ease: funnyease});
			}
		});
	}
}
