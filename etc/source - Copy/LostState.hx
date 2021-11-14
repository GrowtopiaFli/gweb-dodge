package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class LostState extends FlxState
{
	public var songId:String = "";
	public var txt1:FlxText;
	public var txt2:FlxText;
	
	public function new(sid:String = "")
	{
		super();
		if (sid != "") songId = sid;
	}

	override public function create()
	{
		txt1 = new FlxText(0, 0, 0, "Gam Oveer\n", 48, true);
		txt1.screenCenter();
		txt1.alignment = CENTER;
		add(txt1);
		
		txt2 = new FlxText(0, 0, 0, "Pres Enteer To Retyr\nOr Pres Bkcaspcae/Esc To Go Bak To Menu\n", 16, true);
		txt2.screenCenter();
		txt2.y += 48;
		txt2.alignment = CENTER;
		add(txt2);
	
		super.create();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ENTER)
			Switch.switchState(new PlayState(songId));
		if (FlxG.keys.anyJustPressed([BACKSPACE, ESCAPE]))
			Switch.switchState(new Menu());
	}
}