package objects;
import three.BoxGeometry;
import three.Geometry;
import three.Line;
import three.LineBasicMaterial;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshLambertMaterial;
import three.Object3D;
import three.Shape;
import three.ShapeGeometry;
import three.Vector3;
import tween.TweenMax;

/**
 * ...
 * @author watanabe
 */
class Ground extends Object3D
{

	private static var geo:BoxGeometry;
	private static var mate:MeshLambertMaterial;
	
	private var line:Line;
	private var circle:Mesh;
	private var circleMat:MeshBasicMaterial;
	private var light:Float = 1;
	
	public static var lineGeo:Geometry;
	public static var shapeGeo:ShapeGeometry;
	
	
	public function new() 
	{
		super();
	}
	
	public function init():Void {
	
		var ww:Float = CatsGenerators.SPACE/2;
		
		if (geo == null) {
			geo = new BoxGeometry(ww, ww, ww, 1, 1, 1);
			mate = new MeshLambertMaterial( { color:0x008800, side:Three.DoubleSide } );
			
			lineGeo = new Geometry();
			var shape:Shape = new Shape();
			
			for(i in 0...20){
				lineGeo.vertices.push(
					new Vector3(
						ww / 2 * Math.cos(i / 19 * 2 * Math.PI), 
						0, 
						ww / 2 * Math.sin(i / 19 * 2 * Math.PI)
					)
				);
				
				if (i == 0) {
					shape.moveTo(
						ww / 2 * Math.cos(i / 19 * 2 * Math.PI),
						ww / 2 * Math.sin(i / 19 * 2 * Math.PI)
					);
				}else {
					shape.lineTo(
						ww / 2 * Math.cos(i / 19 * 2 * Math.PI),
						ww / 2 * Math.sin(i / 19 * 2 * Math.PI)
					);
				}
			}
			
			shapeGeo = new ShapeGeometry(shape);
			
		}
		
		circleMat = new MeshBasicMaterial( { color:0x000000 } );
		circle = new Mesh(shapeGeo, circleMat);
		circle.rotation.x = -Math.PI / 2;
		circle.position.y = ww/2+1;
		add(circle);
		
		line = new Line(
			lineGeo,
			new LineBasicMaterial( { color:0xddaa33,linewidth:2 } )
		);
		add(line);
		line.position.y = ww / 2+2;
		
		var m:Mesh = new Mesh(
			geo, mate
		);
		add(m);
		
		
		
		this.position.y = - ww / 2;
		
	}
	
	public function flash():Void {
		this.light = 0.3;
		TweenMax.to(this, 0.5, {
			light:0,
			onUpdate:_onFlash
		});
	}
	
	function _onFlash() 
	{
		circleMat.color.setRGB(
			light * 0xdd / 0xff,
			light * 0xaa / 0xff,
			light * 0x33 / 0xff
		);
	}
	
	public function setScale(s:Float) 
	{
		line.scale.set(s, 1, s);
		circle.scale.set(s, s, s);
	}
	
}