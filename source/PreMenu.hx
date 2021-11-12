package;

import flixel.FlxG;

class PreMenu extends TempoState
{
	override public function create()
	{
		FlxG.sound.volume = 1;
		FlxG.sound.muted = false;
		FlxG.sound.muteKeys = [F1, ZERO];
		FlxG.sound.volumeUpKeys = [F3, PLUS];
		FlxG.sound.volumeDownKeys = [F2, MINUS];
		super.create();
		Switch.switchState(new Menu());
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}