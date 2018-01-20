package three;

@:native("THREE.CatmullRomCurve3")
//CatmullRomCurve3
extern class CatmullRomCurve3 extends Curve3{
    function new(?points:Array<Vector3>) : Void;
	
    //function getPoint(t:Float) : Vector3;
    //function getPoints(divisions:Int) : Array<Vector3>;
    /*
	@:overload(function(divisions:Int) : Array<Vector3> {})
    override function getSpacedPoints(divisions:Int) : Array<Vector2>;
    @:overload(function(t:Float) : Vector3 {})
    override function getNormalVector(t:Float) : Vector2;
    @:overload(function(t:Float) : Vector3 {})
    override function getTangent(t:Float) : Vector2;
    @:overload(function(u:Float) : Vector3 {})
    override function getTangentAt(u:Float) : Vector2;
	*/
}
