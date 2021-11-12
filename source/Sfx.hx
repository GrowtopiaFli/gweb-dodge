package;

import flixel.FlxG;
import flixel.system.FlxSound;

class Sfx
{
	public static var paths:Array<String> = [
	"hurt1.wav",
	"hurt2.wav",
	"hurt3.wav",
	"scroll.wav",
	"select.wav",
	"enemy_spawn.wav",
	"enemy_die.wav",
	"shoot.wav",
	"hit.wav"
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
	
	public static function shoot()
	{
		loadSound(paths[7]);
	}
	
	public static function hit()
	{
		loadSound(paths[8]);
	}
	
	public static function loadSound(path:String)
	{
		var daSnd:FlxSound = new FlxSound().loadEmbedded("assets/sounds/" + path, false);
		// FlxG.sound.list.add(daSnd);
		daSnd.play();
	}
}