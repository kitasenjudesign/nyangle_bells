package sound;
import data.NoteonData;
import haxe.Http;
import haxe.Json;

/**
 * ...
 * @author 
 */
class MidiJsonLoader 
{

	private var _callback:Void->Void;
	private var _http:Http;
	private var _type:String;
	
	public var noteList:Array<NoteonData>;
	
	public function new() 
	{
		
	}
	
	public function load(uri:String, type:String, callback:Void->Void):Void{
		
		_callback = callback;
		_type = type;
		
		_http = new Http(uri);
		_http.onData = _onData;
		_http.request();
		
	}
	
	private function _onData(str:String):Void {		
		
		var d:Dynamic = Json.parse(str);
		//trace(d);
		
		noteList = [];
		var idx:Int = 0;
		for (j in 0...d.tracks.length){
			
			var notes:Array<Dynamic> = d.tracks[j].notes;
			
			for (i in 0...notes.length){
				var data:NoteonData = new NoteonData(notes[i], _type, idx);
				noteList.push( data );				
				idx++;
				//trace( "time " + noteList[i].time );
			}
			
		}
		
		if (_callback != null){
			_callback();
		}
		
	}
	
}