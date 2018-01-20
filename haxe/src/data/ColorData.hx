package data;
import three.Color;

/**
 * ...
 * @author 
 */
class ColorData 
{
	
	public static var BLACK_RED:ColorData = new ColorData({
		bg: 	new Color(0,0,0),
		box: 	new Color(1,0,0),
		line: 	new Color(1,1,0),
		paper: 	new Color(1,1,0),
		moji: 	new Color(1,0,0)
	});
	public static var BLACK_BLUE:ColorData = new ColorData({
		bg: 	new Color(0,0,0),
		box: 	new Color(0,0,1),
		line: 	new Color(1,1,0),
		paper: 	new Color(1,1,0),
		moji: 	new Color(1,0,0)
	});
	public static var BLACK_GREEN:ColorData = new ColorData({
		bg: 	new Color(0,0,0),
		box: 	new Color(0,1,0),
		line: 	new Color(1,1,0),
		paper: 	new Color(1,1,0),
		moji: 	new Color(1,1,0)
	});
	
	
	
	
	
	public static var RED:ColorData = new ColorData({
		bg: 	new Color(1,0,0),//blue
		box: 	new Color(1,1,0),//yellow
		line: 	new Color(1,1,0),
		paper: 	new Color(1,1,0),
		moji: 	new Color(1,1,0)	
	});
	public static var GREEN:ColorData = new ColorData({
		bg: 	new Color(0,1,1),
		box: 	new Color(0,0,1),
		line: 	new Color(0,0,1),
		paper: 	new Color(1,1,0),
		moji: 	new Color(1,1,0)
	});
	public static var BLUE:ColorData = new ColorData({
		bg: 	new Color(0,0,1),
		box: 	new Color(1,0,0),
		line: 	new Color(1,1,0),
		paper: 	new Color(1,1,0),
		moji: 	new Color(1,0,0)	
	});
	
	public static var CYAN:ColorData = new ColorData({
		bg: 	new Color(0,1,1),
		box: 	new Color(1,0,1),
		line: 	new Color(1,0,1),
		paper: 	new Color(1,1,0),
		moji: 	new Color(1,0,1)
	});

	public var bg		:Color;
	public var box		:Color;
	public var line		:Color;
	public var paper	:Color;
	public var moji		:Color;
	
	public static var _colors:Array<ColorData> = [
		BLACK_RED,
		BLUE,
		BLACK_GREEN,
		GREEN,
		BLACK_BLUE,
		RED
	];
	
	private static var _index:Int = -1;
	
	public function new(o:Dynamic) 
	{
		bg		= o.bg;
		box		= o.box;
		line 	= o.line;
		paper	= o.paper;
		moji	= o.moji;
	}
	
	static public function getNext():ColorData
	{

		if ( _index == -1 ){
			_index = Math.floor( _colors.length * Math.random());
		}
		
		_index++;
		return _colors[_index % _colors.length];
		
		
	}
	
}