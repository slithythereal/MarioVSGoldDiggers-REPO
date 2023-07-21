package;

import data.Jsons.CutscData;
import data.Jsons.CutscJson;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
				FlxG.switchState(new PlayState());
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
		if (jsonData.withEvents >= 1)
		{
			frameEvents = jsonData.eventsArray;
			for (i in 0...jsonData.withEvents)
				framesWEvents.push(frameEvents[i][0]);
		}
	}

	function funyEvents(event:String) // whoever fixes these (mainly the sound events) gets added to the update's credits -slithy
	{
		switch (event)
		{
			// sprite
			case 'LOGOpopIn':
				var logo:FlxSprite = new FlxSprite().loadGraphic('assets/images/title/retroism.png');
				logo.scale.set(0.1, 0.1);
				logo.updateHitbox();
				logo._dynamic.update = function(elapsed:Float)
				{
					logo.updateHitbox();
				}
				add(logo);
				FlxTween.tween(logo, {"scale.x": 1.5, "scale.y": 1.5}, 5, {ease: FlxEase.quartInOut});
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
