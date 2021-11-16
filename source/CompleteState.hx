package;

import flixel.FlxG;
import flixel.text.FlxText;

class CompleteState extends TempoState
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
		txt1 = new FlxText(0, 0, 0, "Congratulations!\n", 40, true);
		txt1.screenCenter();
		txt1.alignment = CENTER;
		add(txt1);
		
		txt2 = new FlxText(0, 0, 0, "You Have Beaten The Level\nPress Enter To Go Back\nTo The Level Selection Menu", 16, true);
		txt2.screenCenter();
		txt2.y += 48;
		txt2.alignment = CENTER;
		add(txt2);
	
		super.create();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (Controller.enter)
			Switch.switchState(new MenuSelection(true));
	}
}