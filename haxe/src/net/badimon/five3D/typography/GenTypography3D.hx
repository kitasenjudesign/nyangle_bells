package net.badimon.five3D.typography ;
import haxe.Http;
import haxe.Json;

/**
 * ...
 * @author nab
 */
class GenTypography3D extends Typography3D
{

	private var _callback:Void->Void;
	
	public function new() 
	{
		super();
	}
	
	public function init(uri:String,callback:Void->Void):Void {
		
		//callback
		_callback = callback;
		
		//jsonロード
		var http:Http = new Http( uri );
        http.onData = _onLoad;
        http.request( false );
		
	}
	
	public function initByString(jsonStr:String):Void {
		_onLoad(jsonStr);
	}
	
	private function _onLoad(data:String):Void{
		
		var o:Dynamic = Json.parse(data);
		
		for (key in Reflect.fields( o )) {
			if (key == "height") {
				height = Reflect.getProperty( o, key );
			}else{
				_initTypo( key, Reflect.getProperty( o,key ) );
			}
		}
		
		_callback();		
	}
	
	
	private function _initTypo(key:String, ary:Array<Dynamic>):Void {
				
		//width__0
		widths.set(key, ary[0]);
			
		//motifs__1..length
		var motif:Array<Array<Dynamic>> = [];
		for (i in 1...ary.length) {
			motif.push( _initAry(ary[i]) );
		}
		//trace(key,motif);
		motifs.set(key, motif);

	}
	
	private function _initAry(str:String):Array<Dynamic>
	{
		//[['M',[34.4,43.75]],['L',[43.35,69.9]]
		
		var list:Array<String> = str.split(",");// "M,37.4,34.5"
		var out:Array<Dynamic> = [];
		out[0] = list[0];
		if (out[0] == "C") {
			out[1] = [
				Std.parseFloat(list[1]), Std.parseFloat(list[2]),
				Std.parseFloat(list[3]), Std.parseFloat(list[4])
			];			
		}else{
			out[1] = [
				Std.parseFloat(list[1]), Std.parseFloat(list[2])
			];
		}
		return out;	
		
	}
	
}