package camera;

import js.Browser;
import js.html.DOMElement;
import js.html.Element;
import three.PerspectiveCamera;
import three.Quaternion;
import three.Vector3;

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
	private var _isMobile:Bool = false;
    private var _oRadX  :Float = 0;
    private var _oRadY  :Float = 0;

    public var amp    	:Float = 5900.1;
	public var radX   	:Float = 0.001;
    public var radY   	:Float = 0.001;
	
	
	private var _camera:PerspectiveCamera;
    private var isActive:Bool=false;
	var _looking:Vector3;

	public var target	:Vector3;
	public var target2	:Vector3;
	
	
	public var tgtOffsetY		:Float = 0;
	//public var bure:Bure;
	
	
	public function new(fov:Float,aspect:Float,near:Float,far:Float) 
	{
		//
		super(fov, aspect, near, far);
	}
	
	public function init():Void{
        var dom:DOMElement = Browser.window.document.body;
		_camera = this;
		target = new Vector3();
        //var container:any = document.querySelector('#container');
		dom.onmousedown 	= this.onMouseDown;
        dom.onmouseup 		= this.onMouseUp;
        dom.onmousemove 	= this.onMouseMove;
		dom.onwheel 		= this.onMouseWheel;
		
		_isMobile = Os
		
        //dom.onmousewheel 	= this.onMouseWheel;
        Browser.window.addEventListener('DOMMouseScroll',this.onMouseWheelFF);
    }
	
	private function _onResize():Void
	{
		Tracer.log("_onResize");//
		
	}

	
	private function onMouseWheelFF(e):Void{
        this.amp += e.detail * 1;
        if (this.amp > 118000) {
			this.amp=118000;
		}
        if (this.amp < 20) {
			this.amp= 20;
		}
    }

	private function onMouseWheel(e):Void {
        this.amp += e.wheelDelta * 1;
		trace(this.amp);
        if (this.amp > 118000) {
			this.amp=118000;
		}
        if (this.amp < 20){	
			this.amp = 20;
		}
    }

    private function onMouseUp(e):Void{
            e.preventDefault();
            this._down = false;
    }

    private function onMouseDown(e):Void{
        e.preventDefault();
        this._down = true;
		
		if(_isMobile){
			this._downX = e.clientX;
			this._downY = e.clientY;
			this._oRadX = this.radX;
			this._oRadY = this.radY;
		}
    }

    private function onMouseMove(e):Void{
        e.preventDefault();
        //console.log( "kiteru " + e.clientX +" " + e.clientY );
		if(_isMobile){
			this._mouseX = e.clientX;
			this._mouseY = e.clientY;
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
			if (this.radY > Math.PI / 2) this.radY = Math.PI / 2;
			if (this.radY < -Math.PI / 2) this.radY = -Math.PI / 2;
        }

		/*
		position.x = amp * 
		position.y = amp * 
		position.z = amp * 
		*/
		
        //console.log(this.radX + " " + this.radY + " " + x+" "+y+" "+z);
        if (_camera != null){
			_updatePosition();// 1 / 4);
        }

		//this.rotation.x = Math.PI / 4;
		
    }
	
	
	public function setFOV(fov:Float) {
		
		trace("setFOV = " + fov);
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
	

	public function setPolar(a:Float, rx:Float, ry:Float):Void
	{
		this.amp = a;
        this.radX = rx;
        this.radY = ry;
		_updatePosition();
	}
	
	private function _updatePosition(spd:Float=1):Void
	{
		
		//this.amp = 100000;
		
		var amp1		:Float = this.amp * Math.cos(this.radY);
		
		var x		:Float = target.x + amp1 * Math.sin( this.radX );//横
		var y		:Float = target.y + this.amp * Math.sin(this.radY);
		var z		:Float = target.z + amp1 * Math.cos( this.radX );//横
		
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