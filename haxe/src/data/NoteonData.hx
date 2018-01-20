package data;

/**
 * ...
 * @author 
 */
class NoteonData 
{
    //"name": "E5",
    //"midi": 76,
    //"time": 1.4399970000000002,
    // "velocity": 0.7874015748031497,
    //"duration": 0.47799900416666663
		  
	public static inline var BEAT:String = "BEAT";
	public static inline var VOCAL:String = "VOCAL";
	
	public var type:String;
	public var name:String;
	public var midi:Int = 0;
	public var time:Float;
	public var velocity:Float;
	public var duration:Float;
	public var id:Int = 0;
	
	public function new(o:Dynamic,ttype:String,iid:Int)
	{
		id = iid;
		type = ttype;
		name = o.name;
		midi = o.midi;
		time = o.time;
		velocity = o.velocity;
		duration = o.duration;
	}
	
}