package objs;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objs.GameSprite.GameText;

/**
 * popup text very reminiscent of DOOM
 */
class HeadsUpTxt extends GameText
{
	var theSeconds:Float;

	public function new(text:String, spriteGroup:FlxTypedGroup<HeadsUpTxt>, seconds:Float, color:FlxColor)
	{
		super(0, 10, 245, text);
		setFormat(null, 12, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		borderSize = 1;
		theSeconds = seconds;
		alpha = 0.95;
		super.color = color;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		theSeconds -= elapsed;
		if (theSeconds < 0)
			destroy();
	}

	override public function destroy()
	{
		super.destroy();
	}
}
