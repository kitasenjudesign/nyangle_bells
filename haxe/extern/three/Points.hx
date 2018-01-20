package three;

@:native("THREE.Points")
extern class Points extends Object3D {
	var geometry : Geometry;
	var material : Material;
	var sortParticles : Bool; // false
	// var frustumCulled : Bool; // false
	function new( geometry : Geometry, ?material : Material ) : Void;
	// override function clone(?object:ParticleSystem) : ParticleSystem;
}
