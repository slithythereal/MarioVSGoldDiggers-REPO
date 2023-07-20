package objs;

import flixel.FlxG;
import flixel.FlxSprite;

class Mario extends FlxSprite
{
	public var canShoot:Bool = false;
	public var isShielding:Bool = false;

	public function new(?x:Float, ?y:Float)
	{
		super(x, y);
		loadGraphic('assets/images/mario gun.png', true, 24, 16);
		animation.add('idle', [0], 24, false);
		animation.add('shoot', [1, 2, 3], 24, false);
		animation.play('idle');
		scale.set(7.5, 7.5);
		updateHitbox();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canShoot && FlxG.mouse.justPressed)
		{
			this.animation.play('shoot');
			this.animation.finishCallback = function(name:String)
			{
				this.animation.play('idle');
			};
		}
	}
}
