package light;
import common.Dat;
import three.DirectionalLight;
import three.Object3D;
import three.Scene;
import three.Vector3;

/**
 * ...
 * @author 
 */
class DLight extends DirectionalLight
{

	public var amp	:Float = 500;
	public var radX :Float = 0.001;
	public var radY	:Float = 0.001;
	//public var target:Vector3;
	private var _obj:Object3D;
	
	public function new(hex:Int, intensity:Float, scene:Scene) 
	{
		super(hex, intensity);
		//target = new Vector3();
		
		//dLight.position.x = 200;
		//dLight.position.y = 500;
		//dLight.position.z = 200;
		
		var size:Float = 1000;
		castShadow = true;
		shadow.camera.near = 1;
		shadow.camera.far = 1000;
		shadow.camera.right = size;
		shadow.camera.left = - size;
		shadow.camera.top	= size;
		shadow.camera.bottom = - size;
		shadow.mapSize.width = 1024;
		shadow.mapSize.height = 1024;
		shadowCameraVisible = true;
					
		
		
		radY = Math.PI / 4;
		
		_obj = new Object3D();
		scene.add(_obj);
		this.target = _obj;
		
		Dat.gui.add(this, "radX", -6.28, 6.28).listen();
		Dat.gui.add(this, "radY", -6.28, 6.28).listen();
		
		/*
		Dat.gui.add(this.target.position, "x", -2000, 2000).listen();
		Dat.gui.add(this.target.position, "y", -2000, 2000).listen();
		Dat.gui.add(this.target.position, "z", -2000, 2000).listen();		
		
		Dat.gui.add(this.position, "x", -2000, 2000).listen();
		Dat.gui.add(this.position, "y", -2000, 2000).listen();
		Dat.gui.add(this.position, "z", -2000, 2000).listen();				
		*/
	}
	
	
	public function update( tt:Vector3 ):Void{
				

		//trace(tt);
		//return;
		
		if (tt == null) return;
		
		target.position.x = tt.x;
		target.position.y = tt.y;
		target.position.z = tt.z;
		
		var amp1		:Float 	= this.amp * Math.cos(this.radY);
		var xx		:Float 		= tt.x + amp1 * Math.sin( this.radX );//横
		var yy		:Float 		= tt.y + this.amp * Math.sin(this.radY) ;
		var zz		:Float 		= tt.z + amp1 * Math.cos( this.radX );//横
		
		position.x = xx;
		position.y = yy;
		position.z = zz;
		
		
	}
	
	
}