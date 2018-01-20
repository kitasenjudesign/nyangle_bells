package common;
import js.Browser;
import js.html.Element;
import tween.TweenMax;

/**
 * ...
 * @author watanabe
 */
class StageRef
{

	public static inline var name:String = "webgl";
	public static var sheet:FadeSheet;
	public static var stageWidth(get, null)		:Int;
	public static var stageHeight(get, null)	:Int;
	
	
	public function new() 
	{
		//
	}
	

	public static function showBorder():Void {
		var dom:Element = Browser.document.getElementById(name);
		if(dom!=null)dom.style.border = "solid 1px #cccccc";
	}
	public static function hideBorder():Void {
		var dom:Element = Browser.document.getElementById(name);
		if(dom!=null)dom.style.border = "solid 0px";
	}
	
	public static function fadeIn():Void {
		if(sheet == null){	
			sheet = new FadeSheet(Browser.document.getElementById(name));
		}
		sheet.fadeIn();		
	}
	
	public static function fadeOut(callback:Void->Void):Void {
		if(sheet == null){	
			sheet = new FadeSheet(Browser.document.getElementById(name));
		}
		sheet.fadeOut(callback);		
	}
	
	
	public static function setCenter(offsetY:Float=0):Void {
		
		var dom:Element = Browser.document.getElementById(name);
			
			var yy:Float = (Browser.window.innerHeight / 2 - StageRef.stageHeight / 2) + Config.canvasOffsetY + offsetY;
			dom.style.position = "absolute";
			dom.style.zIndex = "1000";
			dom.style.top = Math.round(yy) + "px";
		
	}
	
	static public function get_stageWidth():Int
	{
		return Browser.window.innerWidth;
	}
	static public function get_stageHeight():Int
	{
		/*
		if ( Dat.bg ) {
			return Math.floor( Browser.window.innerWidth * 816 / 1920 );
		}*/
		
		return Browser.window.innerHeight;
	}		
	
	
}