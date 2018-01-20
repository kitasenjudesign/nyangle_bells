package objects.bg;
import data.Params;
import js.html.Float32Array;
import three.BufferAttribute;
import three.Mesh;
import three.SphereBufferGeometry;
import three.Vector3;

/**
 * BgSphere05
 * @author 
 */
class BgSphere03 extends Mesh
{

	private var _mat:BgShaderMat03;
	
	public function new() 
	{
		
		var g:SphereBufferGeometry = new SphereBufferGeometry(Params.FAR*0.9, 10, 10);
		
		var nn:Int = g.attributes.position.length;
		var colors:Float32Array = new Float32Array(nn * 3);
		for ( i in 0...nn ) {
			colors[i * 3 + 0] = Math.random();//color0
			colors[i * 3 + 1] = Math.random();
			colors[i * 3 + 2] = Math.random();
		}
		
		//colors
		g.addAttribute('color', new BufferAttribute( colors, 3 ) );		
		
		_mat = new BgShaderMat03();
		_mat.fog = false;
		
		///_mat.wireframe = true;
		super(cast g,cast _mat);
		
	}
	
	
	public function init():Void{
		
		_mat.init();
		
	}
	
	public function startBlack(delay:Float):Void{
		_mat.startBlack(delay);
	}

	public function startWhite(time:Float, delay:Float):Void{
		
		//もっとブルーになって、その後、しろになる
		_mat.startWhite(time, delay);
		
	}
	
	
	
	public function startBlue():Void{
		
		//背景を青意のがスタートする
		_mat.startBlue();
	}
	
	public function tweenColor(v:Vector3,time:Float = 1, delay:Float=0):Void{
		_mat.tweenColor(v, time, delay);
	}
	
	public function tweenOffsetCol(v:Vector3,time:Float = 1,delay:Float=0):Void{
		_mat.tweenOffsetCol(v, time, delay);
	}
	
	
	public function update(cnt:Float):Void{
		if(_mat!=null){
			_mat.update(cnt);
		}
	}
	
}