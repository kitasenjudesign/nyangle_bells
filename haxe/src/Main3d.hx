package ;

import camera.ExCamera;
import common.Dat;
import data.DataManager;
import data.Params;
import html.Page;
import js.Browser;
import light.DLight;
import objects.bg.BgSphere;
import objects.bg.Ground;
import particles.StarParticle;
import particles.papers.KamiParticle;
import sound.MyAudio;
import three.AmbientLight;
import three.BoxGeometry;
import three.CameraHelper;
import three.Color;
import three.Fog;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Scene;
import three.WebGLRenderer;
/**
 * ...
 * @author nabe
 */

class Main3d
{
	
	public static  var W:Int = 1280;// 1280;
	public static  var H:Int = 720;// 768;// 1920;
	
	
	private var _scene		:Scene;
	private var _camera		:ExCamera;
	private var _renderer	:WebGLRenderer;
	
	private var _audio:MyAudio;
	private var _dataManager:DataManager;
	
	private var _xmasPlayer:XmasPlayer;
	
	private var _bg:BgSphere;
	//private var _papers:PaperParticles;
	private var dLight:DLight;
	
	//ぼうしwotukeru
	//音wosaisei
	//neko dakenisuru
	//1jikan kuraide
	
	public function new() 
	{
		//_init();
	}
	
	public function init() 
	{
		Page.init();
		_onLoad();	
	}
	
	private function _onLoad():Void {
	
		Dat.init(_onLoad1);
	}
	
	private function _onLoad1():Void{
		
		_dataManager = DataManager.getInstance();
		_dataManager.load(_onLoad2);
		
	}
	
	private function _onLoad2():Void{
		
		Page.hideLoading();

		_scene = new Scene();
		_camera = new ExCamera(60, W / H, 10, 40000);
	
		_camera.near = 5;
		_camera.far = 10000;
		_camera.amp = 1000;
		//_camera.up.set(0.5, 0.5, 0);
		
		//_renderer
		_renderer = new WebGLRenderer({ /*preserveDrawingBuffer: true,*/ antialias:false, devicePixelRatio:1});
		_renderer.setClearColor(new Color(0x0000ff));
		_renderer.setSize(W, H);

		_camera.init(_renderer.domElement);	
        Browser.document.body.appendChild(_renderer.domElement);
		
		
		dLight = new DLight(0xffffff, 1.0, _scene);
		dLight.castShadow = true;
		_scene.add(dLight);
		
		var aLight:AmbientLight = new AmbientLight(0x999999);
		_scene.add(aLight);
		
		var p:StarParticle = new StarParticle();
		_scene.add(p);				
		
		
		//TimeCounter.start();
		_xmasPlayer = new XmasPlayer();
		_xmasPlayer.initObj();
		
		//clickされたら
		_audio = new MyAudio();
		_audio.init(_onInit);
		
	}
	
	//
	private function _onInit():Void{
		
		Tracer.error("oninit");
		
		Browser.window.onresize = _onResize;
		_onResize(null);
		
		
		#if debug
			Dat.gui.add(_camera, "amp", 0, 9000).listen();
			Dat.gui.add(_camera, "radX", 0, 2*Math.PI).step(0.01).listen();
			Dat.gui.add(_camera, "radY", 0, 2 * Math.PI).step(0.01).listen();
			
			Dat.gui.add(_camera, "tgtOffsetY", -1000, 1000).step(1).listen();
			Dat.gui.add(_camera, "fov", 10, 170).onChange(_camera.updateFOV);
		#end
		//Browser.document.addEventListener("keydown", _onKeyDown);
		
		//_scene.fog = new Fog(0, 3000, 10000);
		
		_camera.radY = Math.PI / 6;
		
		
		_start();
	}
	
	//private function _onKeyDown(e):Void {
	//	if(Std.parseInt(e.keyCode)==Dat.RIGHT) {		
	//		
	//	}
	//}
	
	private function _start():Void
	{
		//Browser.window.alert("init");
		
		_xmasPlayer.init(_camera, _renderer);
		_scene.add( _xmasPlayer );
		
		//return;
		_audio.play();
		_run();
	}
	
	//private var _aa:KamiParticle;
	
	private function _run():Void
	{
	
		if(_audio != null && _audio.isStart) {
			_audio.update();
		}
		
		if (_xmasPlayer != null){
			_xmasPlayer.update();
		}
		
		_camera.update();
		
		dLight.update(_camera.target);
		

		_renderer.render(_scene, _camera);
	
		//Timer.delay(_run, Math.floor(1000 / 30));
		Three.requestAnimationFrame( untyped _run);
		
	}	
	
	private function fullscreen() 
	{
		_renderer.domElement.requestFullscreen();
	}
	
	function _onResize(e) 
	{
		W = Browser.window.innerWidth;
		H = Browser.window.innerHeight;
		_renderer.domElement.width = W;// + "px";
		_renderer.domElement.height = H;// + "px";		
		_renderer.setSize(W, H);
		
		_camera.aspect = W / H;// , 10, 50000);
		_camera.updateProjectionMatrix();
	}
	
	
	
}