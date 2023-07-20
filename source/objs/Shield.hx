package objs;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Shield extends FlxSprite
{
	public var isActive:Bool = false;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic('assets/images/shield.png');
		scale.set(8.5, 8.5);
		updateHitbox();
		antialiasing = false;
		alpha = 0.5;
		visible = false;
		centerOrigin();
	}

	public function shield()
	{
		isActive = true;
		PlayState.mario.isShielding = true;
		PlayState.mario.canShoot = false;
		visible = true;

		scaleTween(9.5, 8.5, FlxEase.quintInOut, 0.05);

		new FlxTimer().start(1, function(t:FlxTimer)
		{
			FlxTween.tween(this, {"scale.x": 0.1, "scale.y": 0.1}, 0.1, {
				ease: FlxEase.quintOut,
				onComplete: function(twn:FlxTween)
				{
					isActive = false;
					PlayState.mario.isShielding = false;
					PlayState.mario.canShoot = true;
					PlayState.mario.animation.play('idle');
					visible = false;
					scale.set(8.5, 8.5);
				}
			});
		});
	}
}
