package ;

import camera.CamAngle;
import camera.ExCamera;
import common.Dat;
import common.Mojis;
import common.TimeCounter;
import data.DataManager;
import js.Browser;
import objects.CatsBase;
import objects.CatsGenerators;
import objects.LongCat;
import objects.LongCats;
import objects.MidiCats;
import objects.MyDAELoader;
import objects.bg.BgSphere;
import particles.PaperParticle;
import particles.PaperParticles;
import sound.MyAudio;
import three.BoxGeometry;
import three.Color;
import three.DirectionalLight;
import three.Mesh;
import three.MeshBasicMaterial;
import three.PlaneGeometry;
import three.Scene;
import three.WebGLRenderer;
/**
 * ...
 * @author nabe
 */

class Test3d
{
	
	public static  var W:Int = 1280;// 1280;
	public static  var H:Int = 720;// 768;// 1920;
	
	
	private var _scene		:Scene;
	private var _camera		:ExCamera;
	private var _renderer	:WebGLRenderer;
	
	//private var _cubeCamera:CubeCamera;
	private var dae:MyDAELoader;
	private var _audio:MyAudio;
	private var _dataManager:DataManager;
	
	private var _angle:CamAngle;

	static private var clearColor:Color;
	private var _generators:CatsGenerators;
	private var _longCats:LongCats;
	private var _cats:MidiCats;
	
	//private var _camAngle:CamAngle
	
	private var _mode:Int = 2;
	private var _flyingCats:FlyingCats;

	private var _currentCats:CatsBase;
	private var _dimention:DimentionCats;
	
	private var _cube:Mesh;
	
	private var _bg:BgSphere;
	
	var _rendering:Int=0;
	var _paper:PaperParticles;
	
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
		_onLoad();	
	}
	
	private function _onLoad():Void {
	
		Dat.init(_onLoad2);
	}
	
	private function _onLoad2():Void{
		
		TimeCounter.start();
		
		clearColor = new Color(0xff55ff);
		
		_scene = new Scene();
		_camera = new ExCamera(60, W / H, 10, 10000);
		
		_angle = new CamAngle(_camera);
		
		_camera.near = 5;
		_camera.far = 10000;
		_camera.amp = 1000;
		
		//_renderer
		_renderer = new WebGLRenderer({ /*preserveDrawingBuffer: true,*/ antialias:true, devicePixelRatio:1});
		//_renderer.shadowMapEnabled = true;
		_renderer.setClearColor(new Color(0x000000));
		_renderer.setSize(W, H);
		//_renderer.domElement.width = W;// + "px";
		//_renderer.domElement.height = H;// + "px";
		
		_camera.init(_renderer.domElement);	
        Browser.document.body.appendChild(_renderer.domElement);
		
		Browser.window.onresize = _onResize;
		_onResize(null);
		
		//_camera.radY = Math.PI / 4;

		_bg = new BgSphere();
		//_scene.add( _bg );
		
		//_neko = new MyDAELoader();
		_dataManager = DataManager.getInstance();
		_dataManager.load(_onLoad1);
		
		Dat.gui.add(_camera, "amp", 0, 9000).listen();
		Dat.gui.add(_camera, "radX", 0, 2*Math.PI).step(0.01).listen();
		Dat.gui.add(_camera, "radY", 0, 2 * Math.PI).step(0.01).listen();
		Dat.gui.add(_camera, "tgtOffsetY", -1000, 1000).step(1).listen();	
		//Dat.gui.add(_bg, "visible");
		//Dat.gui.add(this, "_goNext");
		
		Browser.document.addEventListener("keydown", _onKeyDown);
		
		_cube = new Mesh(new BoxGeometry(100, 100, 100), new MeshBasicMaterial({color:0xff0000, wireframe:true}));
		_scene.add(_cube);
		
		_camera.radY = Math.PI / 6;
		
		
	}
	
	private function _onNote():Void{
	
		_rendering = 0;
		
	}
	
	private function _onKeyDown(e):Void {
		if(Std.parseInt(e.keyCode)==Dat.RIGHT) {		
			
		}
	}
	
	private function _onLoad1():Void
	{
		//Browser.window.alert("init");
		
		var light:DirectionalLight = new DirectionalLight(0xffffff, 1.0);
		light.position.z = 0.5;
		_scene.add(light);
		
		var p1:PaperParticle = new PaperParticle();
		//_scene.add(p1);
		
		var plane:Mesh = new Mesh(new PlaneGeometry(20000, 20000, 10, 10), new MeshBasicMaterial({color:0xff0000, wireframe:true}));
		plane.rotation.x = Math.PI / 2;
		_scene.add(plane);

		_paper = new PaperParticles();
		_paper.init();
		_scene.add(_paper);
		
		
		
		_run();
	}
	
	private function _run():Void
	{
		
		if (_paper!=null){
			_paper.update();
		}
		
		_camera.update();
		_angle.update(_audio);
	
		//if(_rendering++<3){
			_renderer.render(_scene, _camera);
		//}
			//_pp.render();
		
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
	
	
	public function setColor(col:Int):Void {
		clearColor = new Color(col);
		_renderer.setClearColor(clearColor);
	}
	
	
}