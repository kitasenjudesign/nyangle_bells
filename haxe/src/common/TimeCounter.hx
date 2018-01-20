package common;

/**
 * ...
 * @author nabe
 */
class TimeCounter
{

	private static var _time:Date; 
	
	
	public function new() 
	{
		
	}
	
	public static function start():Void {
	
		_time = Date.now();
		
	}
	
	public static function getTime():String {
		
		var now:Date = Date.now();
		var time:Int = Math.floor( now.getTime() - _time.getTime() );
		
		//trace("time " + time);

		var out:String = "";
		
		//msec
		var msec:Int = time % 1000;
		msec = Math.floor( msec / 100 );
		
		//sec
		var sec:Int = Math.floor( time / 1000 );
		var secOut:Int = sec % 60;
		
		//min
		var min:Int = Math.floor( sec / 60 );

		
		var out:String = "00:" + StringUtils.addZero(min, 2) + ":" + StringUtils.addZero(secOut, 2);// +"." + StringUtils.addZero(msec, 2);
		
		
		return out;
		
	}
	
}