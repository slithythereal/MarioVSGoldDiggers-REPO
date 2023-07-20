package;

import data.Jsons.CutscData;
import data.Jsons.CutscJson;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import sys.io.File;
import sys.FileSystem;
import flixel.text.FlxText;
import openfl.utils.Assets;

class CutsceneState extends FlxState // TODO: make frames and work on this
{
	var cutsceneName:String;
	var cutSpr:FlxSprite;
	var curFrame:Int = 1;
	var maxFrames:Int = 1;

	// var frameData:Array<Dynamic> = [['Intro', 2]];

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
			// always start with this
			if (upFrame)
				curFrame += frame;
			cutSpr.loadGraphic('assets/images/cutscenes/$cutsceneName/${cutsceneName}_$curFrame.png');
		}
		cutSpr._dynamic.nextFrame(curFrame, false);
		cutSpr.screenCenter();
		add(cutSpr);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed)
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
				eventsArray: [[0, "", ""]]
			}
		}
		maxFrames = jsonData.frameAmt;
	}

	function funyEvents(event:String)
	{
		switch (event)
		{
			default:
				trace("event doesn't exist");
		}
	}
}
