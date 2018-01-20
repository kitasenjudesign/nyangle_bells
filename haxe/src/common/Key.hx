package common;
import js.Browser;
import three.EventDispatcher;

/**
 * ...
 * @author watanabe
 */
class Key extends EventDispatcher
{

	public static inline var keydown = "keydown";
	public static var board:Key;
	//private var _socket:WSocket;
		
	public function new() 
	{
		super();
	}

	public static function init():Void {	
		if (board == null) {
			board = new Key();
			board.init2();
		}
	}

	
	public function init2():Void {
		
		Browser.document.body.addEventListener("keydown" , _onKeyDown);
		//_socket = new WSocket();
		//_socket.init();
		
		//if (Dat.bg) {
		//	_socket.addCallback(_onKeyDown);
		//}
		
	}
	
	/**
	 * @param	e
	 */
	private function _onKeyDown(e:Dynamic):Void {
	
		var n:Int = Std.parseInt(e.keyCode);
		Tracer.info("_onkeydown " + n);
		_dispatch(n);
		
	}
	
	
	
	private function _dispatch(n:Int):Void {
	
		if (!Dat.bg) {
			//_socket.send(n);
		}
		
		dispatchEvent( {type:"keydown", keyCode:n });
		//izurenishiro dispatch suru
		
	}
	
	
	
	
}