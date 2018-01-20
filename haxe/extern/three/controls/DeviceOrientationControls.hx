package three.controls;

@:native("THREE.DeviceOrientationControls")
extern class DeviceOrientationControls {
	
	
	var object : Object3D;
	function new( object : Object3D, ?domElement : js.html.Element ) : Void;
	function update() : Void;
	function connect() : Void;
	/*
				controls = new THREE.DeviceOrientationControls(camera, true);
			controls.connect();
			controls.update();*/
}
