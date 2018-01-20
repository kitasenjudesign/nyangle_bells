package three;

@:native("CardboardEffect")
extern class CardboardEffect {

	var _scene:Scene;
	var _camera:Camera;
	
	function new( re : WebGLRenderer ) : Void;
	function setSize(canW:Float,canH:Float): Void;
	function render( scene:Scene, camera:Camera): Void;
}
