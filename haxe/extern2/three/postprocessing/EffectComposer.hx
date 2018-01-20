package three.postprocessing;
import three.WebGLRenderTarget;

@:native("THREE.EffectComposer")
extern class EffectComposer {
	
	var renderTarget1:WebGLRenderTarget;
	var renderTarget2:WebGLRenderTarget;
	function new( renderer : Renderer, ?renderTarget : Dynamic ) : Void;
	function swapBuffers() : Void;
	function addPass( pass : Dynamic ) : Void;
	function insertPass( pass : Dynamic, index : Int ) : Void;
	function render( ?delta : Dynamic ) : Void;
	function reset( ?renderTarget : Dynamic ) : Void;
	function setSize( width : Float, height : Float ) : Void;
}
