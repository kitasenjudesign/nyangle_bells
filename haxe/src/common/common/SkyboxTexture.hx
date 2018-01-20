package common;
import three.BoxGeometry;
import three.CubeCamera;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Scene;
import three.SphereGeometry;
import three.Texture;
import three.TextureLoader;
import three.WebGLRenderer;
import three.WebGLRenderTargetCube;

/**
 * ...
 * @author watanabe
 */
class SkyboxTexture
{

	private var _box:Mesh;
	private var _boxMaterial:MeshBasicMaterial;
	private var _scene:Scene;
	private var _cubeCam:CubeCamera;
	
	public function new() 
	{
		
	}

	/**
	 * 
	 * @param	texture
	 */
	public function init(texture:Texture):Void {
		
		if (_scene == null) {
			
			_cubeCam = new CubeCamera(10, 500, 256);
			_boxMaterial = new MeshBasicMaterial({color:0xffffff,side:Three.DoubleSide});
			_scene = new Scene();

			_scene.add(_cubeCam);
			
			_box = new Mesh(
				//new BoxGeometry(200, 200, 200, 1, 1, 1),
				new SphereGeometry(100,10,10),
				_boxMaterial
			);
			_scene.add(_box);
		}
		_boxMaterial.map = texture;
	}
	
	
	public function getTexture():Texture {
		
		return cast _cubeCam.renderTarget.texture;
		//cubeCamera2.renderTarget.texture
		
	}
	
	public function update(renderer:WebGLRenderer):Void {
		
		_cubeCam.updateCubeMap( renderer, _scene );
		//_renderer.render(_scene, _camera);
		
	}
	
}