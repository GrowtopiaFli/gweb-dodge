package assets;

import assets.AssetManager;

import openfl.utils.Assets;

import flixel.FlxG;
import flixel.system.FlxSound;

using StringTools;

class AudioManager
{	
	public static function get(cachePath:String, addToList:Bool = true):FlxSound
	{
		if (AssetManager.sounds.exists(cachePath))
		{
			var snd:FlxSound = AssetManager.sounds.get(cachePath);
			if (addToList) FlxG.sound.list.add(snd);
			return snd;
		}
		else
		{
			AssetManager.cacheAudio();
			if (AssetManager.sounds.exists(cachePath))
			{
				var snd:FlxSound = AssetManager.sounds.get(cachePath);
				if (addToList) FlxG.sound.list.add(snd);
				return snd;
			}
			else
				return null;
		}
	}
}