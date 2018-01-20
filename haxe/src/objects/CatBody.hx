package objects;
import shaders.MaeShaderMaterial;
import three.Geometry;
import three.ImageUtils;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PlaneGeometry;
import three.Texture;
import three.Vector2;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class CatBody extends Mesh
{

	public static var SEG_Z:Int = 10;
	
	private var _base	:Array<Vector2>;
	private var _base2	:Array<Vector2>;
	private var _geo	:Geometry;
	private static var _mate	:MaeShaderMaterial;
	
	public function new() 
	{
		
		_base = [
			new Vector2( 0,	0.15793),//0
			new Vector2( -0.03581,	0.14858),//1
			new Vector2( -0.07219,	0.10586),//2
			new Vector2( -0.09726,	0.05336),//3
			new Vector2( -0.09811,	0.00179),//4
			new Vector2( -0.09122,	-0.07178),//5
			new Vector2( -0.0645,	-0.12716),//6
			new Vector2( 0,	-0.13991),//7
			new Vector2( 0.0645,	-0.12716),//8
			new Vector2( 0.09122,	-0.07178),//9
			new Vector2( 0.09862,	0.00179),//10
			new Vector2( 0.09921,	0.05336),//11
			new Vector2( 0.07414,	0.10586),//12
			new Vector2( 0.03624,	0.14858),//13
			new Vector2( 0,	0.15793)//0
		];
		
		_base2 = [		
			new Vector2( 0,	0.14884),
			new Vector2( -0.03581,	0.1395),
			new Vector2( -0.07219,	0.09677),
			new Vector2( -0.09726,	0.04428),
			new Vector2( -0.09811,	-0.0073),
			new Vector2( -0.09122,	-0.08087),
			new Vector2( -0.0645,	-0.13625),
			new Vector2( 0,	-0.149),
			new Vector2( 0.0645,	-0.13625),
			new Vector2( 0.09122,	-0.08087),
			new Vector2( 0.09862,	-0.0073),
			new Vector2( 0.09921,	0.04428),
			new Vector2( 0.07414,	0.09677),
			new Vector2( 0.03624,	0.1395),
			new Vector2( 0,	0.14884)//last
		
		];
		var g:PlaneGeometry = new PlaneGeometry(100,100,_base.length-1,SEG_Z);
		
		
		if ( _mate == null ){
			
			/*
			var tex:Texture = ImageUtils.loadTexture("cat/body.png");
				tex.wrapS = Three.RepeatWrapping;
				tex.wrapT = Three.RepeatWrapping;
				tex.repeat.set( 1, 4 );
			
			_mate = new MeshBasicMaterial( { map:tex } );
			*/
			
			_mate = new MaeShaderMaterial("obj/cat/body.png",4);
			
		}
		
		super(g, _mate);
		
		//x
		//z
		
	}
	
	/**
	 * init();
	 */
	public function init():Void {
		
		
		geometry.verticesNeedUpdate=true;//これを忘れずに書く
		
		//okuyuki
		var depth:Float = 1;
		var segX:Int = _base.length;
		for (j in 0...SEG_Z+1 ) {
			for (i in 0...segX) {	
				//wakka tsukuru!!!!!!
				
				//(i,j)のvertexを得る
				var index:Int = j * (segX) + i % (segX);
				var vertex:Vector3 = geometry.vertices[index];
				//時間経過と頂点の位置によって波を作る
				var v:Vector2 = _getPos(i, j / (SEG_Z));
				
				var s:Float = 1;// Math.sin(j / 2) + 1;
				
				vertex.x = v.x * s;
				vertex.y = -j / SEG_Z * depth;
				vertex.z = -v.y * s;
				
			}
		}
		/*
		var hip:Object3D = _dataManager.cats.hip.mesh.clone();
		hip.scale.set(1, 1, 1);
		hip.position.y = -1.63743;
		_cat.add( hip );
		*/
		
		/*
		 * 
			plane.geometry.verticesNeedUpdate=true;//これを忘れずに書く
			for (var i=0;i<SEGX+1;i++) {
				for (var j=0;j<SEGY+1;j++) {
					//(i,j)のvertexを得る
					var index = j * (SEGX + 1) + i % (SEGX + 1);
					var vertex = plane.geometry.vertices[index];
					//時間経過と頂点の位置によって波を作る
					var amp=100;//振幅
					vertex.z = amp * Math.sin( -i/2 + time*15 );
				}           
			}	
		*/
	}
	
	/**
	 * updateCenterSize
	 */
	public function updateDoubleSize(size:Float):Void {
		this.position.y = size;
		this.scale.y = size * 2;
	}
	
	public function updateFrontSize(size:Float):Void {
		this.position.y = size;
		this.scale.y = size;		
	}
	
	/**
	 * update
	 */
	public function update():Void {
		
		//dokomade nobasuka
		
	}
	
	public function setStart(posY:Float):Void 
	{
		this.position.y = posY;
		if(posY>0){
			this.scale.y = posY; // nobashiteru
			this.visible = true;
		}else {
			this.visible = false;
		}
	}
	
	private function _getPos(i:Int,ratio:Float):Vector2 {
		
		return new Vector2(
			_base[i].x * (1-ratio) + _base2[i].x * (ratio),
			_base[i].y * (1-ratio) + _base2[i].y * (ratio)
		);
		
	}
	
}