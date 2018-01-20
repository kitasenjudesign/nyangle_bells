package objects;
import js.Browser;
import js.html.CanvasElement;
import js.html.Uint8Array;
import three.Color;
import three.Geometry;
import three.Line;
import three.Matrix3;
import three.Matrix4;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PlaneBufferGeometry;
import three.PlaneGeometry;
import three.Texture;
import three.Vector3;

/**
 * ...
 * @author nabe
 */
class Lines extends Object3D
{

	private var _lines:Array<Mesh>;
	
	private static var _mat:MeshBasicMaterial;
	private static var _geo:PlaneGeometry;
	
	private var _width:Float = 400;
	private var _planeNo:Mesh;
	
	public function new() 
	{
		super();
	}
	
	public function init(ww:Float):Void {
	
		_width = ww;
		
		if ( _mat == null ) {
			_mat = new MeshBasicMaterial( { color:0xffffff,shading:Three.FlatShading } );
			_geo = new PlaneGeometry(_width, 9, 1, 1);

			var mm:Matrix4 = new Matrix4();
			mm.makeTranslation(_width/2, 0, 0);
			_geo.applyMatrix(cast mm);
			_geo.verticesNeedUpdate = true;
			
		}
		
		_lines = [];
		for (i in 0...5) {
			
			var m:Mesh = new Mesh(cast _geo, _mat);
			add(m);
			m.position.x = 0;
			m.position.y = -i * (20) + 77;
			_lines.push(m);
			
		}
		

		
		//updateText(0);
	}
	
	
	public function update(ary:Array<Float>):Void {
	
		for (i in 0..._lines.length) {
			
			var num:Float = ary[i];
			if (num > 1) num = 1;
			_lines[i].scale.x = num;
			//_lines[i].scale.y = Math.random();
			//_lines[i].scale.z = Math.random();
			
			
		}
		
		
	}
	
	/**
	 * 
	 * @param	col
	 */
	public function setColor(col:Int) 
	{
		trace("LINES COL----> " + col);
		_mat.color = new Color(col);
		
	}
	
}