package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	var screenSize:Array<Int> = [640, 480];
	var initialState:Null<Class<flixel.FlxState>> = Init;
	var zoom:Float = 1;
	var frameRate:Int = 60;
	var updateframerate:Int = 60;
	var skipSplash:Bool = true;
	var fullscreen:Bool = #if hl false #else true #end;

	public function new()
	{
		super();
		addChild(new FlxGame(screenSize[0], screenSize[1], initialState, zoom, updateframerate, frameRate, skipSplash, fullscreen));
	}
}
/**
	HELLO, if you're reading this, good job you found `Main.hx`, yes, very cool, awesome.
	ANYWAYS, because this is a hardcoded game like FNF; the code's bound to be messy in some places. 
	Whoever can fix bits of code that I have marked out in this repository and send the fixed code to me in dms on discord (@slithythereal) first,
	WILL GET ADDED TO THE UPDATE'S CREDITS!

	Keep your eyes peeled for the marked code and keep your eyes on the github because I'll most likely be updating this repo a lot.

	Thanks for reading and have a good one,
	-slithythereal 
**/
