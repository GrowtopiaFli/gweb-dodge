package assets;

import format.tgz.Reader;
import format.tar.Data;
import format.tar.Data.Entry;
import haxe.io.BytesInput;
import haxe.io.Bytes;

import lime.media.AudioBuffer;
import openfl.media.Sound;

import openfl.utils.Assets;

import flixel.FlxG;
import flixel.system.FlxSound;

import gwebdev.io.File;

using StringTools;

class AssetManager
{
	public static var archives:Array<String> = [
	"audio.dat",
	"levels.dat"
	];

	// EXTENSIONS

	public static var audioExtensions:Array<String> = [
	"mp3",
	"ogg",
	"wav",
	"wave",
	"mp2"
	];
	
	/*	public static var imageExtensions:Array<String> = [
		"png",
		"jpg",
		"jpeg",
		"tiff",
		"jfif",
		"webp"
		]; */
	
	// END
	
	#if (haxe >= "4.0.0")
	public static var sounds:Map<String, FlxSound> = new Map();
	#else
	public static var sounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	#end
	
	public static function extract():Array<Data>
	{
		var daData:Array<Data> = [];
		for (archive in archives)
		{
			if (archive.length > 0)
			{
				var daBytes:Bytes = File.getAssetBytes("assets/" + archive);
				var bytesInput:BytesInput = new BytesInput(daBytes);
				var tgzReader:Reader = new Reader(bytesInput);
				var tgzData:Data = tgzReader.read();
				daData.push(tgzData);
			}
		}
		return daData;
	}
	
	public static function cacheAudio():Void
	{
		var daData:Array<Data> = extract();
		for (tgzData in daData)
			for (tgzFile in tgzData)
				if (tgzFile.data != null && !tgzFile.fileName.endsWith("/"))
				{
					var isAudio:Bool = false;
					for (ext in audioExtensions)
						if (tgzFile.fileName.endsWith(ext)) isAudio = true;
					if (isAudio)
					{
						var snd:FlxSound = FlxG.sound.load(Sound.fromAudioBuffer(AudioBuffer.fromBytes(tgzFile.data)));
						snd.persist = true;
						sounds.set(tgzFile.fileName, snd);
					}
				}
	}
	
	public static function getBytes(path:String):Bytes
	{
		var daData:Array<Data> = extract();
		for (tgzData in daData)
			for (tgzFile in tgzData)
				if (tgzFile.data != null && !tgzFile.fileName.endsWith("/") && tgzFile.fileName == path)
					return tgzFile.data;
		return null;
	}
	
	public static function getText(path:String):String
	{
		var daData:Array<Data> = extract();
		for (tgzData in daData)
			for (tgzFile in tgzData)
				if (tgzFile.data != null && !tgzFile.fileName.endsWith("/") && tgzFile.fileName == path)
					return tgzFile.data.toString();
		return "";
	}
}