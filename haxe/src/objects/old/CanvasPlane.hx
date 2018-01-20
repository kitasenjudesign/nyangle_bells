package objects;
import common.StringUtils;
import common.TimeCounter;
import common.WebfontLoader;
import createjs.easeljs.DisplayObject;
import createjs.easeljs.Graphics;
import createjs.easeljs.Shape;
import createjs.easeljs.Stage;
import createjs.easeljs.Text;
import js.Browser;
import js.html.CanvasElement;
import objects.SpacingText;
import three.Color;
import three.Geometry;
import three.Line;
import three.LineBasicMaterial;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.PlaneBufferGeometry;
import three.PlaneGeometry;
import three.Texture;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class CanvasPlane extends Object3D
{
	private var _stage	:Stage;
	private var _plane	:Mesh;
	private var _material:MeshBasicMaterial;
	
	private var _textCh:SpacingText;
	private var _textNo:SpacingText;
	private var _textTime:SpacingText;
	private var _line:Line;
	
	
	private static var _index:Int = 0;
	
	public function new() 
	{
		super();
	}
	
	
	
	public function init(ww:Float):Void {
	
		
		var canvas:CanvasElement = Browser.document.createCanvasElement();
		_stage = _createStage(canvas, 256, 256);
		_material = _getMaterial(canvas);
		
		//_plane = new Mesh( new PlaneGeometry(256,64,1,1),new MeshBasicMaterial({color:0xff0000}));
		//add(_plane);
		
		_plane = new Mesh( new PlaneGeometry(ww, ww, 1, 1), _material);
		_plane.position.x += ww/2;
		add(_plane);
		
		/*
		var shape:Shape = new Shape();
		shape.graphics.beginFill("#ff0000");
		shape.graphics.drawRect(0, 0, ww, 20);
		_stage.addChild( shape);*/
		
		_textCh = new SpacingText("CH", SpacingText.getFont(42, "700", WebfontLoader.ROBOTO_CONDENSED), 0.5, "#ffffff");
		_textCh.y = 37;
		_stage.addChild( _textCh );
		
		_textNo = new SpacingText("0001", SpacingText.getFont(80,"700", WebfontLoader.ROBOTO_CONDENSED), 0.5, "#ffffff");
		_stage.addChild( _textNo );
		_textNo.x = 60;
		_textNo.y = 4;
		
		_textTime = new SpacingText("10:20:23", SpacingText.getFont(60, "700", WebfontLoader.ROBOTO_CONDENSED), 1, "#ffffff");
		_textTime.y = 85;
		_stage.addChild( _textTime );
		
		_stage.update();
		_material.map.needsUpdate = true;
		
		var g:Geometry = new Geometry();
		g.vertices.push(new Vector3(0, -50, 0));
		g.vertices.push(new Vector3(0, 50, 0));
		
		/*
		var lineA:Line = new Line(g, new LineBasicMaterial( { color:0xffffff } ));
		lineA.position.x = 550;
		lineA.position.y = 40;
		add(lineA);
		*/
		updateText();
	}
	
	public function updateText():Void {
	
		_textNo.update(StringUtils.addZero(_index, 4));
		
		_textTime.update( TimeCounter.getTime() ); 
		
		_stage.update();
		
		_material.map.needsUpdate = true;
		_index++;
		
	}
	
	public function setColor(col:Int):Void
	{
		_material.color = new Color(col);
		//_material.needsUpdate = true;
	}
	
	
	/**
	 * 
	 * @param	canvas
	 * @param	isAlphaTest
	 * @return
	 */
	private function _getMaterial(canvas:CanvasElement,isAlphaTest:Bool=false):MeshBasicMaterial {
		
		var texture:Texture = new Texture(canvas);
		//texture.format = Three.RGBAFormat;
		
		//canvas.getContext2d().smoo
		/*
		if(isAlphaTest){
			texture.minFilter = Three.NearestFilter;//Three.LinearFilter;
			texture.magFilter = Three.NearestFilter;//Three.LinearFilter;
		}else {
			texture.minFilter = Three.LinearFilter;
			texture.magFilter = Three.LinearFilter;
			//texture.minFilter = Three.NearestFilter;//Three.LinearFilter;
			//texture.magFilter = Three.NearestFilter;//Three.LinearFilter;			
		}*/

		texture.needsUpdate = true;
		
		//生成したvideo textureをmapに指定し、overdrawをtureにしてマテリアルを生成
		var mate:MeshBasicMaterial = new MeshBasicMaterial(
			{map: texture, side:Three.FrontSide, transparent:true }
		);
		if(isAlphaTest){
			mate.alphaTest = 0.5;
		}else {
			mate.shading = Three.SmoothShading;
		}
		
		return mate;
		
	}
	
	/**
	 * font style shutoku
	 * @param	size
	 * @param	text
	 * @return
	 */
	private function _getFont(size:Float, bold:String="400", text:String = "Roboto Condensed" ):String {
		return bold +" "+size+"px " + text;
	}
	
	/**
	 * 
	 * @param	stage
	 * @param	obj
	 * @param	xx
	 * @param	yy
	 */
	private function _addDisplayObject(stage:Stage, obj:DisplayObject, xx:Float, yy:Float):Void {
		stage.addChild(obj);
		obj.x = xx;
		obj.y = yy;
	}
	
	/**
	 * 
	 * @param	canvas
	 * @param	ww
	 * @param	hh
	 * @return
	 */
	private function _createStage(canvas:CanvasElement,ww:Int,hh:Int):Stage {
		//var canvas:CanvasElement = Browser.document.createCanvasElement();
		canvas.width = ww;
		canvas.height = hh;
		canvas.getContext2d().imageSmoothingEnabled = true;
		return new Stage(cast canvas);
	}
	
	
	/**
	 * 
	 * @param	s
	 * @param	ww
	 * @param	hh
	 * @return
	 */
	private function _getStrMaterial(s:String,ww:Int=512,hh:Int=256):MeshBasicMaterial {
		
		var canvas:CanvasElement = Browser.document.createCanvasElement();
		var stage:Stage = _createStage(canvas,ww,hh);
		
		var text1:Text = new Text( s, _getFont(60) );
		text1.color 	= Graphics.getRGB(0xcc, 0xcc, 0xcc);
		text1.x = 20;
		text1.y = 20;
		stage.addChild(text1);
		stage.update();
		return _getMaterial(canvas);
		
	}
	
	
	
	
	
}