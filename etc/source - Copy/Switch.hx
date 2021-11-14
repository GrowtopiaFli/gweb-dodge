package;

import flixel.FlxG;
import flixel.FlxState;

class Switch
{
	public static function switchState(state:FlxState, stopMusic:Bool = true)
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.switchState(state);
	}
}