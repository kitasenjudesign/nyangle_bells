package three.postprocessing;

@:native("THREE.RenderPass")
extern class RenderPass {
	var clear:Bool;
	var enabled : Bool;
	function new( scene : Scene, camera : Camera,
				  ?overrideMaterial : Dynamic, ?clearColor : Dynamic, ?clearAlpha : Dynamic ) : Void;
}
