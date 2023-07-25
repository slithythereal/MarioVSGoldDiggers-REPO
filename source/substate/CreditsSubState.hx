package substate;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objs.GameSprite.GameText;
import objs.GameSprite;

class CreditsSubState extends FlxSubState
{
	var curCredit:Int = 0;
	var canMove:Bool = true;
	var credsSpr:GameSprite;
	var credsTxt:GameText;
	var bg:FlxSprite;
	var credSprPos:Array<Float> = [4, 32];
	var credNamePos:Array<Float> = [0, 360];
	var credTxtPos:Array<Float> = [320, 110];
	var blackAndWhite:FlxBackdrop;
	var credGrp:FlxTypedGroup<GameSprite>;
	var credName:GameText;
	var arrowUP:GameSprite;
	var mvgdLogo:GameSprite;
	var arrowDOWN:GameSprite;
	var creditsArray:Array<Array<Dynamic>> = [
		[
			'slithy',
			'slithythereal',
			"LEAD DEV (MOST WORK)\nhi i hope you enjoyed my game, i put a little over 2 months into this project\nalso CHECK OUT COOLGUY SIMULATOR (WIP)",
			0xffffa600,
			'https://slithy.carrd.co'
		],
		[
			'cakie',
			'CakieYea',
			"MADE RETRO THEMES\nbig balls \nhey thanks for playing ily",
			0xFFFF0000,
			'https://www.youtube.com/@cakieyea/'
		],
		[
			'playtesters',
			'THE PLAYTESTERS',
			"mrmorian\nlunarcleint\ng-nux\nand the others I can't remember",
			0xff979797,
			'https://slithythereal.itch.io/mvgd'
		]
	];

	public function new()
	{
		super();

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height);
		bg.color = creditsArray[curCredit][3];
		bg.alpha = 0.75;
		add(bg);

		blackAndWhite = new FlxBackdrop('assets/images/fallDown.png', 0, 0, true, true, 0);
		blackAndWhite.antialiasing = false;
		blackAndWhite.velocity.set(0, 90);
		blackAndWhite.scale.set(1, 50);
		blackAndWhite.updateHitbox();
		blackAndWhite.screenCenter();
		blackAndWhite.alpha = 0.75;
		add(blackAndWhite);
		blackAndWhite.color = creditsArray[curCredit][3];

		credsSpr = new GameSprite();
		credsSpr._dynamic.change = function(newImg:String, tweenOut:Bool)
		{
			if (tweenOut)
			{
				FlxTween.tween(credsSpr, {x: -600}, 0.25, {
					ease: FlxEase.quartOut,
					onComplete: function(twn:FlxTween)
					{
						new FlxTimer().start(0.25, function(tmr:FlxTimer)
						{
							credsSpr.loadGraphic('assets/images/credits/$newImg.png');
							FlxTween.tween(credsSpr, {x: credSprPos[0], y: credSprPos[1]}, 0.25, {ease: FlxEase.quartOut});
						});
					}
				});
			}
			else
			{
				credsSpr.setPosition(credSprPos[0], credSprPos[1]);
				credsSpr.loadGraphic('assets/images/credits/${creditsArray[curCredit][0]}.png');
			}
		}
		add(credsSpr);

		var blackBox:FlxSprite = new FlxSprite(FlxG.width / 2).makeGraphic(Std.int(FlxG.width / 2), FlxG.height, FlxColor.BLACK);
		blackBox.alpha = 0.95;
		add(blackBox);

		var blackBox2:FlxSprite = new FlxSprite(0, 350).makeGraphic(Std.int(FlxG.width / 2), 250, FlxColor.BLACK);
		add(blackBox2);

		mvgdLogo = new GameSprite(360, 0);
		mvgdLogo.loadGraphic('assets/images/title/retroism.png');
		mvgdLogo.scale.set(0.4, 0.4);
		mvgdLogo.updateHitbox();
		mvgdLogo.antialiasing = false;
		add(mvgdLogo);

		var credits:FlxText = new FlxText(390, 75, 0, ">-CREDITS-<").setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		credits.borderSize = 2;
		add(credits);

		credsTxt = new GameText();
		credsTxt.setFormat(null, 16, FlxColor.WHITE, LEFT);
		credsTxt.fieldWidth = FlxG.width / 2;
		credsTxt._dynamic.updateCredTxt = function(txt:String, tweenOut:Bool)
		{
			if (tweenOut)
			{
				FlxTween.tween(credsTxt, {y: 1000}, 0.25, {
					ease: FlxEase.quartIn,
					onComplete: function(twn:FlxTween)
					{
						new FlxTimer().start(0.25, function(tmr:FlxTimer)
						{
							credsTxt.text = txt;
							FlxTween.tween(credsTxt, {x: credTxtPos[0], y: credTxtPos[1]}, 0.25, {ease: FlxEase.quartOut});
						});
					}
				});
			}
			else
			{
				credsTxt.text = txt;
				credsTxt.setPosition(credTxtPos[0], credTxtPos[1]);
			}
		}
		add(credsTxt);

		credName = new GameText(0, 0, FlxG.width / 2);
		credName._dynamic.updateCredName = function(txt:String, color:FlxColor, tweenOut:Bool)
		{
			credName.borderSize = 4;
			if (tweenOut)
			{
				FlxTween.tween(credName, {y: 1000}, 0.25, {
					ease: FlxEase.quartOut,
					onComplete: function(twn:FlxTween)
					{
						new FlxTimer().start(0.25, function(tmr:FlxTimer)
						{
							credName.setFormat(null, 32, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE, color);
							credName.borderSize = 4;
							credName.text = txt;
							FlxTween.tween(credName, {x: credNamePos[0], y: credNamePos[1]}, 0.25, {ease: FlxEase.quartOut});
						});
					}
				});
			}
			else
			{
				credName.setFormat(null, 32, FlxColor.BLACK, CENTER, FlxTextBorderStyle.OUTLINE, color);
				credName.borderSize = 4;
				credName.text = txt;
				credName.setPosition(credNamePos[0], credNamePos[1]);
			}
		}
		add(credName);

		arrowUP = new GameSprite(0, 0);
		arrowUP.loadGraphic('assets/images/arrow.png');
		arrowUP.screenCenter(X);
		arrowUP.scale.set(1, 1);
		arrowUP.updateHitbox();
		add(arrowUP);

		arrowDOWN = new GameSprite(0, FlxG.height - 25);
		arrowDOWN.loadGraphic('assets/images/arrow.png');
		arrowDOWN.screenCenter(X);
		arrowDOWN.scale.set(1, 1);
		arrowDOWN.updateHitbox();
		arrowDOWN.flipY = true;
		add(arrowDOWN);

		changeCred(0, false);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (canMove)
		{
			if (FlxG.keys.anyJustPressed([W, UP]) || FlxG.mouse.justPressed && FlxG.mouse.overlaps(arrowUP))
			{
				changeCred(-1, true);
				arrowUP.scaleTween(1.25, 1, FlxEase.quintInOut, 0.05);
			}
			if (FlxG.keys.anyJustPressed([S, DOWN]) || FlxG.mouse.justPressed && FlxG.mouse.overlaps(arrowDOWN))
			{
				changeCred(1, true);
				arrowDOWN.scaleTween(1.25, 1, FlxEase.quintInOut, 0.05);
			}
			if (FlxG.keys.anyJustPressed([ENTER, SPACE]) || FlxG.mouse.justPressed && FlxG.mouse.overlaps(credsSpr))
				FlxG.openURL('${creditsArray[curCredit][4]}');
			if (FlxG.keys.justReleased.ESCAPE)
				close();
		}
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(mvgdLogo))
			FlxG.openURL("https://slithythereal.itch.io/mvgd");
	}

	function changeCred(cool:Int, tweenOut:Bool)
	{
		curCredit += cool;
		if (curCredit < 0)
			curCredit = creditsArray.length - 1;
		if (curCredit >= creditsArray.length)
			curCredit = 0;

		var newImg:String = creditsArray[curCredit][0];
		var newName:String = creditsArray[curCredit][1];
		var newTxt:String = creditsArray[curCredit][2];
		var newColor:FlxColor = creditsArray[curCredit][3];
		bg.color = newColor;

		credsSpr._dynamic.change('$newImg', tweenOut);
		credsTxt._dynamic.updateCredTxt('$newTxt', tweenOut);
		credName._dynamic.updateCredName('$newName', newColor, tweenOut);

		if (tweenOut)
		{
			canMove = false;
			new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
				FlxTween.color(blackAndWhite, 0.50, blackAndWhite.color, newColor, {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween)
					{
						canMove = true;
					}
				});
			});
		}
		else
			FlxTween.color(blackAndWhite, 0.75, blackAndWhite.color, newColor, {ease: FlxEase.linear});
	}
}
