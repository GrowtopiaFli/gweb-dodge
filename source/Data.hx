package;

import assets.*;

import gwebdev.io.File;
import hxconf.ConfigFile;

using StringTools;

class Data
{
	public static var iniData:Map<String, Map<String, String>>;
	public static var initialized:Bool = false;
	public static var songNames:Array<String> = [];
	
	#if (haxe >= "4.0.0")
	public static var songData:Map<String, String> = new Map();
	public static var iniDataEvents:Map<String, Map<String, Map<String, String>>> = new Map();
	#else
	public static var songData:Map<String, String> = new Map<String, String>();
	public static var iniDataEvents:Map<String, Map<String, Map<String, String>>> = new Map<String, Map<String, Map<String, String>>>();
	#end
	
	public static function init()
	{
		// var txtData:String = File.getAssetBytes('data/mus_data.cfg').toString();
		var txtData:String = AssetManager.getText('data/levels.ini');
		var conf:ConfigFile = new ConfigFile();
		conf.read(txtData);
		iniData = conf.settings;
		for (shit in iniData.keys())
			if (iniData[shit].exists("name"))
				songData.set(iniData[shit]["name"], shit);
		// var songListStr:String = File.getAssetBytes('data/mus_list.array').toString();
		for (shit in songData.keys())
		{
			var levelAud:String = iniData[songData[shit]]["audio"];
			var levelText:String = AssetManager.getText('data/levels/' + levelAud + ".ini");
			var levelConf:ConfigFile = new ConfigFile();
			levelConf.read(levelText);
			var levelData:Map<String, Map<String, String>> = levelConf.settings;
			iniDataEvents.set(levelAud, levelData);
		}
		var songListStr:String = AssetManager.getText('data/level_list.array');
		songListStr = new EReg("\r", "g").replace(songListStr, "");
		var songList:Array<String> = songListStr.split("\n");
		for (i in 0...songList.length)
			if (songData.exists(songList[i]))
				songNames.push(songList[i]);
		initialized = true;
	}
}