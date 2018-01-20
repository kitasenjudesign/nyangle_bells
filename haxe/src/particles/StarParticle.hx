package particles;
import data.Params;
import three.Color;
import three.Geometry;
import three.ImageUtils;
import three.Object3D;
import three.Points;
import three.PointsMaterial;
import three.Vector3;

/**
 * ...
 * @author 
 */
class StarParticle extends Object3D
{

	public function new() 
	{
	
		super();
			
		
		var geometry:Geometry = new Geometry();
		var size:Float = 12000;
		
		var colors:Array<Color> = [
			new Color(0xff0000),
			new Color(0x00ff00),
			new Color(0xffff00)
		];
		
		for (i in 0...3000) {
			var x:Float = (Math.random()-0.5) * size;
			var y:Float = (Math.random()-0.5) * size;
			var z:Float = (Math.random()-0.5) * size;
			geometry.vertices.push(new Vector3(x, y, z));
			geometry.colors.push(colors[i%colors.length]);
		}

		var material:PointsMaterial = new PointsMaterial({
		   color: 0xffffff,
		   size: 50,
		   map: ImageUtils.loadTexture("./img/star.png"),
		   vertexColors:Three.VertexColors,
		   transparent:true
		});

		var points:Points = new Points(geometry, material);
		add(points);
		points.position.z = Params.distance / 2;
		points.frustumCulled = false;
		
	}
	
	
	
}