package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

import haxe.Http;
import haxe.io.Bytes;

class UpdatedState extends FlxState
{
	public static var daVer:String = "I DONT KNOW";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var ver = "v" + Application.current.meta.get('version');
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"WARNING!\n" +
			"This Version Of GWeb Dodge\n" +
			"Is A DEV Build!\n" +
			"DEV Builds Are Usually Unstable...\n" +
			"Press ENTER To Go To The Github Page\n" +
			"Press BACK To Use This Version Of GWeb Dodge",
			14, true);
		txt.alignment = CENTER;
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		var accepted:Bool = FlxG.keys.justPressed.ENTER;
		var backed:Bool = FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE;
		
		if (accepted)
			openUrl('https://github.com/' + Github.name + '/' + Github.repo);
		if (backed)
			#if sys
			sys.thread.Thread.create(() -> {
			#end
			Switch.switchState(new Menu(), false);
			#if sys
			});
			#end
		super.update(elapsed);
	}
	
	function openUrl(url:String):Void
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [url, "&"]);
		#else
		FlxG.openURL(url);
		#end
	}
}
