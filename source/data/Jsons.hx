package data;

import flixel.FlxG;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.utils.Assets;
import sys.FileSystem;
import sys.io.File;

// made a little json .hx file for the cutscene and for anyone to make their own .json thingy
typedef CutscData =
{
	var frameAmt:Int;
	var eventsArray:Array<Array<Dynamic>>;
	var withEvents:Int;
	var endEvent:String;
}

class CutscJson
{
	public static function loadJson(cutscene:String):CutscData
	{
		var theJson:String = null;
		var path:String = 'assets/images/cutscenes/$cutscene/data.json';
		#if NO_EMBED
		if (FileSystem.exists(path))
			theJson = File.getContent(path);
		#else
		if (Assets.exists(path))
			theJson = Assets.getText(path);
		#end
		else
		{
			return null;
			trace("JSON NOT LOADED");
		}
		return cast Json.parse(theJson);
	}
}
