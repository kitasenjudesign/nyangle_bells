package common;
import js.Browser;

/**
 * ...
 * @author nabe
 */
class OSDetector
{

	public static var WIN:String = "win";
	public static var MAC:String = "mac";
	public static var IOS:String = "ios";
	public static var ANDROID:String = "android";
	
	public function new() 
	{
		
	}
	
	public static function osis():String {
		
		if ( _check("Mac")>=0 ) {
			return MAC;
		}
		
		if ( _check("Win") >= 0) {
			return WIN;
		}
		
		if ( _check("iPhone")>=0 || _check("iPad")>=0 || _check("iPod")>=0 ) {
			return IOS;
		}
		
		if ( _check("android")>=0 ) {
			return ANDROID;
		}
		
		return ANDROID;
		
	}
	
	
	private static function _check(str:String):Int {
		return Browser.navigator.platform.indexOf(str);
	}
	
	
}