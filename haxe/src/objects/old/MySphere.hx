package objects;
import sound.MyAudio;
import three.Geometry;
import three.ImageUtils;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.Sphere;
import three.SphereGeometry;
import three.Texture;
import three.Vector3;

/**
 * ...
 * @author nabe
 */
class MySphere extends Object3D
{
	
	private var _base:Array<Vector3>;
	private var mesh:Mesh;
	private var _count:Float = 0;
	private var _nejireX:Float = 0;
	private var _nejireY:Float = 0;
	private var _audio:MyAudio;
	private var _noise:Float=0;
	private var _sphere:Float=0;
	private var _noiseSpeed:Float=0;
	private var _scale:Float=0;
	private var _speed:Float=0;
	private var _vr:Float=0;

	private var _tateScaleY:Float = 1;
	private var _tateScaleXZ:Float = 1;
	

	public function new() 
	{
		
		super();
		
		var texture:Texture = ImageUtils.loadTexture( '_hoge.jpg' );

		var mate:MeshBasicMaterial = new MeshBasicMaterial( { map: texture/*,side:Three.DoubleSide*/ } );
		var g:SphereGeometry =             new SphereGeometry(400, 60, 30 );
		mesh = new Mesh( g,mate);
		//mesh.frustumCulled = false;
		mesh.position.z = 0;
		mesh.scale.x = -1;
		mesh.rotation.y = Math.PI / 2;
		mesh.receiveShadow = true;
		
		mesh.geometry.verticesNeedUpdate = true;
		_base = [];
		
		for (i in 0...g.vertices.length) {
			_base.push(g.vertices[i].clone());
		}
		
		
		add( mesh );
	}
	
	
	
	
	public function update(audio:MyAudio):Void {
		
		_audio = audio;
		
		var g:Geometry = mesh.geometry;
		g.verticesNeedUpdate = true;
		_count += _speed;
		_vr *= 0.97;
		this.rotation.y += _vr;
		
		if (_audio!=null && _audio.isStart) {
			_audio.update();
			
			//trace( _audio.freqByteData[14]);
			var pp:Float = (Math.pow( _audio.freqByteData[18] / 255 , 6) ) * 0.2;
			_vr += pp;
			
			_nejireX = Math.pow(_audio.freqByteData[19] / 255, 3.5) * 0.02;
			_nejireY = Math.pow(_audio.freqByteData[11] / 255, 4.5);
			
			_noise = Math.pow(_audio.freqByteData[13] / 255, 4) * 0.8;
			_speed =  Math.pow( _audio.freqByteData[8] / 255, 4) * 0.2;
			_sphere =  0;// Math.pow( _audio.freqByteData[4] / 255, 15);
			_noiseSpeed = 0.01 + Math.pow( _audio.freqByteData[19] / 255, 15) * 0.1;
			_scale = 1 + Math.pow(_audio.freqByteData[1] / 255, 5) * 1;
			
			_tateScaleY = 1 + Math.pow(_audio.freqByteData[6] / 255, 5) * 0.7;
			_tateScaleXZ = 1 + Math.pow(_audio.freqByteData[7] / 255, 5) * 0.5;
			
		}
		
		
		//
		
		for (i in 0...g.vertices.length) {
			
			var vv:Vector3 = _base[i];

			var a:Float = Math.sqrt( vv.x * vv.x + vv.y * vv.y + vv.z * vv.z);
			var radX:Float = -Math.atan2(vv.z, vv.x) + vv.y * Math.sin(_count+vv.y/ (500*_scale) ) * _nejireX;//横方向の角度
			var radY:Float = Math.asin(vv.y / a);// + _nejireY;//縦方向の角度

			var amp:Float = (1-_sphere) * a + (_sphere) * 1;
			amp += Math.sin(_count * 0.7) * _getNoise(vv.x, vv.y + _count * _noiseSpeed, vv.z) * _noise;

			//amp *= _scale;
			
			g.vertices[i].x = amp * Math.sin( radX ) * Math.cos(radY);//横
			g.vertices[i].y = amp * Math.sin(radY) + 600 *_nejireY* Math.sin(Math.atan2(vv.z, vv.x)*2+_count*0.3);
			g.vertices[i].z = amp * Math.cos(radX ) * Math.cos(radY);//横
			
			//g.faces[i].vertexColors
		}
		
		this.scale.set(_tateScaleXZ, _tateScaleY, _tateScaleXZ);
		
		
	}
		
		
	private function _getNoise(xx:Float,yy:Float,zz:Float):Float
	{
		var f = untyped __js__("noise.perlin3");
		var n:Float = f(xx, yy, zz);
		return n;
	}
	
	
	
	
	
	
	
	
	
}