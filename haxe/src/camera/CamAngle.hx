package camera;

import common.Dat;
import data.Params;
import js.Browser;
import sound.MyAudio;
import tween.TweenMax;
import tween.TweenMaxHaxe;
import tween.easing.Power0;

/**
 * ...
 * @author nabe
 */
class CamAngle
{


	private var _camera:ExCamera;
	private var _count:Int = 0;
	
	private	var _tgtAmp		:Float = 0;// d.amp;
	private	var _tgtRadX	:Float = 0;// d.radX;
	private	var _tgtRadY 	:Float = 0;// d.radY;	
		
	private	var _addAmp		:Float = 0;// d.amp;
	private	var _addRadX	:Float = 0;// d.radX;
	private	var _addRadY 	:Float = 0;// d.radY;	
	
	private var _tweenMax:TweenMaxHaxe;
	
	
	
	public function new(cam:ExCamera,audio:MyAudio) 
	{
		_camera = cam;
		
		Browser.document.addEventListener("keydown", _onKeyDown);
	}
	
	private function _onKeyDown(e):Void 
	{
		switch( Std.parseInt(e.keyCode)) {
			case Dat.RIGHT:
				//setCam( CamData.cams[_count % CamData.cams.length] );
			
		}
	}
	
	
	//reset
	public function start(time:Float):Void{
		
		/*
		if (_tweenMax != null){
			_tweenMax.kill();
		}
		
		_camera.target.z = 0;
		_tweenMax = TweenMax.to(_camera.target, time, {
			z: Params.distance,
			ease: Power0.easeInOut
		});
		*/
	}
	
	
	
	
	/**
	 * update
	 * @param	a
	 */
	public function update():Void {
		
		//Tracer.info("update!! " );
		_camera.target.y = 100 / 2;
		_camera.target.z = MyAudio.a.getTimeRatio() * Params.distance;
		
	}
	
	/**
	 * setCam
	 * @param	cam
	 */
	public function setCam(d:CamData):Void {
	
		//Browser.window.alert("setCam");
		_camera.amp 	=  d.amp;
		_camera.radX 	=  d.radX;
		_camera.radY 	=  d.radY;
		
		_tgtAmp 	= d.amp;
		_tgtRadX 	= d.radX;
		_tgtRadY 	= d.radY;
		
		_camera.setFOV( d.fov );
		_camera.setPolar(d.amp, d.radX, d.radY, d.offsetY);
	}
	
	
	
}