package;

import flixel.FlxG;
import flixel.text.FlxText;

class About extends TempoState
{
	public function new(play:Bool = false)
	{
		super();
		if (play) Menu.menuAudio.play(true);
	}

	override public function create()
	{
		var txt:FlxText = new FlxText(0, 0, 0,
		"There is no story to this game.\n" +
		"it's just full of my funi music.\n" +
		"It was just made by a young developer\n" +
		"who was 14 at the time of making.\n" +
		"I had been coding for 5 years\n" +
		"and had been making music\n" +
		"for 8 months at the time of creation.\n" +
		"You are free to mod this game\n" +
		"given that you make it open source and such.\n" +
		"friday night funkin's code showed me about\n" +
		"HaxeFlixel so thank you ninjamuffin99.\n" +
		"I wanted to do something with my music\n" +
		"so i made this game.\n" +
		"I am a FNF modder but\n" +
		"always wanted to be a Game Developer.\n" +
		"\n- GWebDev\n" +
		"\nPress Backspace/ESC to go back to the menu.\n",
		16, true);
		txt.alignment = CENTER;
		txt.screenCenter();
		txt.font = "fonts/archivoblack.ttf";
		add(txt);

		super.create();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (!Menu.menuAudio.playing)
			Menu.playMenuMusic();
		
		if (Controller.back || Controller.right)
		{
			Sfx.select();
			Switch.switchState(new Menu(), false);
		}
	}
}