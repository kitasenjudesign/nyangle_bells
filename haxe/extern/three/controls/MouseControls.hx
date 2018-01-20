package three.controls;

@:native("THREE.MouseControls")
extern class MouseControls {
	var object : Object3D;
	function new( object : Object3D, ?domElement : js.html.Element ) : Void;
	function update() : Void;
}
