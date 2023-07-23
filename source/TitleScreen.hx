package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Lib;
import substate.*;

class TitleScreen extends FlxState
{
	var assetPath:String = 'assets/images/title';
	var bg:FlxSprite;

	public static var hasIntroCutscene:Bool = true;

	var canPress:Bool = false;

	var logo:FlxSprite;
	var startTxt:FlxText;

	override function create()
	{
		super.create();

		// crappy save data stuff, whoever fixes these gets added to update credits
		if (FlxG.save.data.startsIntroCutscene == null)
			FlxG.save.data.startsIntroCutscene = hasIntroCutscene;
		else
			hasIntroCutscene = FlxG.save.data.startsIntroCutscene;

		bg = new FlxSprite(0, 0).loadGraphic('$assetPath/7 11.png');
		add(bg);
		coolFunction('twnLogo');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (canPress)
		{
			if (FlxG.mouse.justPressed && canPress)
			{
				canPress = false;
				coolFunction('startGameTwn');
				FlxG.mouse.visible = false;
			}

			if (FlxG.keys.justPressed.ESCAPE)
				openSubState(new OptionsSubState(true));
		}
	}

	function coolFunction(daFunc:String)
	{
		switch (daFunc)
		{
			case 'twnLogo':
				logo = new FlxSprite(26, -180).loadGraphic('$assetPath/retroism.png');
				logo.antialiasing = false;
				logo.updateHitbox();
				logo._dynamic.update = function(elapsed:Float)
				{
					logo.updateHitbox();
				}
				add(logo);
				FlxTween.tween(logo, {y: 160}, 0.75, {
					ease: FlxEase.sineIn,
					onComplete: function(twn:FlxTween)
					{
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							logo.updateHitbox();
							FlxTween.tween(logo, {
								y: 40,
								x: 100,
								'scale.x': 0.75,
								'scale.y': 0.75
							}, 0.75, {
								ease: FlxEase.quartIn,
								onComplete: function(twn:FlxTween)
								{
									canPress = true;
									logo.updateHitbox();

									startTxt = new FlxText(120, 378, 0,
										'--Press [MOUSEBUTTON] to start--\n--Press [PLUS/MINUS] to change volume--\n--Press [ESCAPE] to open options--');
									startTxt.setFormat(null, 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
									startTxt.borderSize = 2;
									add(startTxt);
								}
							});
						});
					}
				});
			case 'startGameTwn':
				FlxTween.tween(startTxt, {y: 600}, 0.5, {ease: FlxEase.quintOut});
				FlxTween.tween(logo, {y: -600}, 0.5, {ease: FlxEase.quintOut});

				FlxG.sound.play('assets/sounds/hookerStartup_${FlxG.random.int(1, 3)}.ogg', 0.5);

				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					FlxG.sound.play('assets/sounds/marioStartup_${FlxG.random.int(1, 3)}.ogg', 0.25);
				});

				var hooker:FlxSprite = new FlxSprite(560, -232).loadGraphic('$assetPath/hooekr.png');
				hooker.angle = -15;
				hooker.scale.set(1.25, 1.25);
				add(hooker);

				var mario:FlxSprite = new FlxSprite(-346, 442).loadGraphic('$assetPath/mariogun.png');
				mario.angle = -15;
				mario.scale.set(12.5, 12.5);
				mario.updateHitbox();
				mario.antialiasing = false;
				add(mario);

				FlxTween.tween(hooker, {x: 275, y: 63}, 2.5, {ease: FlxEase.quartOut});
				FlxTween.tween(mario, {x: 18, y: 203}, 2, {ease: FlxEase.quartOut});
				FlxTween.tween(bg, {'scale.x': 2.0, 'scale.y': 2.0}, 5, {ease: FlxEase.quartOut});

				new FlxTimer().start(2.5, function(tmr:FlxTimer)
				{
					FlxTween.tween(FlxG.camera, {zoom: 10}, 2.5, {ease: FlxEase.backOut});
					FlxTween.tween(FlxG.camera, {alpha: 0}, 2.5, {
						ease: FlxEase.backOut,
						onComplete: function(twn:FlxTween)
						{
							new FlxTimer().start(1.5, function(tmr:FlxTimer)
							{
								if (hasIntroCutscene)
									FlxG.switchState(new CutsceneState("Intro"));
								else
									FlxG.switchState(new PlayState());
							});
						}
					});
				});
		}
	}
}
