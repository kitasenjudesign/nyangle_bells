package com.neymarshot.effect;
import com.neymarshot.effect.shaders.CopyShader;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PerspectiveCamera;
import three.PlaneGeometry;
import three.postprocessing.BloomPass;
import three.postprocessing.EffectComposer;
import three.postprocessing.RenderPass;
import three.postprocessing.ShaderPass;
import three.Scene;
import three.WebGLRenderer;
import three.WebGLRenderTarget;

/**
 * ...
 * @author watanabe
 */
class OffscreenRenderer extends Object3D
{

	private var _renderTarget	:WebGLRenderTarget;
	private var _mesh			:Mesh;
	
	private var _renderPass:RenderPass;
	private var _composer:EffectComposer;
	private var _copyPass:ShaderPass;
	
	//private var _bloomPass:BloomPass;
	
	//private var 
	
	public function new() 
	{
		super();
	}

	public function init(scene:Scene,camera:PerspectiveCamera,r:WebGLRenderer):Void {
		//offscreen
		
		_renderTarget = new WebGLRenderTarget(1024, 512, {});
		
		var s:Float = 2;
		_mesh = new Mesh(
			new PlaneGeometry(1024*s, 512*s),
			new MeshBasicMaterial( { map:_renderTarget } )
		);
		_mesh.position.y = 256*s;
		add(_mesh);
		
				
		
		_copyPass = new ShaderPass( CopyShader.getObject() );
		_composer = new EffectComposer( r,_renderTarget );
		_composer.addPass( new RenderPass( scene, camera ) );
		_composer.addPass( new BloomPass(1, 25, 4.0, 512));
		_composer.addPass( _copyPass );
		
		//_copyPass.clear = false;
		_copyPass.renderToScreen = true;
		
		
	}
	
	public function setting():Void {
		
		//_bokeh.uniforms[ "focus" ].value = effectController.focus;
		//_bokeh.uniforms[ "aperture" ].value = effectController.aperture;
		//_bokeh.uniforms[ "maxblur" ].value = effectController.maxblur;
		
	}
	
	
	public function render():Void {
		
		//_digital.uniforms.seed_x.value = Math.random();
		//_composer.render();
		
	}
	
	
	
	
	
	
	
	public function update(r:WebGLRenderer,s:Scene,c:PerspectiveCamera):Void {
		r.render(s, c, _renderTarget, true );
		//_composer.render();
	}
	
}