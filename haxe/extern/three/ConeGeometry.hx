package three;

@:native("THREE.ConeGeometry")
extern class ConeGeometry extends Geometry {
	//var parameters : BoxParameters;
	//function new( width : Float, height : Float, depth : Float, ?widthSegments : Float, ?heightSegments : Float, ?depthSegments : Float ) : Void;

	function new(
		radius:Float, height:Float, ?radialSegments:Int, ?heightSegments:Int,?openEnded:Bool, ?thetaStart:Int, ?thetaLength:Int
	);
	
}


