package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class YouNeedaUpdateLOL extends FlxState
{
	var assetPath:String = 'assets/images/youneedaupdateLOL';
	var canPress:Bool = false;

	public function new()
	{
		super();
	}

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/title/7 11.png');
		bg.flipX = true;
		add(bg);

		var mario:FlxSprite = new FlxSprite(190, 150).loadGraphic('$assetPath/LMARIO.png');
		mario.antialiasing = false;
		mario.scale.set(20.5, 20.5);
		mario.updateHitbox();
		add(mario);

		var pointFinger:FlxSprite = new FlxSprite(317, 247).loadGraphic('$assetPath/LOLhand.png');
		add(pointFinger);

		var lmaoTxt:FlxText = new FlxText(0, 0, FlxG.width, "xddxdd\nLOOK WHO NEEDS TO UPDATE\nxddxddd");
		lmaoTxt.setFormat(null, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		lmaoTxt.borderSize = 4;
		add(lmaoTxt);
		CommandData.watch(lmaoTxt);

		var lmaoSound:FlxSound = new FlxSound().loadEmbedded('assets/sounds/LOL.ogg');
		lmaoSound.play();
		lmaoSound.onComplete = function()
		{
			trace("opened link");
			canPress = true;
			FlxG.openURL('https://slithythereal.itch.io/mvgd');

			var youcangonow:FlxText = new FlxText(75, 378, 0, "Press [MOUSEBUTTON, SPACE, OR ENTER] to continue");
			youcangonow.setFormat(null, 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			youcangonow.borderSize = 2;
			add(youcangonow);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canPress)
		{
			if (FlxG.keys.anyJustPressed([ENTER, SPACE]) || FlxG.mouse.justPressed)
			{
				canPress = false;
				var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				add(black);

				var mvgdLOGO:FlxSprite = new FlxSprite(25, 140).loadGraphic('assets/images/title/retroism.png');
				add(mvgdLOGO);
				CommandData.watch(mvgdLOGO);
				FlxTween.tween(mvgdLOGO, {alpha: 0, "scale.x": 0.25, "scale.y": 0.25}, 2.5, {
					ease: FlxEase.circOut,
					onComplete: function(twn:FlxTween)
					{
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							FlxG.switchState(new TitleScreen());
						});
					}
				});
			}
		}
	}
}
