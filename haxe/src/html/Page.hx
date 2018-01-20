package html;
import js.JQuery;
import tween.TweenMax;

/**
 * ...
 * @author 
 */
class Page 
{
	static private var _isStart:Bool = false;
	static private var _startCallback:Void->Void;
	static private var _isHideLoading:Bool = false;

	public function new() 
	{
		
	}
	
	public static function init():Void{
		
		//new JQuery("#aboutBtn").mousedown( _openAbout );
		new JQuery("#aboutBtn").mousedown( showAbout );
	}
	
	
	private  static function showAbout(j):Void
	{
		new JQuery("#about").css({
			display:"flex"
		});
		new JQuery("#closeBtn").mousedown( hideAbout );
	}	
	
	private  static function hideAbout(j):Void
	{
		new JQuery("#about").hide();
	}	
	
	
	
	public static function showLoading(delay:Float):Void{
		_isHideLoading = false;
		TweenMax.delayedCall(delay, _onShowLoading);
	}
	
	private static function _onShowLoading():Void{
		if(!_isHideLoading){
			new JQuery("#loading").show();
			new JQuery("#loading").css({
				backgroundColor:"rgba(0,0,0,0)"
			});
		}
	}
	
	public static function hideLoading():Void{
		_isHideLoading = true;
		new JQuery("#loading").hide();
	}
	
	static public function showStart(onTouchStart:Void->Void):Void
	{
		_startCallback = onTouchStart;
		new JQuery("#btn").mousedown( cast _onShowStart );
	}
	
	static private function _onShowStart() 
	{
		if(_startCallback!=null){
			_startCallback();
			_startCallback = null;
		}
	}

	
	
	static public function hideStart():Void 
	{
		if (_isStart) return;
		
		_isStart = true;
		new JQuery("#btn").mousedown( null );
		new JQuery("#start").animate(
			{opacity:0},3000,_onHideStart
		);		
	}
	
	static private function _onHideStart() 
	{
		new JQuery("#start").hide();
	}

	

	
	
	
}