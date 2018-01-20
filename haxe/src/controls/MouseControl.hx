package controls;
import js.JQuery;
import js.html.DOMElement;
import three.Euler;
import three.Object3D;
import three.PerspectiveCamera;
import three.Vector3;

/**
 * ...
 * @author 
 */
class MouseControl 
{

	private var _camera		:Object3D;
	private var _down		:Bool;
	private var _baseRot	:Euler;
	private var _mouseX		:Float = 0;
	private var _mouseY		:Float = 0;
	private var _downX		:Float = 0;
	private var _downY		:Float = 0;
	private var _lookTarget:MouseLookTarget;
	private var _enabled:Bool = false;
	private var _isMobile:Bool = false;
	private var _sensitivity:Float;
	
	public function new(camera:Object3D,dom:DOMElement) 
	{
		_camera = camera;
		_lookTarget = new MouseLookTarget();
		
		_isMobile = Main.isMobile;
		
		
		_sensitivity = _isMobile ? 0.005 : 0.003;
		
		
		var j:JQuery = new JQuery( "#" + dom.id );
		
		//どうにかする
		if ( !_isMobile ){
			
			dom.onmousedown 	= this.onMouseDown;
			dom.onmouseup 		= this.onMouseUp;
			dom.onmousemove 	= this.onMouseMove;
			
		}else{

			
			dom.ontouchstart	= this.onMouseDown;
			dom.ontouchend		= this.onMouseUp;
			dom.ontouchmove		= this.onMouseMove;
		
		}
		
		//_lookTarget.init(Math.PI, 0);
		
	}
	
	public function setActive(b:Bool):Void{
		_enabled = b;
		if (_enabled)_update();
	}
	
	
    private function onMouseUp(e):Void{
        e.preventDefault();
        _down = false;
    }
	
    private function onMouseDown(e):Void{
		
		Tracer.info("onMouseDown");
		
        e.preventDefault();
        _down = true;
        
		if ( _isMobile ){
			_mouseX = _downX = e.changedTouches[0].pageX;// : タッチされている画面位置の X 座標
			_mouseY = _downY = 0;// e.changedTouches[0].pageY;// : タッチされている画面位置の Y 座標
		}else{
			_mouseX = _downX = e.clientX;
			_mouseY = _downY = e.clientY;
		}
		
        _baseRot = _camera.rotation.clone();
		
		_lookTarget.setDown();
		
		update();
    }

	
    private function onMouseMove(e):Void{
        e.preventDefault();
        //console.log( "kiteru " + e.clientX +" " + e.clientY );
		
		if ( _isMobile ){
			_mouseX  = e.changedTouches[0].pageX;// : タッチされている画面位置の X 座標
			_mouseY  = 0;// e.changedTouches[0].pageY;// : タッチされている画面位置の Y 座標
		}else{
			_mouseX = e.clientX;
			_mouseY = e.clientY;
		}
    }	
	
	
	public function update():Void{
		
		if (!_enabled) return;
		
		if (_down){
			_update();
		}
		
	}
	
	//mouse sy曽木か
	public function setRad(rx:Float,ry:Float) 
	{
		_lookTarget.radX = _lookTarget.oRadX = rx;
		_lookTarget.radY = _lookTarget.oRadY = ry;
	}
	
	
	private function _update():Void{
		
		//var sensitivity:Float = 0.002;
		
		_lookTarget.center = _camera.position;
		_lookTarget.update(
			( _mouseX - _downX ),
			- ( _mouseY - _downY ),
			_sensitivity
		);
		
		//cameara
		_camera.lookAt(_lookTarget.pos);
		
	}
	
	
	
}