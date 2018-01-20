package three.postprocessing;
import three.Vector2;

@:native("THREE.BloomBlendPass")
extern class BloomBlendPass {
	
	public var enabled:Bool;
	function new( blur : Float, ratio : Float, resolution:Vector2,fragment:String ) : Void;
}

/*
var bloomPass = new THREE.BloomBlendPass(
    2.0, // the amount of blur
    1.0, // interpolation(0.0 ~ 1.0) original image and bloomed image
    new THREE.Vector2(1024, 1024) // image resolution
);
bloomPass.renderToScreen = true;
composer.addPass(bloomPass);
*/