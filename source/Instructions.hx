package;

import flixel.FlxG;
import flixel.text.FlxText;

class Instructions extends TempoState
{
	public function new(play:Bool = false)
	{
		super();
		if (play) Menu.menuAudio.play(true);
	}

	override public function create()
	{
		var txt:FlxText = new FlxText(0, 0, 0,
		"Controls:\n" +
		"Press The Left/Right Arrow Keys\n" +
		"To Move Between Tiles (Not Hold)...\n" +
		"Press Spacebar To Shoot (Not Hold)...\n" +
		"Press F4 To Toggle Fullscreen...\n" +
		"\nMechanics:\n" +
		"You Can Only Shoot Red Blocks (Breakable Blocks)\n" +
		"And Enemies...\n" +
		"You Have Three Lives...\n" +
		"You Regenerate Every After 10 Seconds\n" +
		"After Getting Hit...\n" +
		"Your Bullets Pass Through Everything\n" +
		"Except The Red Blocks (Breakable Blocks)...\n" +
		"Enemies Follow You And Shoot Bullets At You...\n" +
		"Once Bullets Are Following You, And You Move,\n" +
		"You Dodge It And You Are Not Going To Be Damaged...\n" +
		"Be Aware...\n" +
		"\nPress Backspace/ESC to go back to the menu.\n",
		14, true);
		txt.alignment = CENTER;
		txt.screenCenter();
		add(txt);
	
		super.create();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (!Menu.menuAudio.playing)
			Menu.playMenuMusic();
		
		if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
		{
			Sfx.select();
			Switch.switchState(new Menu(), false);
		}
	}
}