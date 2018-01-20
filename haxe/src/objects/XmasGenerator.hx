package objects;
import common.Mojis;
import data.NoteonData;
import objects.cat.MidiCats;
import objects.snowman.Snowman;
import objects.tree.XmasTrees;
import three.Color;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author 
 */
class XmasGenerator extends Object3D
{

	private var _cats	:MidiCats;
	private var _count:Int = 0;
		
	public function new() 
	{
		super();
		
		_cats = new MidiCats();
		add(_cats);
		
	}
	
	public function reset(list:Array<NoteonData>):Void
	{
		_count = 0;
		_cats.removeCats( list );
	}
	
	/**
	 * addObject d pos
	 * @param	noteNo
	 */
	public function addObject(d:NoteonData,pos:Vector3):Void{

		Tracer.info( "_count" + _count );
		_count++;		
		_cats.playCat(d);
		
	}

	public function beat(d:NoteonData):Void{
		
		//_tree.beat();
		
	}
	
	
	public function update():Void{
		
		if (_cats != null){
			_cats.update();
		}
		
	}
	
	public function setPaperColor(col:Color) 
	{
		_cats.setPaperColor( col );
	}
	
	
}