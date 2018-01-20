package three;

@:native("THREE.Animation")
extern class Animation {
    var root : Mesh;
    var data : Dynamic; // TODO: find a type for THREE.AnimationHandler.get(data)
    var hierarchy : Array<Bone>; // TODO: ensure type
    var currentTime : Float; // 0
    var timeScale : Float; // 1
    var isPlaying : Bool; // false
    var isPaused : Bool; // true
    var loop : Bool; // true
    var interpolationType : Int; // AnimationHandler.LINEAR
    var points : Array<Array<Float>>;
    var target : Vector3;
    
	var weight:Float;
	
	//function new(root:Mesh, name:String, ?interpoltionType:Int) : Void;
	function new(root:Mesh, data:Dynamic) : Void;

    //function play(loop:Bool, startTimeMS:Float) : Void;
	
	function play(startTimeMS:Float,weight:Float) : Void;
	
	
    function pause() : Void;
    function stop() : Void;
    function update(deltaTimeMS: Float) : Void;
}
