package utils;
import js.Browser;
import three.utils.Detector;
/**
 * ...
 * @author nabe
 */
class OsChecker
{
	public static var WIN:String = "win";
	public static var MAC:String = "mac";
	public static var IOS:String = "ios";
	public static var ANDROID:String = "android";
	
	public function new() 
	{
		//
	}
	
	public static function isMobile():Bool {
		//return true;
		var s:String = osis();
		return  s == IOS || s == ANDROID;
	}
	
	public static function isAndroid():Bool {
		return osis() == ANDROID;
	}
	
	public static function isIE():Bool{
		
		if ( _hasAgent("msie") || _hasAgent("trident") ) return true;
		
		return false;
		
	}
	
	public static function isIosChrome():Bool{
		return _hasAgent("crios");
	}
	
	public static function isSafari():Bool {
		return _hasAgent("safari");
	}
	
	public static function isFirefox():Bool {
		return _hasAgent("firefox");
	}
	
	public static function isWindows():Bool {
		return _hasAgent("win");
	}
	
	public static function osis():String {
		
		if ( _hasAgent("iphone") || _hasAgent("ipad") || _hasAgent("ipod") ) {
			return IOS;
		}
		
		//mac
		if ( _hasAgent("mac") ) {
			return MAC;
		}
		
		//windows
		if ( _hasAgent("win") ) {
			return WIN;
		}
		
		if ( _hasAgent("android") ) {
			return ANDROID;
		}
		
		return ANDROID;
		
	}
	
	static public function goSupport():Bool
	{
		//robot エンジン対策
		if ( _hasAgent("google") || _hasAgent("yahoo") || _hasAgent("y!") ){
			return false;
		}
		
		//no webgl
		if (!Detector.webgl){
			return true;
		}		
		
		//ios chrome
		if ( OsChecker.isIosChrome() ){
			return true;
		}
		
		return false;
	
	}
	
	private static function _hasAgent(str:String):Bool {
		return Browser.navigator.userAgent.toLowerCase().indexOf(str) >= 0;
//		return Browser.navigator.platform.indexOf(str);
	}
	
}