package;

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
	#else
	public static var songData:Map<String, String> = new Map<String, String>();
	#end
	
	public static function init()
	{
		var txtData:String = File.getAssetBytes('data/mus_data.cfg').toString();
		var conf:ConfigFile = new ConfigFile();
		conf.read(txtData);
		iniData = conf.settings;
		for (shit in iniData.keys())
			if (!shit.startsWith("evt_") && iniData[shit]["name"] != null)
				songData.set(iniData[shit]["name"], shit);
		for (shit in songData.keys())
			songNames.push(shit);
		initialized = true;
	}
}