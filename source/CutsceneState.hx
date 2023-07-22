package;

import data.Jsons.CutscData;
import data.Jsons.CutscJson;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.Assets;
import sys.FileSystem;
import sys.io.File;

class CutsceneState extends FlxState // TODO: make frames and work on this
{
	var cutsceneName:String;
	var cutSpr:FlxSprite;
	var curFrame:Int = 1;
	var maxFrames:Int = 1;
	var frameEvents:Array<Array<Dynamic>> = [[]];
	var framesWEvents:Array<Int> = [];
	var curEventFrame:Int = 0;
	var canPress:Bool = true;
	var daEvent:String = '';
	var value2:Dynamic;
	var finalEvent:String = '';

	public function new(?cutscene:String = 'Intro')
	{
		super();
		cutsceneName = cutscene;
	}

	override function create()
	{
		super.create();

		loadJson(cutsceneName);

		cutSpr = new FlxSprite();
		cutSpr._dynamic.nextFrame = function(frame:Int, upFrame:Bool)
		{
			if (upFrame)
				curFrame += frame;
			cutSpr.loadGraphic('assets/images/cutscenes/$cutsceneName/${cutsceneName}_$curFrame.png');
			if (curFrame == framesWEvents[curEventFrame])
			{
				funyEvents('${frameEvents[curEventFrame][1]}');
				curEventFrame += 1;
			}
		}
		cutSpr._dynamic.nextFrame(curFrame, false);
		cutSpr.screenCenter();
		add(cutSpr);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed && canPress)
		{
			if (curFrame >= maxFrames)
				funyEvents('$finalEvent');
			else
				cutSpr._dynamic.nextFrame(1, true);
		}
	}

	function loadJson(json:String)
	{
		var jsonData:CutscData = CutscJson.loadJson('$cutsceneName');
		if (jsonData == null)
		{
			jsonData = {
				frameAmt: 2,
				withEvents: 0,
				// frame, event, the rest are values for said event
				eventsArray: [[null]],
				// final event to close the cutscene
				endEvent: ""
			}
		}
		maxFrames = jsonData.frameAmt;
		finalEvent = jsonData.endEvent;
		if (jsonData.withEvents >= 1)
		{
			frameEvents = jsonData.eventsArray;
			for (i in 0...jsonData.withEvents)
				framesWEvents.push(frameEvents[i][0]);
		}
	}

	function funyEvents(event:String) // whoever fixes these gets added to the update's credits -slithy
	{
		switch (event)
		{
			// funytransition
			case 'frame10Trans':
				canPress = false;
				FlxG.sound.playMusic('assets/sounds/cutscenes/Intro/mario talking.ogg');
				new FlxTimer().start(0.4, function(tmr:FlxTimer)
				{
					cutSpr._dynamic.nextFrame(1, true);
					FlxG.sound.music.stop();
					FlxG.sound.play('assets/sounds/cutscenes/Intro/hookerSCREAM.ogg');
					FlxG.camera.shake(0.05, 1.5, function()
					{
						canPress = true;
					});
				});

			case 'playstateTrans':
				var blackScreen:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				add(blackScreen);

				var mvgdLOGO:FlxSprite = new FlxSprite(295, 220).loadGraphic('assets/images/title/retroism.png');
				mvgdLOGO.scale.set(0.1, 0.1);
				mvgdLOGO.centerOrigin();
				mvgdLOGO.updateHitbox();
				add(mvgdLOGO);
				CommandData.watch(mvgdLOGO);
				FlxG.sound.play('assets/sounds/cutscenes/Intro/mario motif.ogg');
				FlxG.sound.play('assets/sounds/bomb explode.ogg');
				FlxTween.tween(mvgdLOGO, {"scale.x": 1, "scale.y": 1}, 1, {
					ease: FlxEase.quartInOut,
					onComplete: function(twn:FlxTween)
					{
						new FlxTimer().start(2, function(tmr:FlxTimer)
						{
							remove(mvgdLOGO);
							FlxG.sound.play('assets/sounds/cutscenes/Intro/mario pipe sound.ogg');
							new FlxTimer().start(2.5, function(tmr:FlxTimer)
							{
								FlxG.save.data.startsIntroCutscene = false;
								FlxG.save.flush();
								FlxG.switchState(new PlayState());
							});
						});
					}
				});
			// music
			case 'stopMusic':
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();

			case 'playMusic':
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				var daSong:String = frameEvents[curEventFrame][2];
				if (daSong != null)
					FlxG.sound.playMusic('assets/sounds/cutscenes/$cutsceneName/$daSong.ogg');
				trace('PLAYING SONG: $daSong');

			// sound
			case 'playSound':
				var daSound:String = frameEvents[curEventFrame][2];
				var doesLoop:Bool = frameEvents[curEventFrame][3];
				if (daSound != null)
					FlxG.sound.play('assets/sounds/cutscenes/$cutsceneName/$daSound.ogg', 1, doesLoop);
				trace('PLAYING SOUND: $daSound');

			case 'playGameSound':
				var daSound:String = frameEvents[curEventFrame][2];
				var doesLoop:Bool = frameEvents[curEventFrame][3];
				if (daSound != null)
					FlxG.sound.play('assets/sounds/$daSound.ogg', 1, doesLoop);
				trace('PLAYING GAME SOUND: $daSound');

			case 'stopMusicAndPlaySound':
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				var daSound:String = frameEvents[curEventFrame][2];
				if (daSound != null)
					FlxG.sound.play('assets/sounds/cutscenes/$cutsceneName/$daSound.ogg', 1);
				trace('PLAYING SOUND: $daSound');

			default:
				trace("event doesn't exist");
		}
	}
}
