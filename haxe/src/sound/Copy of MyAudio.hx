package sound;
import js.Browser;
import js.html.audio.AnalyserNode;
import js.html.audio.AudioContext;
import js.html.audio.MediaElementAudioSourceNode;
import js.html.AudioElement;
import js.html.Uint8Array;

/**
 * ...
 * @author nabe
 */
class MyAudio
{

	private var analyser:AnalyserNode;
	var _isStart:Bool=false;
	public var audio:AudioElement;
	public var freqByteData:Uint8Array;
	public var isStart:Bool = false;
	
	public function new() 
	{
		
	}

	public function init():Void {
		
		// Get our <audio> element
		isStart = true;
		audio = Browser.document.createAudioElement();//Browser.document.getElementById('music');
		audio.src = "bridge1.mp3";// "akunohana.mp3";// Math.random() < 0.5 ? "akira.mp3" : "akunohana.mp3";
		audio.autoplay = true;
		Browser.document.body.appendChild(audio);
		
		// Create a new audio context (that allows us to do all the Web Audio stuff)
		var audioContext:AudioContext;// = new AudioContext();
		if (untyped __js__("typeof(webkitAudioContext)") != "undefined") {
			//audioContext = untyped __js__("new webkitAudioContext()");
			audioContext = untyped __js__("new AudioContext()");
			
		} else {
			audioContext = new js.html.audio.AudioContext();
		}
		
		// Create a new analyser
		analyser = audioContext.createAnalyser();
		analyser.fftSize = 64;

		// Create a new audio source from the <audio> element
		var source:MediaElementAudioSourceNode = audioContext.createMediaElementSource(audio);
		// Connect up the output from the audio source to the input of the analyser
		source.connect(untyped analyser);
		// Connect up the audio output of the analyser to the audioContext destination i.e. the speakers (The analyser takes the output of the <audio> element and swallows it. If we want to hear the sound of the <audio> element then we need to re-route the analyser's output to the speakers)
		analyser.connect(untyped audioContext.destination);

	
		audio.play();
		Browser.window.ontouchstart = untyped _onstart;
		
	}
	
	//http://jsdo.it/kimmy/iBGe
	
	function _onstart() 
	{
		if(_isStart)audio.play();
		_isStart = true;
	}

	// Draw the audio frequencies to screen
	public function update():Void {
		// Setup the next frame of the drawing
		//webkitRequestAnimationFrame(draw);
  
		// Create a new array that we can copy the frequency data into
		freqByteData = new Uint8Array(analyser.frequencyBinCount);
		// Copy the frequency data into our new array
		analyser.getByteFrequencyData(freqByteData);

		// Clear the drawing display
		//canvasContext.clearRect(0, 0, canvas.width, canvas.height);

		// For each "bucket" in the frequency data, draw a line corresponding to its magnitude

		/*
		trace( freqByteData[5] );
		for (i in 0... freqByteData.length) {
			//canvasContext.fillRect(i, canvas.height - freqByteData[i], 1, canvas.height);
			//freqByteData[i]
		}
		*/
	}

	
		
	
	
}