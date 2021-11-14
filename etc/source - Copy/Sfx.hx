package;

import flixel.FlxG;
import flixel.system.FlxSound;

class Sfx
{
	public static var paths:Array<String> = [
	"sounds/hurt1.wav",
	"sounds/hurt2.wav",
	"sounds/hurt3.wav",
	"sounds/scroll.wav",
	"sounds/select.wav",
	"sounds/enemy_spawn.wav",
	"sounds/enemy_die.wav"
	];

	public static function load()
	{
		for (stuff in paths)
		{
			FlxG.sound.cache("assets/" + stuff);
		}
	}

	public static function hurt1()
	{
		loadSound(paths[0]);
	}
	
	public static function hurt2()
	{
		loadSound(paths[1]);
	}
	
	public static function hurt3()
	{
		loadSound(paths[2]);
	}
	
	public static function scroll()
	{
		loadSound(paths[3]);
	}
	
	public static function select()
	{
		loadSound(paths[4]);
	}
	
	public static function enemy_spawn()
	{
		loadSound(paths[5]);
	}
	
	public static function enemy_die()
	{
		loadSound(paths[6]);
	}
	
	public static function loadSound(path:String)
	{
		var daSnd:FlxSound = new FlxSound().loadEmbedded("assets/" + path, false);
		// FlxG.sound.list.add(daSnd);
		daSnd.play();
	}
}