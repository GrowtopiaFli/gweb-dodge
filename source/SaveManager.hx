package;

import flixel.FlxG;

class SaveManager
{
	#if (haxe >= "4.0.0")
	public static var levels:Map<String, Bool> = new Map();
	#else
	public static var levels:Map<String, Bool> = new Map<String, Bool>();
	#end
	
	public static var loaded:Bool = false;

	public static function load():Void
	{
		FlxG.save.bind('Dodge', 'GWeb');
		if (FlxG.save.data.levels != null)
			levels = FlxG.save.data.levels;
		loaded = true;
	}
	
	public static function saveToLevels(name:String, completed:Bool):Void
	{
		levels.set(name, completed);
		FlxG.save.data.levels = levels;
		FlxG.save.flush();
	}

	public static function levelComplete(id:String):Void
	{
		if (!loaded) load();
		if (!Data.initialized) Data.init();
		if (Data.iniData[id] != null && Data.iniData[id]["name"] != null)
			saveToLevels(Data.iniData[id]["name"], true);
	}
	
	public static function isLoaded(name:String):Bool
	{
		if (!loaded) load();
		if (!levels.exists(name))
			saveToLevels(name, false);
		return levels.get(name);
	}
}