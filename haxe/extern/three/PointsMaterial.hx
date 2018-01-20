package three;

@:native("THREE.PointsMaterial")
extern class PointsMaterial extends Material {
	var color : Color;
	var map : Texture;
	var size : Float;
	var sizeAttenuation : Bool;
	var vertexColors : Bool;
	var fog : Bool;
	function new( parameters : Dynamic ) : Void;
}
