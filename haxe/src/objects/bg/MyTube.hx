package lines;
import camera.ExCamera;
import sound.MyAudio3;
import three.CatmullRomCurve3;
import three.Color;
import three.ImageUtils;
import three.Material;
import three.Mesh;
import three.MeshBasicMaterial;
import three.MeshLambertMaterial;
import three.MeshPhongMaterial;
import three.Object3D;
import three.Texture;
import three.TubeGeometry;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class MyTube extends Object3D
{
	private var _curve:CatmullRomCurve3;
	private var _tubeGeo:TubeGeometry;
	private var _tubeMat:Material;
	
	private var _tubeMesh:Mesh;
	private var _tubeMesh2:Mesh;
	
	private var _center:Array<Vector3>;
	private var _ratio:Float = 0;
	var SEG_Z:Int;
	var SEG_R:Int;
	
	
	public function new() 
	{
		super();
	}
	
	public function init():Void {
		
		var positions:Array<Vector3> = new Array<Vector3>();
		for (i in 0...20) {
			var pos:Vector3 = new Vector3(
				40 * (Math.random() - 0.5),
				100 * (Math.random() - 0.5),
				i*100
			);
			positions.push(pos);
		}
		
		_curve = new CatmullRomCurve3(positions);		
		
		SEG_Z = 100;
		SEG_R = 40;
		
		var t:Texture = ImageUtils.loadTexture("looop2.jpg");
		t.wrapS = Three.RepeatWrapping;
		t.wrapT = Three.RepeatWrapping;
		t.repeat.set(80, 1);
		
		_tubeGeo = new TubeGeometry(cast _curve, SEG_Z-1, 20, SEG_R, false);
		_tubeMat = new MeshBasicMaterial(
			{ /*map:t,*/ 
				color: 0xff00ff,
				shading:Three.FlatShading, 
				side:Three.DoubleSide,
				//vertexColors:Three.VertexColors,
				//vertexColors: Three.VertexColors,
				wireframe:true
			}
		);
		_tubeMesh = new Mesh(
			_tubeGeo,
			_tubeMat
		);
		add( _tubeMesh );	
		
		_tubeMesh2 = new Mesh(
			_tubeGeo,
			new MeshBasicMaterial({color:0})
		);
		add( _tubeMesh2 );
		
		
		
		_center = [];
		for (i in 0...SEG_Z) {
			
			_center[i] = cast _curve.getPoint(i / SEG_Z);
			
		}
		
		for (i in 0...(SEG_R*SEG_Z)) {
			var nz:Int = Math.floor(i / SEG_R);
			var nr:Float = ( i % SEG_R ) / SEG_R;
			
			var amp:Float = 20;// 100 + 90 * Math.sin( nz / SEG_Z * 6 * Math.PI);
			//_tubeGeo.colors[i] = new Color(Math.floor(0xffffff*Math.random()));
			_tubeGeo.vertices[i].x = _center[nz].x + amp * Math.cos(nr * Math.PI * 2);
			_tubeGeo.vertices[i].y = _center[nz].y + amp * Math.sin(nr * Math.PI * 2);
		}
		
		for (i in 0..._tubeGeo.faces.length) {
			var col:Color = new Color(Math.floor(0xffffff*Math.random()));
			for(j in 0...3){
				
				_tubeGeo.faces[i].vertexColors[j] = col;// new Color(Math.floor(0xffffff * Math.random()));
				//_tubeGeo.faceUvs[i]
				
			}
		}
		
		_tubeGeo.verticesNeedUpdate = true;
		_tubeGeo.colorsNeedUpdate = true;
		_tubeGeo.computeVertexNormals();// = true;
		
	}
	

	public function update(cam:ExCamera,a:MyAudio3,plane:Object3D):Void {
				
		var v1:Vector3 = cast _curve.getPoint(_ratio);
		var v2:Vector3 = cast _curve.getPoint(_ratio+0.0001);
		
		//plane no taisei
		/*
		var v3:Vector3 = cast _curve.getPoint(_ratio + 0.006);
		var v4:Vector3 = cast _curve.getPoint(_ratio + 0.0061);
		plane.position.copy(v3);
		plane.lookAt(v4);
		var nn:Float = a.freqByteData[3] / 255;
		plane.up = new Vector3(Math.cos(nn),Math.sin(nn),0);
		*/
		
		for (i in 0...(SEG_R*SEG_Z)) {
			var nz:Int = Math.floor(i / SEG_R);
			var nr:Float = ( i % SEG_R ) / SEG_R;
			
			var amp:Float = 15 + 5 * _getNoise(nr, a.freqByteData[6] / 255, _ratio);
			var rr:Float =  Math.pow( a.freqByteData[nz % 20] / 255, 2) * 1.5 * Math.PI;
			
			var tgt1:Float = _center[nz].x + amp * Math.cos(nr * Math.PI * 2 + rr);
			var tgt2:Float = _center[nz].y + amp * Math.sin(nr * Math.PI * 2 + rr);
			
			_tubeGeo.vertices[i].x += (tgt1 - _tubeGeo.vertices[i].x ) / 1;
			_tubeGeo.vertices[i].y += (tgt2 - _tubeGeo.vertices[i].y ) / 1;
		}
		_tubeGeo.verticesNeedUpdate = true;
		_tubeGeo.computeVertexNormals();// = true;
		
		cam.position.copy(v1);
		cam.lookAt(v2);
		
		_ratio += 0.0008;// + a.freqByteData[3] / 255 * 0.0002;
		if (_ratio >= 1) {
			_ratio = 0;
		}
	}
	
	
	private function _getNoise(xx:Float,yy:Float,zz:Float):Float
	{
		//var f = untyped __js__("noise.perlin3");
		//var n:Float = f(xx, yy, zz);
		return 1;
	}	
	
	/**
	 * getCurve
	 * @return CatmullRomCurve3
	 */
	public function getCurve():CatmullRomCurve3 {
		return _curve;
	}
	
	public function getRatio():Float {
		return _ratio;
	}
	
}