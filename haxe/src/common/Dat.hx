package common;
//import jp.jingod.common.Callback;
import common.Callback;
import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.Element;
import sound.MyAudio;
import tween.TweenMax;

/**
 * ...
 * @author watanabe
 */
class Dat
{
	
	public static inline var UP:Int = 38;
	public static inline var DOWN:Int = 40;
	public static inline var LEFT:Int = 37;
	public static inline var RIGHT:Int = 39;
	public static inline var SPACE:Int = 32;
	
	public static inline var K1:Int = 49;
	public static inline var K2:Int = 50;
	public static inline var K3:Int = 51;
	public static inline var K4:Int = 52;
	public static inline var K5:Int = 53;
	public static inline var K6:Int = 54;
	public static inline var K7:Int = 55;
	public static inline var K8:Int = 56;
	public static inline var K9:Int = 57;
	public static inline var K0:Int = 58;
	
	public static inline var A:Int = 65;
	public static inline var B:Int = 66;
	public static inline var C:Int = 67;
	public static inline var D:Int = 68;
	public static inline var E:Int = 69;
	public static inline var F:Int = 70;
	public static inline var G:Int = 71;
	public static inline var H:Int = 72;
	public static inline var I:Int = 73;
	public static inline var J:Int = 74;
	public static inline var K:Int = 75;
	public static inline var L:Int = 76;
	public static inline var M:Int = 77;
	public static inline var N:Int = 78;	
	public static inline var O:Int = 79;
	public static inline var P:Int = 80;
	public static inline var Q:Int = 81;
	public static inline var R:Int = 82;
	public static inline var S:Int = 83;
	public static inline var T:Int = 84;
	public static inline var U:Int = 85;
	public static inline var V:Int = 86;
	public static inline var W:Int = 87;
	public static inline var X:Int = 88;
	public static inline var Y:Int = 89;
	public static inline var Z:Int = 90;
	

	
	public static inline var hoge:Int = 0;
	
	
	public static var gui:Dynamic;
	//public static var socket:WSocket;
	public static var bg:Bool = false;
	
	//public static var graph:Dynamic;
	private static var _showing:Bool = true;
	private static var _config:Config;
	private static var _cover:DivElement;
	private static var _soundFlag:Bool = true;
	static private var _callback:Void->Void;
	
	public function new() 
	{
		
	}
	
	public static function init(callback:Void->Void):Void {
		
		StageRef.fadeIn();
		
		_callback = callback;
		//_config = new Config();
		//_config.load( _onInit );
		_onInit();
		
	}
	
	private static function _onInit():Void {
		
		bg = (Browser.location.hash == "#bg");
		
		gui = untyped __js__("new dat.GUI({ autoPlace: false })");
		//gui.domElement.id = "ddgui";// "datgui"

		Browser.document.body.appendChild(gui.domElement);
		gui.domElement.style.position = "absolute";
		gui.domElement.style.right = "0px";
		
		var yy:Float = (Browser.window.innerHeight / 2 + StageRef.stageHeight / 2) + Config.canvasOffsetY;
			
		gui.domElement.style.top = "0px";//"0px";
		gui.domElement.style.opacity = 1;
		gui.domElement.style.zIndex = 1000;
		gui.domElement.style.transformOrigin = "1 0";		
		gui.domElement.style.transform = "scale(0.8,0.8)";
		
		//StatsGUI.init();
		//Browser.document.onkeydown = _onDown;
		//gui.add(main.camera, "amp").step(0.01).listen();
		
		Key.init();
		Key.board.addEventListener("keydown" , _onKeyDown);
		show(false);
		hide();
		
		if (_callback != null) {
			_callback();
		}
		//e.keyCode
	}
	
	static private function _onKeyDown(e):Void {
	
		//Browser.window.alert("bg=" + bg +" / "+ e.keyCode);
		
		switch(Std.parseInt(e.keyCode)) {
			case Dat.Z :
				_soundFlag = !_soundFlag;
				TweenMax.to(MyAudio.a, 0.5, {
					globalVolume: _soundFlag ? Config.globalVol : 0
				});
				
			case Dat.D :
				if ( gui.domElement.style.display == "block"){
					hide();
				}else{
					show(true);
				}
			//case Dat.F :
				//untyped Browser.document.body.webkitRequestFullscreen();
			case Dat.K1 :
				StageRef.fadeOut( _goURL1 );		
				
			case Dat.K2 :
				StageRef.fadeOut( _goURL2 );		
				
			case Dat.K3 :
				StageRef.fadeOut( _goURL3 );		
				
			case Dat.K4 :
				StageRef.fadeOut( _goURL4 );		
				
			case Dat.K5 :
				StageRef.fadeOut( _goURL5 );
				
			case Dat.K6 :
				StageRef.fadeOut( _goURL6 );
				
			case Dat.K7 :
				StageRef.fadeOut( _goURL7 );

			case Dat.K8 :
				StageRef.fadeOut( _goURL8 );

		}
	
		
	}

	/*
<a href="p04/bin/">04fish</a><br>
<a href="p05/bin/">05dot</a><br>
<a href="p08/bin/">08mona</a><br>
<a href="p02/bin/">02emoji</a><br>
<a href="p07/bin/">07earthtypo</a><br>
<a href="p03/bin/">03fbo</a><br>
<a href="p06/bin/">06matchmovj</a><br>
<a href="p09/bin/">09cat</a><br><br><br><br>*/
	
	//typofish
	private static function _goURL1():Void {
		_goURL( "../../p04/bin/" );
	}
	
	//faces
	private static function _goURL2():Void {
		_goURL( "../../p05/bin/" );
	}	
	
	//dottypo__
	private static function _goURL3():Void {
		_goURL( "../../p08/bin/" );
	}
	
	//monatypo
	private static function _goURL4():Void {
		_goURL( "../../p02/bin/" );
	}
	
	//emoji
	private static function _goURL5():Void {
		_goURL( "../../p07/bin/" );		
	}
	
	//matchmv
	private static function _goURL6():Void {
		
		_goURL( "../../p03/bin/" );
		
	}	

	//earth typo
	private static function _goURL7():Void {
		_goURL( "../../p06/bin/" );
	}	

	//single
	private static function _goURL8():Void {
		_goURL( "../../p09/bin/" );
	}	
	
	
	private static function _goURL(url:String):Void {
		
		Tracer.log("goURL " + url );
		Browser.window.location.href = url + Browser.location.hash;
		
	}
	
	

	public static function show(isBorder:Bool=false):Void {
		if(isBorder)StageRef.showBorder();
		gui.domElement.style.display = "block";
	}
	
	public static function hide():Void {
		StageRef.hideBorder();
		gui.domElement.style.display = "none";
	}
	
	
}