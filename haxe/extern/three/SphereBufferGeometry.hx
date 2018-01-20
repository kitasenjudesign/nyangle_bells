package three;

import three.Geometry;
@:native("THREE.SphereBufferGeometry")
extern class SphereBufferGeometry extends BufferGeometry {
	//var parameters : SphereParameters;
	function new( ?radius : Float, ?segmentsWidth : Float, ?segmentsHeight : Float, ?phiStrat : Float, ?phiLength : Float, ?thetaStart : Float, ?thetaLength : Float ) : Void;
}