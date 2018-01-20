package sound;
import haxe.Http;
import js.html.audio.AnalyserNode;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.AudioContext;

/**
 * ...
 * @author nabe
 */
class MySound
{

	private var _context	:AudioContext;
	private var _req		:Http;
	private var _src		:AudioBufferSourceNode;
	private var _analyser	:AnalyserNode;
	
	public function new() 
	{
		
	}
	
	public function init():Void {
		/*
		if (untyped __js__("typeof(webkitAudioContext)") != "undefined") {
			_context = untyped __js__("new webkitAudioContext()");
		} else {
			_context = new js.html.audio.AudioContext();
		}
		
		_reg = new Http("sekaowa.mp3");
		//_req.open("GET", url, true);
		//_req.responseType = "arraybuffer";
		_req.onload = _onLoad;
		_req.send();
		
		_analyser = _context.createAnalyser();
		_analyser.fftSize = 1024;
		*/
		
		audio = new Audio();
      audio.controls = true;
      audio.src = "http://pixelia.me/__/misc/mix-1.ogg";
      document.body.appendChild( audio );
      
      audioctx = new AudioContext();      
      analyzer = audioctx.createAnalyser();
      analyzer.smoothingTimeConstant = 0.5;
      analyzer.fftSize = 512;
	  
      jsNode = audioctx.createScriptProcessor(2048, 1, 1);
      audio.addEventListener('canplay', function() {
        console.log("canplay");
        audio.play();
        sourceNode = audioctx.createMediaElementSource( audio );
        sourceNode.connect( analyzer );
        analyzer.connect( jsNode );
        jsNode.connect( audioctx.destination );
        sourceNode.connect( audioctx.destination );
        jsNode.onaudioprocess = function() {
          audioprocess = true;
          draw();
        };
	}
	
	public function 
	
	
	
	
	/*
	function _onLoad() 
	{
		if(_req.response) {
			//buffer = ctx.createBuffer(req.response, false);
			//_buffer = _context.decodeAudioData(_req.response,function(b){buffer=b;},function(){});
			_buffer = _context.decodeAudioData(_req.response,function(b){buffer=b;})
		}else {
			_buffer = _context.createBuffer(VBArray(req.responseBody).toArray(), false);
		}
		}
	}
	
	public function play():Void {
		
		if(_src === null) {
			_src = _context.createBufferSource();
			_src.buffer = buffer;
			_src.loop = true;
			_src.connect(audioctx.destination);
			_src.connect(analyser);
			_src.start(0);
		}
		
	}
	*/
	
	
	
}