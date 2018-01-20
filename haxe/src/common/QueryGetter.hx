package common;

import Tracer;
import js.Browser;

/**
 * ...
 * @author watanabe
 */
class QueryGetter
{

	public static var NORMAL:Int = 0;
	public static var SKIP:Int = 1;
	
	private static var _isInit:Bool = false;
	private static var _map:Map<String,String>;
	
	public static var t:Int = 0;
	
	public function new() 
	{
		
	}
	
	//? id=a & fuga=b
	
	public static function init():Void {
		
		_map = new Map();
		
		var str:String = Browser.window.location.search;
		if ( str.indexOf("?")<0 ) {
			Tracer.log("query nashi");
		}else {
			str = str.substr(1, str.length - 1);
			var list:Array<String> = str.split("&");
			Tracer.log(list);
			for (i in 0...list.length) {
				var fuga:Array<String> = list[i].split("=");
				_map.set(fuga[0], fuga[1]);
			}
		}
		
		//
		if( _map.get("t") != null ){
			t = Std.parseInt( _map.get("t") );
		}
		
		_isInit = true;
	}
	
	public static function getQuery(idd:String):Dynamic {
	
		if (!_isInit) {
			init();
		}
		return _map.get(idd);
		
	}
	
}