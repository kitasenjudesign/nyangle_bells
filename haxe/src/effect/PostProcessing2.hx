package effect;
import effect.shaders.CopyShader;
import effect.shaders.Dhiza;
import effect.shaders.MyTiltShiftShader;
import effect.shaders.VignetteShader;
import objects.MySphere;
import sound.MyAudio;
import three.Object3D;
import three.PerspectiveCamera;
import three.postprocessing.BloomPass;
import three.postprocessing.EffectComposer;
import three.postprocessing.RenderPass;
import three.postprocessing.ShaderPass;
import three.Renderer;
import three.Scene;
import three.WebGLRenderer;

/**
 * ...
 * @author nabe
 */
class PostProcessing2
{

	private var _renderPass:RenderPass;
	private var _composer:EffectComposer;
	
	public var vig:ShaderPass;
	public var tilt:ShaderPass;
	public var dhiza:ShaderPass;
	
	private var _scene	:Scene;
	private var _camera	:PerspectiveCamera;
	private var _copyPass:ShaderPass;
	private var _rad:Float=0;
	private var _renderer:WebGLRenderer;
	
	public function new() 
	{
		
	}

	public function init(scene:Scene,camera:PerspectiveCamera,renderer:WebGLRenderer):Void {
		
		_scene = scene;
		_camera = camera;
		_renderer = renderer;
		
		_renderPass = new RenderPass( scene, camera );
		//_renderPass
		_copyPass = new ShaderPass( CopyShader.getObject() );
		
		_composer = new EffectComposer( renderer );
		_composer.addPass( _renderPass );
		
		tilt = new ShaderPass(MyTiltShiftShader.getObject());
		vig = new ShaderPass( VignetteShader.getObject() );
		dhiza = new ShaderPass(Dhiza.getObject());
		
		/*
		tilt.clear = false;
		vig.clear = false;
		dhiza.clear = false;
		*/
		
		_composer.addPass(tilt);
		_composer.addPass(vig);
		//_composer.addPass(dhiza);
		_composer.addPass( _copyPass );
		
		_copyPass.clear = true;
		_copyPass.renderToScreen = true;
	
	}
	
	public function setting():Void {
		
	
		//_bokeh.uniforms[ "focus" ].value = effectController.focus;
		//_bokeh.uniforms[ "aperture" ].value = effectController.aperture;
		//_bokeh.uniforms[ "maxblur" ].value = effectController.maxblur;
		
	}
	
	
	public function render():Void {
		
		//_digital.uniforms.seed_x.value = Math.random();
		
	//	v.uniforms.offset.value = 1.0;// Math.random();
		//v.uniforms.darkness.value = 1.0;
		
		_composer.render();//render2
		
		
	}
	
	public function update(audio:MyAudio) 
	{
		/*
		tilt.uniforms.v.value = 2 / 512 + 1 / 512 * Math.sin(_rad);
		_rad += Math.PI / 100;
		
		if (audio!=null && audio.isStart) {
			vig.uniforms.darkness.value = 1.1-Math.pow(audio.freqByteData[10] / 255, 4.5)*0.1;
		}*/
	}
	
	
}