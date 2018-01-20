package sound;
import three.Geometry;
import three.Line;
import three.LineBasicMaterial;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author nabe
 */
class DummyBars extends Object3D
{

	
	private var _lines:Array<Line>;
	
	public function new() 
	{
		super();
	}
	
	public function init():Void {
	
		
		_lines = [];
		var m:LineBasicMaterial = new LineBasicMaterial( { color:0xff0000 } );
		for ( i in 0...MyAudio.FFTSIZE) {
		
			var g:Geometry = new Geometry();
			g.vertices.push(new Vector3(0, 0, 0));
			g.vertices.push(new Vector3(100, 0, 0));
			var line:Line = new Line(g, m);
			line.position.y = i * 10;
			line.position.z = 1400;
			add(line);
			
			_lines.push(line);
		}
		
	}
	
	public function update(audio:MyAudio):Void {
	
		
		
		if (audio!=null && audio.isStart) {
		
			for (i in 0..._lines.length) {
				
				_lines[i].scale.set(audio.freqByteData[i]/255*2, 1, 1);
				
			}
		
		}
	}
	
}