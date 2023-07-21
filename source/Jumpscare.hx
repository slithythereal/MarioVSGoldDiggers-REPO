package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import substate.*;

class Jumpscare extends FlxState // messy code: feel free to fix it if you want -slithy
{
	var daWave:Int = 0;
	var daHookersElimd:Int = 0;
	var canUseMouse:Bool = false;
	var daJumpscareColor:FlxColor;
	var daHookerType:String = '';

	public function new(wave:Int, hookersKilled:Int, hookerType:String, jumpscareColor:FlxColor)
	{
		super();
		daWave = wave;
		daHookersElimd = hookersKilled;
		daHookerType = hookerType;
		daJumpscareColor = jumpscareColor;
	}

	override function create()
	{
		super.create();
		FlxG.camera.zoom = 1;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);
		bg.color = daJumpscareColor;

		var time:Float;
		var hooker:FlxSprite = new FlxSprite(31, 600);
		switch (daHookerType)
		{
			case 'bomb hooker':
				hooker.loadGraphic('assets/images/cringe bomb hooker.png', true, 106, 117);
				hooker.animation.add("idle", [0], 16);
				hooker.animation.add("explosivo", [3, 4, 5], 16, false);
				hooker.animation.add("explosivoLoop", [4, 5], 16, false);
				hooker.animation.add("explosivoEnd", [4, 5], 16, false);
				hooker.scale.set(5.5, 2.5);
				hooker.updateHitbox();
				add(hooker);
				hooker.animation.play("idle");

				FlxTween.tween(hooker, {y: 110}, 0.25, {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween)
					{
						new FlxTimer().start(0.425, function(tmr:FlxTimer)
						{
							hooker.scale.set(6.5, 3.5);
							FlxG.camera.shake(0.2, 2);
							hooker.animation.play("explosivo");
						});
					}
				});
				time = 2.25;

			default:
				hooker.loadGraphic('assets/images/cringe $daHookerType.png');
				hooker.scale.set(5.5, 2.5);
				hooker.updateHitbox();
				add(hooker);
				FlxG.camera.shake(0.05, 1.5);
				FlxTween.tween(hooker, {y: 110}, 0.25, {ease: FlxEase.linear});
				time = 1.75;
		}
		FlxG.sound.play('assets/sounds/${daHookerType}_jumpscare.ogg');

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			FlxTween.tween(FlxG.camera, {zoom: 50}, 1.5, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween)
				{
					var path:String = '';
					if (daHookerType == 'bomb hooker')
						path = 'assets/images/cringe bomb hooker BG.png';
					else
						path = 'assets/images/cringe $daHookerType.png';
					remove(hooker);

					var backdrop:FlxBackdrop = new FlxBackdrop('$path', 0.2, 0.2, true, true);
					backdrop.scale.set(0.5, 0.5);
					backdrop.alpha = 0.75;
					backdrop.velocity.set(90, 90);
					backdrop.updateHitbox();
					backdrop.screenCenter();
					add(backdrop);

					FlxTween.tween(FlxG.camera, {zoom: 1}, 1.5, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							var waveTxt:FlxTypeText = new FlxTypeText(35, 74, 0, 'WAVES BEATEN: ${daWave - 1}');
							waveTxt.setFormat(null, 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
							waveTxt.borderSize = 4;
							add(waveTxt);
							waveTxt.start(0.04, true);
							waveTxt.sounds = [
								// very crappy way to do this
								FlxG.sound.load('assets/sounds/type_1.ogg'),
								FlxG.sound.load('assets/sounds/type_2.ogg'),
								FlxG.sound.load('assets/sounds/type_3.ogg')
							];
							waveTxt.completeCallback = function()
							{
								var killTxt:FlxTypeText = new FlxTypeText(35, 114, 0, 'HOOKERS ELIMINATED: ${daHookersElimd}');
								killTxt.setFormat(null, 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
								killTxt.borderSize = 4;
								add(killTxt);
								killTxt.start(0.04, true);
								killTxt.sounds = waveTxt.sounds;
								killTxt.completeCallback = function()
								{
									canUseMouse = true;
									var dumbTxt:FlxText = new FlxText(25, 360, 0, "PRESS [MOUSEBUTTON] TO PLAY AGAIN");
									dumbTxt.setFormat(null, 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
									dumbTxt.borderSize = 4;
									add(dumbTxt);
									loadHighScores();
								}
							}
						}
					});
				}
			});
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canUseMouse)
		{
			if (FlxG.mouse.justPressed || FlxG.keys.anyJustPressed([SPACE, ENTER]))
				FlxG.switchState(new PlayState());
			if (FlxG.keys.justPressed.ESCAPE)
				openSubState(new OptionsSubState(false));
		}
	}

	function loadHighScores()
	{
		var wave_HIGHSCORETXT:FlxText = new FlxText(35, 200);
		wave_HIGHSCORETXT.setFormat(null, 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		wave_HIGHSCORETXT.borderSize = 2;
		if (FlxG.save.data.mostWaves == null || FlxG.save.data.mostWaves < daWave)
		{
			FlxG.save.data.mostWaves = daWave;
			wave_HIGHSCORETXT.text = 'NEW WAVE HIGHSCORE';
		}
		else
			wave_HIGHSCORETXT.text = 'WAVE HIGHSCORE: ${FlxG.save.data.mostWaves}';
		add(wave_HIGHSCORETXT);

		var kill_HIGHSCORETXT:FlxText = new FlxText(35, 275);
		kill_HIGHSCORETXT.setFormat(null, 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kill_HIGHSCORETXT.borderSize = 2;
		if (FlxG.save.data.mostKills == null || FlxG.save.data.mostKills < daHookersElimd)
		{
			FlxG.save.data.mostKills = daHookersElimd;
			kill_HIGHSCORETXT.text = 'NEW KILLED HOOKERS HIGHSCORE';
		}
		else
			kill_HIGHSCORETXT.text = 'HOOKERS ELIMINATED HIGHSCORE: ${FlxG.save.data.mostKills}';
		add(kill_HIGHSCORETXT);
	}
}
