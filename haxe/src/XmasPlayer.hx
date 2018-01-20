package;
import camera.CamAngle;
import camera.CamData;
import camera.ExCamera;
import data.ColorData;
import data.DataManager;
import data.NoteonData;
import data.Params;
import objects.XmasGenerator;
import objects.bg.TimelineMesh;
import objects.bg.XmasLogo;
import particles.MojiParticles;
import sound.MyAudio;
import three.Color;
import three.Object3D;
import three.WebGLRenderer;

/**
 * ...
 * @author 
 */
class XmasPlayer extends Object3D
{

	private var _audio	:MyAudio;
	private var _gen	:XmasGenerator;
	private var _angle	:CamAngle;
	private var _cam	:ExCamera;
	private var _timeline:TimelineMesh;
	
	private var _xmas	:XmasLogo;
	private var _logo	:XmasLogo;
	private var _renderer	:WebGLRenderer;
	private var _mojis		:MojiParticles;
	
	public function new() 
	{
		super();
	}
	
	
	public function initObj():Void{
		
		_timeline = new TimelineMesh();
		_timeline.position.z = Params.distance / 2;
		_timeline.position.y = 100 / 2;
		add(_timeline);
		
		_xmas = new XmasLogo(DataManager.getInstance().xmas.geos[0]);
		_xmas.scale.set(1.4, 1.4, 1.4);
		_xmas.position.z = Params.distance - 150;
		_xmas.position.y = 330;
		add(_xmas);
		
		_logo = new XmasLogo(DataManager.getInstance().nyangle.geos[0]);
		_logo.scale.set(1.2, 1.2, 1.2);
		_logo.position.z = 0;
		_logo.position.y = 160;
		add(_logo);		
		
		_mojis = new MojiParticles();
		_mojis.init();
		add(_mojis);
	}
	
	public function init(cam:ExCamera,renderer:WebGLRenderer):Void{
	
		_renderer = renderer;
		
		_gen = new XmasGenerator();
		add(_gen);
	
		_cam = cam;
		_angle = new CamAngle(cam, _audio);
		
		_audio = MyAudio.a;
		_audio.addEventListener(MyAudio.EVENT_NOTEON, _noteon);
		_audio.addEventListener(MyAudio.EVENT_500MS, _onbpm);		
		_audio.addEventListener(MyAudio.EVENT_FINISH, _finish);
		

		_mojis.start();
		_mojis.position.z = Params.distance / 2;
		
		
		_start();
		
	}
	

	
	private function _start():Void{
		
		_gen.reset( _audio._midiA.noteList );
		_angle.start( 15 );// _audio.getDuration() );
		_changeAngle();
		_setColors();
		_mojis.reset();
	}
	
	
	private function _noteon(e:Dynamic):Void{
		
		var d:NoteonData = e.data;
		
		//Tracer.info( "AAAAA!!!!" );
		if( d.type == NoteonData.VOCAL ){
			_gen.addObject(d, _cam.target );
		}
		
		if ( d.type == NoteonData.BEAT ){
			_gen.beat(d);
			//_timeline.setColor();			
		}
		
		var list:Array<Float> = [
			51, 52, 53,
			54, 55, 56,
			
			49,50
		];
		for (i in 0...list.length){
			if ( list[i] == d.id ){
				/*
				_mojis.setColor(
					new Color(
						Math.random(),
						Math.random(),
						Math.random()
					)
				);*/
				_mojis.flash();
			}
		}
		
		
		
	}
	
	private function _onbpm(e):Void 
	{
		_xmas.setColor();
		_logo.setColor();
	}	
	
	
	private function _finish(e):Void{
		
		Tracer.info("finish");
		_start();
		
	}
	
	
	private function _changeAngle():Void{
		
		var d:CamData = CamData.getAngle();
		_angle.setCam( d ) ;
		
		if ( d.gyaku ){
			_xmas.rotation.y = Math.PI;
			_logo.rotation.y = Math.PI;
			_mojis.rotation.y = Math.PI;
		}else{
			_xmas.rotation.y = 0;
			_logo.rotation.y = 0;		
			_mojis.rotation.y = 0;
		}
		
		
	}
	
	private function _setColors():Void{
		
		var d:ColorData = ColorData.getNext();
		
		//bg
		_renderer.setClearColor( d.bg );
		
		//box
		DataManager.getInstance().box.mat.color.copy( d.box );// , 1, 0);
		
		//line
		_timeline.setColor( d.line );
		
		//paper
		_gen.setPaperColor( d.paper );
		
		//moji
		_mojis.setColor( d.moji );
		
	}
	
	/*
	
	public var bg		:Color;
	public var box		:Color;
	public var line		:Color;
	public var paper	:Color;
	public var moji		:Color;
	
	*/
	
	
	
	
	public function update():Void{
		
		if (_gen != null){
			_gen.update();
		}
		if (_angle != null){
			_angle.update();
		}
		
		if (_mojis != null ){
			_mojis.update();
		}
		
		if (_timeline != null){
			_timeline.update( _audio.getTimeRatio() );
		}
				
		
	}
	
	
	
	
}