package;

import assets.*;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class PreMenu extends FlxState
{
	override public function create()
	{
		FlxG.sound.volume = 1;
		FlxG.sound.muted = false;
		FlxG.sound.muteKeys = [F1];
		FlxG.sound.volumeUpKeys = [F3, PLUS];
		FlxG.sound.volumeDownKeys = [F2, MINUS];
		var txt:FlxText = new FlxText(0, 0, 0, "Loading...", 16, true);
		txt.alignment = CENTER;
		txt.screenCenter();
		add(txt);
		super.create();
		#if sys
		sys.thread.Thread.create(() -> {
		#end
		AssetManager.cacheAudio();
		Menu.menuAudio = AudioManager.get("menu/menu_music.ogg");
		Menu.menuAudio.looped = true;
		Menu.menuAudio.volume = 0;
		Menu.menuAudio.play();
		Menu.menuAudio.pause();
		Menu.menuAudio.time = 0;
		Switch.switchState(new VersionCheck(), false);
		#if sys
		});
		#end
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}