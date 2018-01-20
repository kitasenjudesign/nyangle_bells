package objects.cat;
import data.NoteonData;
import data.Params;
import objects.cat.GiftBoxCat;
import three.Color;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author 
 */
class MidiCats extends Object3D
{

	private var _cats:Array<GiftBoxCat>;
	private var _map:Map<String,Float>;
	private var _count:Int = 0;
	
	public function new() 
	{
		super();
		_map = new Map<String,Float>();
		_cats = [];
	}
	
	private function initCat():Void{
		
		
		
	}
	
	
	public function addCat(d:NoteonData,pos:Vector3):Void{
		/*
		var cat:GiftBoxCat = new GiftBoxCat();
		cat.init();
		cat.position.x = pos.x + 600 * (Math.random()-0.5);
		cat.position.y = pos.y;
		cat.position.z = pos.z;
		add(cat);
		
		_cats.push(cat);
		*/
	}
	
	/**
	 * 
	 * @param	data
	 */
	public function playCat(data:NoteonData):Void{
		
		Tracer.info("playCat " + data.id);
		for (i in 0..._cats.length){
			
			if ( data.id == _cats[i].data.id ){
				
				_cats[i].show();
				
			}
			
		}
	}
	
	/**
	 * 
	 * @param	list
	 */
	public function removeCats(list:Array<NoteonData>):Void{
		
		trace("remove");
		if (_cats.length > 0){
			
			//2回目
			for (i in 0..._cats.length){
				_cats[i].reset();
			}
			
			return;
		}
		
		//新しく作る
		for (i in 0...list.length){
			
			var data:NoteonData = list[i];
			var timeRatio:Float = data.time / Params.duration;
			
			var cat:GiftBoxCat = new GiftBoxCat();
			cat.init(data);
			
			cat.position.x = ( getX(data) - 2.5 ) * 300 ;// 1000 * (Math.random() - 0.5);
			cat.position.y = 0;// 300 * (Math.random() - 0.5);
			cat.position.z = timeRatio * Params.distance;
			add(cat);
			_cats.push(cat);
			
		}
		
	}
	

	
	
	public function getX(data:NoteonData):Float{
		
		if ( _map.get(data.name)!=null ){
			return  _map.get(data.name);
		}
		
		_count++;
		_map.set(data.name, _count);
		
		return _count;
	}
	
	
	
	public function update():Void{
		
		for (i in 0..._cats.length){
			_cats[i].update();	
		}
				
	}
	
	
	
	public function setPaperColor(col:Color):Void{
		
		for (i in 0..._cats.length){
			_cats[i].getPaper().setColor( col );
		}
		
	}
	
	
}