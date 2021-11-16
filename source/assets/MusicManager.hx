package assets;

import assets.AssetManager;

import openfl.utils.Assets;

import flixel.FlxG;
import flixel.system.FlxSound;

using StringTools;

class MusicManager
{	
	public static function get(musicPath:String, addToList:Bool = true):FlxSound
	{
		var snd:FlxSound = AssetManager.getMusic(musicPath);
		snd.persist = false;
		snd.autoDestroy = true;
		if (addToList) FlxG.sound.list.add(snd);
		return snd;
	}
}