package objects;
import camera.ExCamera;
import common.Dat;
import js.Browser;
import sound.MyAudio;
import three.BoxGeometry;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PlaneBufferGeometry;

/**
 * ...
 * @author watanabe
 */
class CatsGenerators extends CatsBase
{

	
	public static inline var SPACE:Float = 200;
	
	
	private var _ground:Mesh;
	private var _generators:Array<CatsGenerator>;
//	private var space:Float = 100;
	private var numX:Int = 6;
	private var numY:Int = 6;
	private var _count:Int = 0;
	
	public function new() 
	{
		super();
	}
	
	
	override public function init(cam:ExCamera):Void {
		
		_cam = cam;
		_generators = [];
		
		//var center:Mesh = new Mesh(new BoxGeometry(30, 30, 30, 1, 1, 1), new MeshBasicMaterial( { color:0xff00ff } ));
		//add(center);		
		
		//seiseisuru
		
		//0,1,2,3
		var count:Int = 0;
		for (i in 0...numX) {
			for (j in 0...numY) {
				
				var gen:CatsGenerator = new CatsGenerator();
				if (count > 31) count = 31;
				gen.init(count);
				
				gen.rotation.x = Math.random() * 2 * Math.PI;
				gen.rotation.y = Math.random() * 2 * Math.PI;
				gen.rotation.z = Math.random() * 2 * Math.PI;	
				
				gen.position.x = i * SPACE - SPACE * numX / 2 + SPACE / 2;
				gen.position.z = j * SPACE - SPACE * numY / 2 + SPACE / 2;
				add(gen);
				_generators.push(gen);
				count++;
				
			}
		}
		
		reposition(1, 1);
		
		_fuyasu();
		//_onKeyDown(null);
		//Browser.document.addEventListener("keydown", _onKeyDown);

	}
	
	
	private function _onKeyDown(e):Void {
	
		trace("keydown");
		var ary:Array<Int> = [3,4,5,6];//[1,2,3,4,5,6];
		
		switch(Std.parseInt(e.keyCode)) {			
			case Dat.RIGHT:		
				_fuyasu();
				
			case Dat.LEFT:		
				_count--;
				if (_count < 0)_count = ary.length - 1;
				var n:Int = ary[_count];
				reposition(n, n);
				
		}
	}
	
	private function _fuyasu():Void {
		
		var ary:Array<Int> = [3,4,5,6];//[1,2,3,4,5,6];
		
		var n:Int = ary[_count];
		_count++;
		_count = _count % ary.length;
		
		reposition(n, n);
		
	}
	
	override public function restart():Void
	{
		for (i in 0..._generators.length) {
			_generators[i].reset();
		}
	
		_cam.radX = (Math.random() - 0.5) * Math.PI * 0.4;
		_cam.radY = (Math.random() - 0.5) * Math.PI * 0.8;
		_cam.amp = 200 + 800 * Math.random();
		
		_fuyasu();///////////////////////////////////////fuyashiteiku
		
	}	
	
	public function gen():Void{
		
		var gen:CatsGenerator = _generators[Math.floor(_generators.length*Math.random())];
		gen.gen(Math.random());
		
	}
	
	
	/**
	 * 
	 * @param	nx
	 * @param	ny
	 */
	public function reposition(nx:Int,ny:Int):Void {
		
		this.rotation.x = Math.PI / 2;
		
		for (i in 0..._generators.length) {
			_generators[i].visible = false;
		}
		
		var cnt:Int = 0;
		for (i in 0...nx) {
			for (j in 0...ny) {
		
				var gen:CatsGenerator = _generators[cnt];
				gen.visible = true;
				gen.position.x = i * SPACE - SPACE * nx / 2 + SPACE / 2;
				gen.position.z = j * SPACE - SPACE * ny / 2 + SPACE / 2;
				cnt++;
				
			}
		}
		
		
		
	}
	
	
	
	//audio wo watasu
	override public function update(a:MyAudio):Void {
		
		//trace("===update==");
		
		for (i in 0..._generators.length) {
			if(_generators[i].visible){
				_generators[i].update(a);
			}
		}
		
	}
	
}