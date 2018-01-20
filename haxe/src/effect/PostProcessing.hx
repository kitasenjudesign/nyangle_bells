package effect;
import three.PerspectiveCamera;
import three.postprocessing.EffectComposer;
import three.postprocessing.RenderPass;
import three.Renderer;
import three.Scene;

/**
 * ...
 * @author nabe
 */
class PostProcessing
{

	private var _renderPass:RenderPass;
	private var _composer:EffectComposer;
	
	//private var _bokehPass:BokehPass;
	
	private var _scene	:Scene;
	private var _camera	:PerspectiveCamera;
	
	public function new() 
	{
		
	}

	public function init(scene:Scene,camera:PerspectiveCamera,renderer:Renderer, w:Int,h:Int):Void {
		
		_scene = scene;
		_camera = camera;
		
		
		_renderPass = new RenderPass( scene, camera );

		_bokehPass = new BokehPass( scene, camera, {
				focus: 		1.0,//1.0,
				aperture:	0.025,
				maxblur:	2.0,
				width: w,
				height: h
		} );

		_bokehPass.renderToScreen = true;

		_composer = new EffectComposer( renderer );
		_composer.addPass( _renderPass );
		_composer.addPass( _bokehPass );

	}
	
	public function setting():Void {
		
		//_bokeh.uniforms[ "focus" ].value = effectController.focus;
		//_bokeh.uniforms[ "aperture" ].value = effectController.aperture;
		//_bokeh.uniforms[ "maxblur" ].value = effectController.maxblur;
		
	}
	
	
	public function render():Void {
		
		_composer.render(0.1);
		
	}
	
	
}