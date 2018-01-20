package common;
import haxe.Http;
import haxe.Json;
import js.Browser;

/**
 * ...
 * @author watanabe
 */
class Config
{

	private var _http:Http;
	private var _callback:Void->Void;
	
	public static var host:String;
	public static var canvasOffsetY:Float = 0;
	public static var globalVol:Float = 1.0;
	public static var particleSize:Float = 10000;
	public static var bgLight:Float = 0.5;
	
	public function new() 
	{
		
	}

	public function load(callback:Void->Void):Void {
		
		_callback = callback;
		_http = new Http("../../config.json");
		_http.onData = _onData;
		_http.request();
	}
	
	private function _onData(str:String):Void {
		
		var data:Dynamic = Json.parse(str);
		host = data.host;
		//Browser.window.alert("" + host);
		
		//host
		var win:Dynamic = Browser.window;
		win.host = host;	
		
		if ( QueryGetter.getQuery("host") != null ) {
			win.host = QueryGetter.getQuery("host");
		}
		
		canvasOffsetY = data.canvasOffsetY;
		globalVol = data.globalVol;
		particleSize = data.particleSize;
		bgLight = data.bgLight;
		
		if ( _callback != null ) {
			_callback();
		}
		
	}
	
}