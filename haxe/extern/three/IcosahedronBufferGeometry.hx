package three;

/*
typedef IcosahedronGeometryParameters = {
	var radius : Float;
	var detail : Int;
}*/

@:native("THREE.IcosahedronBufferGeometry")
extern class IcosahedronBufferGeometry extends PolyhedronGeometry {
	//var parameters : IcosahedronGeometryParameters;
	function new(?radius:Float, ?detail:Int) : Void;
}

//IcosahedronBufferGeometry(radius, detail)