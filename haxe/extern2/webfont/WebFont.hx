package webfont;

	
/**
 * ...
 * @author watanabe
 */
@:native("WebFont")

extern class WebFont
{
/*
	WebFont.load({
            google: {
                families: [ 'Dorsa']
            },
            loading: function() {
                console.log("loading");
            },
            active: function () {
                window.init();
            },
            inactive: function() {
                console.log("inactive")
            }
    });
*/
	
	static function load(params:Dynamic):Void;


}