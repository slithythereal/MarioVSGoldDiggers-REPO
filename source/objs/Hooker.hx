package objs;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Hooker extends FlxSprite
{
	public var daHookerType:String;
	public var jumpscareColor:FlxColor;
	public var daHealth:Int = 1;
	public var isConditional:Bool; // tells game if hooker counts as part of a wave
	public var funnyPogoHeight:Float = 1.2;
	public var hookerTween:FlxTween;

	final GRAVITY:Int = 1200;

	public function new(?x:Float, ?y:Float, ?hookerType:String, ?isHookerConditional:Bool)
	{
		super();
		daHookerType = hookerType;
		isConditional = isHookerConditional;

		// EXTREMELY MESSY - fix the switch statements and you get added to the update's credits -slithy
		switch (hookerType)
		{
			case 'bomb hooker':
				super.x = FlxG.random.float(490, 575);
				super.y = y;
			default:
				super.x = x;
				super.y = y;
		}
		switch (hookerType)
		{
			case 'bomb hooker':
				jumpscareColor = 0xff00660e;
				daHealth = 1;
			case 'pogo hooker':
				jumpscareColor = FlxColor.CYAN;
				daHealth = 2;
				acceleration.y = GRAVITY * 1.5;
				this.y = y - 100;
			case 'buff hooker':
				jumpscareColor = FlxColor.PURPLE;
				daHealth = 3;
			case 'piggie':
				jumpscareColor = FlxColor.GREEN;
				daHealth = 1;
			default:
				jumpscareColor = FlxColor.RED;
				daHealth = 1;
		}
		switch (hookerType)
		{
			case 'bomb hooker':
				loadGraphic('assets/images/cringe bomb hooker.png', true, 106, 117);
				animation.add("idle", [0, 1, 2], 16);
				animation.add("explosivo", [3, 4, 5], 16);
				animation.play("idle");
			default:
				loadGraphic('assets/images/cringe $hookerType.png');
		}
		scale.set(1, 1);
		updateHitbox();

		#if !NO_WAVES
		switch (hookerType)
		{
			case 'bomb hooker':
				trace("has no tween lol");
			case 'pogo hooker':
				hookerTween = FlxTween.tween(this, {x: 21}, FlxG.random.float(2, 3), {ease: FlxEase.linear});
			case 'buff hooker':
				hookerTween = FlxTween.tween(this, {x: 21}, FlxG.random.float(1.5, 3.5), {ease: FlxEase.linear});
			default:
				if (isHookerConditional)
					hookerTween = FlxTween.tween(this, {x: 21}, FlxG.random.float(0.50, 5), {ease: FlxEase.linear});
				else
					hookerTween = FlxTween.tween(this, {x: 21}, FlxG.random.float(1.75, 5), {ease: FlxEase.linear});
		}
		#end
	}

	override public function update(elapsed:Float)
	{
		if (daHookerType == 'pogo hooker')
			pogoJump();
		super.update(elapsed);
	}

	public function die()
	{
		if (daHookerType == 'piggie')
			FlxG.sound.play('assets/sounds/piggieDeath.ogg');
		kill();
	}

	override public function kill()
	{
		super.kill();
	}

	function pogoJump()
	{
		if (isTouching(FlxObject.FLOOR))
		{
			velocity.y = -GRAVITY / funnyPogoHeight;
		}
	}
}
