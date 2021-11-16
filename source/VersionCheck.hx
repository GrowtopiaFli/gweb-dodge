package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import haxe.io.Bytes;

#if android
import extension.androidorientation.AndroidOrientation;
#end

class VersionCheck extends FlxState
{
	public var text:FlxText;

	override function create()
	{
		text = new FlxText(0, 0, FlxG.width,
			"Checking Version",
			16, true);
		text.alignment = CENTER;
		text.screenCenter();
		add(text);
		
		super.create();
		
		init();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		#if android
		AndroidOrientation.setScreenOrientation(AndroidOrientation.SENSOR_PORTRAIT);
		#end
	}
	
	function init():Void
	{
		#if sys
		sys.thread.Thread.create(() -> {
		#end
		Requester.sendRequest('github_version', "https://raw.githubusercontent.com/" + Github.name + "/" + Github.repo + "/main/current.version", false).onComplete
		(
			function(ret:Bool)
			{
				if (ret || (!ret && Requester.requests.exists('github_version')))
				{
					compare(Requester.requests.get('github_version').toString());
				}
				else
				{
					#if sys
					if (sys.FileSystem.exists('assets/latest_ver.txt'))
						compare(Requester.readFile('assets/latest_ver.txt').toString());
					else
					#end
						err();
				}
			}
		).onError
		(
			function(e:Dynamic)
			{
				err();
			}
		);
		#if sys
		});
		#end
	}
	
	function err():Void
	{
		text.text = "Cannot Check For Version...\nProceeding To Menu In 3 Seconds\n";
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			menuSwitch();
		});
	}
	
	function compare(data:String):Void
	{
		#if sys
		sys.thread.Thread.create(() -> {
		sys.io.File.saveBytes('assets/latest_ver.txt', Bytes.ofString(data));
		#end
		OutdatedState.daVer = data;
		UpdatedState.daVer = data;
		if (VersionParser.parse(CurrentVersion.get()) < VersionParser.parse(data))
			Switch.switchState(new OutdatedState(), false);
		else if (VersionParser.parse(CurrentVersion.get()) >  VersionParser.parse(data))
			Switch.switchState(new UpdatedState(), false);
		else
			menuSwitch();
		#if sys
		});
		#end
	}
	
	function menuSwitch():Void
	{
		#if sys
		sys.thread.Thread.create(() -> {
		#end
		Switch.switchState(new Menu(), false);
		#if sys
		});
		#end
	}
}