package common;
import js.html.Element;
import tween.easing.Power0;
import tween.TweenMax;
import tween.TweenMaxHaxe;

/**
 * ...
 * @author watanabe
 */
class FadeSheet
{

	public var opacity:Float = 1;
	public var element:Element;
	private var _twn:TweenMaxHaxe;
	
	public function new(ee:Element) 
	{
		element = ee;
	}
	
	
	/**
	 * fadeIn
	 */
	public function fadeIn():Void {
		
		if(element!=null){
			element.style.opacity = "0";
			opacity = 0;
			if (_twn != null)_twn.kill();
			
			_twn = TweenMax.to(this, 0.8, {
				opacity:1,
				delay:0.2,
				ease:Power0.easeInOut,
				onUpdate:_onUpdate
			});
		}
		
	}
	
	/**
	 * fadeOut
	 */
	public function fadeOut(callback:Void->Void):Void {
		if (_twn != null)_twn.kill();
		
		_twn = TweenMax.to(this, 0.5, {
			opacity:0,
			ease:Power0.easeInOut,
			onUpdate:_onUpdate,
			onComplete:callback
		});		
		
	}
	
	
	private function _onUpdate():Void
	{
		if(element!=null){
			element.style.opacity = "" + opacity;
		}
	}
	
}