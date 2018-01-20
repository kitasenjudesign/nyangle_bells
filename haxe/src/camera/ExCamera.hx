package camera;

import haxe.Timer;
import js.Browser;
import js.html.Element;
import three.PerspectiveCamera;
import three.Quaternion;
import three.Vector3;
import utils.OsChecker;

/**
 * ...
 * @author nabe
 */
class ExCamera extends PerspectiveCamera
{

	//public static var DEFAULT_FOV:Int = 
	
	private var _down:Bool = false;
	private var _downX:Float = 0;
    private var _downY:Float = 0;
    private var _mouseX:Float = 0;
    private var _mouseY:Float = 0;
    private var _width:Float = 0;
    private var _height:Float = 0;
	
    private var _oRadX  :Float = 0;
    private var _oRadY  :Float = 0;

    public var amp    	:Float = 300.0;
	public var radX   	:Float = 0.001;
    public var radY   	:Float = 0.001;// Math.PI / 5;
	
	
	private var _camera:PerspectiveCamera;
    private var isActive:Bool=false;
	var _looking:Vector3;
	var _count:Float = 0;
	var _rAmp:Float = 0;
	var _countSpeed:Float=0;

	public var target	:Vector3;
	public var target2	:Vector3;
	
	private var _isMobile:Bool = false;
	
	public var tgtOffsetY		:Float = 300;
	
	
	public function new(fov:Float,aspect:Float,near:Float,far:Float) 
	{
		//
		super(fov, aspect, near, far);
	}
	
	public function init(dom:Element):Void{
        
		_camera = this;
		target = new Vector3();
		
		_isMobile = OsChecker.isMobile();
		
        //var container:any = document.querySelector('#container');
		if( !_isMobile ){
			dom.onmousedown 	= this.onMouseDown;
			dom.onmouseup 		= this.onMouseUp;
			dom.onmousemove 	= this.onMouseMove;
			dom.onwheel 	= this.onMouseWheel;
			Browser.window.addEventListener('DOMMouseScroll', this.onMouseWheelFF);
		}else{
			dom.ontouchstart	= this.onMouseDown;
			dom.ontouchend		= this.onMouseUp;
			dom.ontouchmove		= this.onMouseMove;
		}
		//Browser.window.onresize = _onResize;
		
    }
	
	private function _onResize():Void
	{
		
	}

	
	private function onMouseWheelFF(e):Void{
        this.amp += e.detail * 0.5;
        if (this.amp > 18000) {
			this.amp=18000;
		}
        if (this.amp < 100) {
			this.amp=100;
		}
    }

	private function onMouseWheel(e):Void {
        this.amp += e.wheelDelta * 0.5;
        if (this.amp > 18000) {
			this.amp=18000;
		}
        if (this.amp < 100){	
			this.amp = 100;
		}
    }

    private function onMouseUp(e):Void{
        e.preventDefault();
        this._down = false;
    }

    private function onMouseDown(e):Void{
        e.preventDefault();
        this._down = true;
		
		if(!_isMobile){
			this._downX = e.clientX;
			this._downY = e.clientY;
		}else{
			_mouseX = _downX = e.changedTouches[0].pageX;// : タッチされている画面位置の X 座標
			_mouseY = _downY = e.changedTouches[0].pageY;// : タッチされている画面位置の Y 座標			
		}
		
        this._oRadX = this.radX;
        this._oRadY = this.radY;
    }

    private function onMouseMove(e):Void{
        e.preventDefault();
        //console.log( "kiteru " + e.clientX +" " + e.clientY );
		
		if(!_isMobile){
			this._mouseX = e.clientX;
			this._mouseY = e.clientY;
		}else{
			_mouseX  = e.changedTouches[0].pageX;// : タッチされている画面位置の X 座標
			_mouseY  = e.changedTouches[0].pageY;// : タッチされている画面位置の Y 座標			
		}
		
    }

    public function update():Void{

		//if(!this.isActive)return;
        //Browser.window.console.log("kiteru " + this._mouseX+" "+this._mouseY);
        //radX 0~2pi
        //radY 0~2pi

        //downしてるとき
        if(this._down) {
            
			var dx:Float = -( this._mouseX - this._downX );
            var dy:Float = this._mouseY - this._downY;
            this.radX = this._oRadX + dx/100;
            this.radY = this._oRadY + dy / 100;
			if (this.radY > Math.PI / 2 * 0.999) this.radY = Math.PI / 2 * 0.999;
			if (this.radY < -Math.PI / 2 * 0.999) this.radY = -Math.PI / 2 * 0.999;
			
        }

        //console.log(this.radX + " " + this.radY + " " + x+" "+y+" "+z);
        if (_camera != null){
			//_updatePosition(1/4);
			_updatePosition(1);
        }

		//this.rotation.x = Math.PI / 4;
		
    }
	
	public function updateFOV():Void{
		_camera.updateProjectionMatrix();
	}
	
	public function setFOV(fov:Float) {
		
		Tracer.info("setFOV = " + fov);
		_camera.fov = fov;
		_camera.updateProjectionMatrix();
		
	}

	public function resize():Void {
		
		_width = Browser.window.innerWidth;
		_height = Browser.window.innerHeight;
		_camera.aspect = _width / _height;
		_camera.updateProjectionMatrix();
		
	}
	
	//
	public function reset(target:Vector3=null):Void{
        var p:Vector3 = _camera.position;
        this.amp = Math.sqrt( p.x*p.x + p.y*p.y + p.z*p.z );
        this.radX = Math.atan2(p.x, p.z);
        this.radY = Math.atan2(p.y, p.z);
		_updatePosition();
        
		if (this.radY > Math.PI / 2 * 0.96) this.radY =  Math.PI / 2 * 0.96;
		if (this.radY < -Math.PI / 2 * 0.96) this.radY = -Math.PI / 2 * 0.96;
		
		if(target!=null){
			_camera.lookAt( target );//target
        }
    }
	

	public function setPolar(a:Float, rx:Float, ry:Float, oY:Float):Void
	{
		this.amp = a;
        this.radX = rx;
        this.radY = ry;
		this.tgtOffsetY = oY;
		_updatePosition();
	}
	
	private var _flag:Bool = false;
	public function setRAmp(rAmp:Float,countSpeed:Float):Void {
		//if (_flag) return;
		_flag = true;
		_rAmp += rAmp;
		_countSpeed += countSpeed;
		
		//Timer.delay(_onAmp, 1000);
	}
	
	function _onAmp() 
	{
		_flag = false;
	}
	
	private function _updatePosition(spd:Float=1):Void
	{
		var amp1		:Float 	= this.amp * Math.cos(this.radY);
		
		_count+=_countSpeed;
		
		var ox:Float = _rAmp * Math.cos(_count / 30 * 2 * Math.PI) * 1;
		var oy:Float = _rAmp * Math.sin(_count / 30 * 2 * Math.PI) * 1;
		
		_rAmp *= 0.97;
		_countSpeed *= 0.95;
		
		var x		:Float 		= target.x + amp1 * Math.sin( this.radX )+ox;//横
		var y		:Float 		= target.y + this.amp * Math.sin(this.radY) + oy;
		var z		:Float 		= target.z + amp1 * Math.cos( this.radX );//横
		
		_camera.position.x += (x - _camera.position.x) * spd;
		_camera.position.y += (y - _camera.position.y) * spd;
		_camera.position.z += (z - _camera.position.z) * spd;
		
		var t:Vector3 = target.clone();
		t.y += tgtOffsetY;
		target2 = t;
        _camera.lookAt( t );//target
		
	
		
	}
	
	
	
	//spherecameraをひとつにする
	
	
	/*
        resize = (ww:number, hh:number)=>{
            this._width = ww;
            this._height = hh;
        }
	*/
	
	
	
	
	
	
}