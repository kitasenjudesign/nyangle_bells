(function (console, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,__class__: EReg
};
var FontShapeMaker = function() {
};
FontShapeMaker.__name__ = true;
FontShapeMaker.main = function() {
	new FontShapeMaker();
};
FontShapeMaker.prototype = {
	add: function(m) {
		console.log("このメソッドはdebugじゃないと動作しないよ");
	}
	,remove: function(m) {
		console.log("このメソッドはdebugじゃないと動作しないよ");
	}
	,init: function(json,callback) {
		FontShapeMaker.font = new net_badimon_five3D_typography_GenTypography3D();
		if(callback == null) FontShapeMaker.font.initByString(json); else FontShapeMaker.font.init(json,callback);
	}
	,getWidth: function(moji) {
		return FontShapeMaker.font.getWidth(moji);
	}
	,getHeight: function() {
		return FontShapeMaker.font.getHeight();
	}
	,getGeometry: function(moji,isCentering) {
		if(isCentering == null) isCentering = true;
		var shapes = this.getShapes(moji,isCentering);
		var geo = new THREE.ShapeGeometry(shapes,{ });
		return geo;
	}
	,getShapes: function(moji,isCentering) {
		if(isCentering == null) isCentering = false;
		var scale = 1;
		var shapes = [];
		var shape = null;
		var g = null;
		var motif = FontShapeMaker.font.motifs.get(moji);
		var ox = 0;
		var oy = 0;
		var s = scale;
		if(isCentering) {
			ox = -FontShapeMaker.font.widths.get(moji) / 2;
			oy = -FontShapeMaker.font.height / 2;
		}
		var len = motif.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			var tgt = motif[i][0];
			if(tgt == "M" || tgt == "H") {
				if(tgt == "H") {
					g = new THREE.Path();
					shape.holes.push(g);
				} else {
					shape = new THREE.Shape();
					shapes.push(shape);
					g = shape;
				}
				g.moveTo(s * (motif[i][1][0] + ox),-s * (motif[i][1][1] + oy));
			} else if(tgt == "L") g.lineTo(s * (motif[i][1][0] + ox),-s * (motif[i][1][1] + oy)); else if(tgt == "C") g.quadraticCurveTo(s * (motif[i][1][0] + ox),-s * (motif[i][1][1] + oy),s * (motif[i][1][2] + ox),-s * (motif[i][1][3] + oy));
		}
		return shapes;
	}
	,__class__: FontShapeMaker
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
var Lambda = function() { };
Lambda.__name__ = true;
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
var List = function() {
	this.length = 0;
};
List.__name__ = true;
List.prototype = {
	iterator: function() {
		return new _$List_ListIterator(this.h);
	}
	,__class__: List
};
var _$List_ListIterator = function(head) {
	this.head = head;
	this.val = null;
};
_$List_ListIterator.__name__ = true;
_$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		this.val = this.head[0];
		this.head = this.head[1];
		return this.val;
	}
	,__class__: _$List_ListIterator
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	window.onload = Main._init;
};
Main._init = function() {
	Main._main = new Main3d();
	Main._main.init();
};
var Main3d = function() {
};
Main3d.__name__ = true;
Main3d.prototype = {
	init: function() {
		this._onLoad();
	}
	,_onLoad: function() {
		common_Dat.init($bind(this,this._onLoad1));
	}
	,_onLoad1: function() {
		this._dataManager = data_DataManager.getInstance();
		this._dataManager.load($bind(this,this._onLoad2));
	}
	,_onLoad2: function() {
		common_TimeCounter.start();
		this._audio = new sound_MyAudio();
		this._audio.init($bind(this,this._onInit));
	}
	,_onInit: function() {
		Tracer.error("oninit");
		this._scene = new THREE.Scene();
		this._camera = new camera_ExCamera(60,Main3d.W / Main3d.H,10,10000);
		this._camera.near = 5;
		this._camera.far = 10000;
		this._camera.amp = 1000;
		this._renderer = new THREE.WebGLRenderer({ antialias : true, devicePixelRatio : 1});
		this._renderer.shadowMap.enabled = true;
		this._renderer.setClearColor(new THREE.Color(0));
		this._renderer.setSize(Main3d.W,Main3d.H);
		this._camera.init(this._renderer.domElement);
		window.document.body.appendChild(this._renderer.domElement);
		window.onresize = $bind(this,this._onResize);
		this._onResize(null);
		common_Dat.gui.add(this._camera,"amp",0,9000).listen();
		common_Dat.gui.add(this._camera,"radX",0,2 * Math.PI).step(0.01).listen();
		common_Dat.gui.add(this._camera,"radY",0,2 * Math.PI).step(0.01).listen();
		common_Dat.gui.add(this._camera,"tgtOffsetY",-1000,1000).step(1).listen();
		window.document.addEventListener("keydown",$bind(this,this._onKeyDown));
		this._scene.fog = new THREE.Fog(0,3000,10000);
		this._camera.radY = Math.PI / 6;
		this._start();
	}
	,_onKeyDown: function(e) {
		if(Std.parseInt(e.keyCode) == 39) {
		}
	}
	,_start: function() {
		this._xmasPlayer = new XmasPlayer();
		this._xmasPlayer.init(this._camera);
		this._scene.add(this._xmasPlayer);
		this.dLight = new light_DLight(16777215,1.0,this._scene);
		this.dLight.castShadow = true;
		this._scene.add(this.dLight);
		var aLight = new THREE.AmbientLight(5592405);
		this._scene.add(aLight);
		var helper = new THREE.CameraHelper(this.dLight.shadow.camera);
		this._papers = new particles_PaperParticles();
		this._papers.init();
		this._papers.position.z = data_Params.distance / 2;
		this._scene.add(this._papers);
		var p = new particles_PaperParticle();
		this._scene.add(p);
		var ground = new objects_bg_Ground();
		this._audio.play();
		this._run();
	}
	,_run: function() {
		if(this._audio != null && this._audio.isStart) this._audio.update();
		if(this._papers != null) this._papers.update();
		if(this._xmasPlayer != null) this._xmasPlayer.update();
		this._camera.update();
		this.dLight.update(this._camera.target);
		this._renderer.render(this._scene,this._camera);
		window.requestAnimationFrame($bind(this,this._run));
	}
	,fullscreen: function() {
		this._renderer.domElement.requestFullscreen();
	}
	,_onResize: function(e) {
		Main3d.W = window.innerWidth;
		Main3d.H = window.innerHeight;
		this._renderer.domElement.width = Main3d.W;
		this._renderer.domElement.height = Main3d.H;
		this._renderer.setSize(Main3d.W,Main3d.H);
		this._camera.aspect = Main3d.W / Main3d.H;
		this._camera.updateProjectionMatrix();
	}
	,__class__: Main3d
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) return null; else if(o.__properties__ && (tmp = o.__properties__["get_" + field])) return o[tmp](); else return o[field];
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var Three = function() { };
Three.__name__ = true;
Three.requestAnimationFrame = function(f) {
	return window.requestAnimationFrame(f);
};
Three.cancelAnimationFrame = function(f) {
	window.cancelAnimationFrame(id);
};
var Tracer = function() {
};
Tracer.__name__ = true;
Tracer.assert = function(condition,p1,p2,p3,p4,p5) {
};
Tracer.clear = function(p1,p2,p3,p4,p5) {
};
Tracer.count = function(p1,p2,p3,p4,p5) {
};
Tracer.dir = function(p1,p2,p3,p4,p5) {
};
Tracer.dirxml = function(p1,p2,p3,p4,p5) {
};
Tracer.error = function(p1,p2,p3,p4,p5) {
};
Tracer.group = function(p1,p2,p3,p4,p5) {
};
Tracer.groupCollapsed = function(p1,p2,p3,p4,p5) {
};
Tracer.groupEnd = function() {
};
Tracer.info = function(p1,p2,p3,p4,p5) {
};
Tracer.log = function(p1,p2,p3,p4,p5) {
};
Tracer.markTimeline = function(p1,p2,p3,p4,p5) {
};
Tracer.profile = function(title) {
};
Tracer.profileEnd = function(title) {
};
Tracer.time = function(title) {
};
Tracer.timeEnd = function(title,p1,p2,p3,p4,p5) {
};
Tracer.timeStamp = function(p1,p2,p3,p4,p5) {
};
Tracer.trace = function(p1,p2,p3,p4,p5) {
};
Tracer.warn = function(p1,p2,p3,p4,p5) {
};
Tracer.prototype = {
	__class__: Tracer
};
var XmasPlayer = function() {
	THREE.Object3D.call(this);
};
XmasPlayer.__name__ = true;
XmasPlayer.__super__ = THREE.Object3D;
XmasPlayer.prototype = $extend(THREE.Object3D.prototype,{
	init: function(cam) {
		this._gen = new objects_XmasGenerator();
		this.add(this._gen);
		this._cam = cam;
		this._angle = new camera_CamAngle(cam,this._audio);
		this._audio = sound_MyAudio.a;
		this._audio.addEventListener("noteon",$bind(this,this._noteon));
		this._audio.addEventListener("finish",$bind(this,this._finish));
		this._start();
	}
	,_start: function() {
		this._gen.reset(this._audio._midiA.noteList);
		this._angle.start(15);
	}
	,_noteon: function(e) {
		var d = e.data;
		if(d.type == "VOCAL") this._gen.addObject(d,this._cam.target);
		if(d.type == "BEAT") this._gen.beat(d);
	}
	,_finish: function(e) {
		Tracer.info("finish");
		this._start();
	}
	,update: function() {
		if(this._gen != null) this._gen.update();
	}
	,__class__: XmasPlayer
});
var camera_CamAngle = function(cam,audio) {
	this._addRadY = 0;
	this._addRadX = 0;
	this._addAmp = 0;
	this._tgtRadY = 0;
	this._tgtRadX = 0;
	this._tgtAmp = 0;
	this._count = 0;
	this._camera = cam;
	window.document.addEventListener("keydown",$bind(this,this._onKeyDown));
};
camera_CamAngle.__name__ = true;
camera_CamAngle.prototype = {
	_onKeyDown: function(e) {
		var _g = Std.parseInt(e.keyCode);
		if(_g != null) switch(_g) {
		case 39:
			break;
		}
	}
	,start: function(time) {
		if(this._tweenMax != null) this._tweenMax.kill();
		this._camera.target.z = 0;
		this._tweenMax = TweenMax.to(this._camera.target,time,{ z : data_Params.distance, ease : Power0.easeInOut});
	}
	,update: function(audio) {
		audio.getTimeRatio();
		if(audio != null && audio.isStart) {
			this._count++;
			this._addRadX = Math.sin(this._count / 20) * 0.3;
			this._addRadY = Math.cos(this._count / 20) * 0.3;
		}
	}
	,setCam: function(d) {
		this._camera.amp = d.amp;
		this._camera.radX = d.radX;
		this._camera.radY = d.radY;
		this._tgtAmp = d.amp;
		this._tgtRadX = d.radX;
		this._tgtRadY = d.radY;
		this._camera.setPolar(d.amp,d.radX,d.radY);
	}
	,__class__: camera_CamAngle
};
var camera_CamData = function(n,a,rx,ry) {
	this.amp = 0;
	this.radY = 0;
	this.radX = 0;
	this.name = "";
	this.name = n;
	this.amp = a;
	this.radX = rx;
	this.radY = ry;
};
camera_CamData.__name__ = true;
camera_CamData.setRandom = function(cam,isV) {
	if(isV) camera_CamData.setCam(cam,camera_CamData.camsV[Math.floor(Math.random() * camera_CamData.camsV.length)]); else camera_CamData.setCam(cam,camera_CamData.cams[Math.floor(Math.random() * camera_CamData.cams.length)]);
};
camera_CamData.setCam = function(cam,d) {
	cam.amp = d.amp;
	cam.radX = d.radX;
	cam.radY = d.radY;
	cam.setPolar(d.amp,d.radX,d.radY);
};
camera_CamData.prototype = {
	__class__: camera_CamData
};
var camera_ExCamera = function(fov,aspect,near,far) {
	this._flag = false;
	this.tgtOffsetY = 300;
	this._countSpeed = 0;
	this._rAmp = 0;
	this._count = 0;
	this.isActive = false;
	this.radY = 0.001;
	this.radX = 0.001;
	this.amp = 300.0;
	this._oRadY = 0;
	this._oRadX = 0;
	this._height = 0;
	this._width = 0;
	this._mouseY = 0;
	this._mouseX = 0;
	this._downY = 0;
	this._downX = 0;
	this._down = false;
	THREE.PerspectiveCamera.call(this,fov,aspect,near,far);
};
camera_ExCamera.__name__ = true;
camera_ExCamera.__super__ = THREE.PerspectiveCamera;
camera_ExCamera.prototype = $extend(THREE.PerspectiveCamera.prototype,{
	init: function(dom) {
		this._camera = this;
		this.target = new THREE.Vector3();
		dom.onmousedown = $bind(this,this.onMouseDown);
		dom.onmouseup = $bind(this,this.onMouseUp);
		dom.onmousemove = $bind(this,this.onMouseMove);
		dom.onwheel = $bind(this,this.onMouseWheel);
		window.addEventListener("DOMMouseScroll",$bind(this,this.onMouseWheelFF));
	}
	,_onResize: function() {
	}
	,onMouseWheelFF: function(e) {
		this.amp += e.detail * 0.5;
		if(this.amp > 18000) this.amp = 18000;
		if(this.amp < 100) this.amp = 100;
	}
	,onMouseWheel: function(e) {
		this.amp += e.wheelDelta * 0.5;
		if(this.amp > 18000) this.amp = 18000;
		if(this.amp < 100) this.amp = 100;
	}
	,onMouseUp: function(e) {
		e.preventDefault();
		this._down = false;
	}
	,onMouseDown: function(e) {
		e.preventDefault();
		this._down = true;
		this._downX = e.clientX;
		this._downY = e.clientY;
		this._oRadX = this.radX;
		this._oRadY = this.radY;
	}
	,onMouseMove: function(e) {
		e.preventDefault();
		this._mouseX = e.clientX;
		this._mouseY = e.clientY;
	}
	,update: function() {
		if(this._down) {
			var dx = -(this._mouseX - this._downX);
			var dy = this._mouseY - this._downY;
			this.radX = this._oRadX + dx / 100;
			this.radY = this._oRadY + dy / 100;
			if(this.radY > Math.PI / 2) this.radY = Math.PI / 2;
			if(this.radY < -Math.PI / 2) this.radY = -Math.PI / 2;
		}
		if(this._camera != null) this._updatePosition(0.25);
	}
	,setFOV: function(fov) {
		console.log("setFOV = " + fov);
		this._camera.fov = fov;
		this._camera.updateProjectionMatrix();
	}
	,resize: function() {
		this._width = window.innerWidth;
		this._height = window.innerHeight;
		this._camera.aspect = this._width / this._height;
		this._camera.updateProjectionMatrix();
	}
	,reset: function(target) {
		var p = this._camera.position;
		this.amp = Math.sqrt(p.x * p.x + p.y * p.y + p.z * p.z);
		this.radX = Math.atan2(p.x,p.z);
		this.radY = Math.atan2(p.y,p.z);
		this._updatePosition();
		if(this.radY > Math.PI / 2 * 0.96) this.radY = Math.PI / 2 * 0.96;
		if(this.radY < -Math.PI / 2 * 0.96) this.radY = -Math.PI / 2 * 0.96;
		if(target != null) this._camera.lookAt(target);
	}
	,setPolar: function(a,rx,ry) {
		this.amp = a;
		this.radX = rx;
		this.radY = ry;
		this._updatePosition();
	}
	,setRAmp: function(rAmp,countSpeed) {
		this._flag = true;
		this._rAmp += rAmp;
		this._countSpeed += countSpeed;
	}
	,_onAmp: function() {
		this._flag = false;
	}
	,_updatePosition: function(spd) {
		if(spd == null) spd = 1;
		var amp1 = this.amp * Math.cos(this.radY);
		this._count += this._countSpeed;
		var ox = this._rAmp * Math.cos(this._count / 30 * 2 * Math.PI);
		var oy = this._rAmp * Math.sin(this._count / 30 * 2 * Math.PI);
		this._rAmp *= 0.97;
		this._countSpeed *= 0.95;
		var x = this.target.x + amp1 * Math.sin(this.radX) + ox;
		var y = this.target.y + this.amp * Math.sin(this.radY) + oy;
		var z = this.target.z + amp1 * Math.cos(this.radX);
		this._camera.position.x += (x - this._camera.position.x) * spd;
		this._camera.position.y += (y - this._camera.position.y) * spd;
		this._camera.position.z += (z - this._camera.position.z) * spd;
		var t = this.target.clone();
		t.y += this.tgtOffsetY;
		this.target2 = t;
		this._camera.lookAt(t);
	}
	,__class__: camera_ExCamera
});
var common_Callback = function() {
};
common_Callback.__name__ = true;
common_Callback.prototype = {
	__class__: common_Callback
};
var common_Config = function() {
};
common_Config.__name__ = true;
common_Config.prototype = {
	load: function(callback) {
		this._callback = callback;
		this._http = new haxe_Http("../../config.json");
		this._http.onData = $bind(this,this._onData);
		this._http.request();
	}
	,_onData: function(str) {
		var data = JSON.parse(str);
		common_Config.host = data.host;
		var win = window;
		win.host = common_Config.host;
		if(common_QueryGetter.getQuery("host") != null) win.host = common_QueryGetter.getQuery("host");
		common_Config.canvasOffsetY = data.canvasOffsetY;
		common_Config.globalVol = data.globalVol;
		common_Config.particleSize = data.particleSize;
		common_Config.bgLight = data.bgLight;
		if(this._callback != null) this._callback();
	}
	,__class__: common_Config
};
var common_Dat = function() {
};
common_Dat.__name__ = true;
common_Dat.init = function(callback) {
	common_StageRef.fadeIn();
	common_Dat._callback = callback;
	common_Dat._onInit();
};
common_Dat._onInit = function() {
	common_Dat.bg = window.location.hash == "#bg";
	common_Dat.gui = new dat.GUI({ autoPlace: false });
	window.document.body.appendChild(common_Dat.gui.domElement);
	common_Dat.gui.domElement.style.position = "absolute";
	common_Dat.gui.domElement.style.right = "0px";
	var yy = window.innerHeight / 2 + common_StageRef.get_stageHeight() / 2 + common_Config.canvasOffsetY;
	common_Dat.gui.domElement.style.top = Math.floor(yy / 2) + "px";
	common_Dat.gui.domElement.style.opacity = 1;
	common_Dat.gui.domElement.style.zIndex = 1000;
	common_Dat.gui.domElement.style.transformOrigin = "1 0";
	common_Dat.gui.domElement.style.transform = "scale(0.8,0.8)";
	common_Key.init();
	common_Key.board.addEventListener("keydown",common_Dat._onKeyDown);
	common_Dat.show(false);
	common_Dat.hide();
	if(common_Dat._callback != null) common_Dat._callback();
};
common_Dat._onKeyDown = function(e) {
	var _g = Std.parseInt(e.keyCode);
	if(_g != null) switch(_g) {
	case 90:
		common_Dat._soundFlag = !common_Dat._soundFlag;
		TweenMax.to(sound_MyAudio.a,0.5,{ globalVolume : common_Dat._soundFlag?common_Config.globalVol:0});
		break;
	case 68:
		if(common_Dat.gui.domElement.style.display == "block") common_Dat.hide(); else common_Dat.show(true);
		break;
	case 49:
		common_StageRef.fadeOut(common_Dat._goURL1);
		break;
	case 50:
		common_StageRef.fadeOut(common_Dat._goURL2);
		break;
	case 51:
		common_StageRef.fadeOut(common_Dat._goURL3);
		break;
	case 52:
		common_StageRef.fadeOut(common_Dat._goURL4);
		break;
	case 53:
		common_StageRef.fadeOut(common_Dat._goURL5);
		break;
	case 54:
		common_StageRef.fadeOut(common_Dat._goURL6);
		break;
	case 55:
		common_StageRef.fadeOut(common_Dat._goURL7);
		break;
	case 56:
		common_StageRef.fadeOut(common_Dat._goURL8);
		break;
	}
};
common_Dat._goURL1 = function() {
	common_Dat._goURL("../../p04/bin/");
};
common_Dat._goURL2 = function() {
	common_Dat._goURL("../../p05/bin/");
};
common_Dat._goURL3 = function() {
	common_Dat._goURL("../../p08/bin/");
};
common_Dat._goURL4 = function() {
	common_Dat._goURL("../../p02/bin/");
};
common_Dat._goURL5 = function() {
	common_Dat._goURL("../../p07/bin/");
};
common_Dat._goURL6 = function() {
	common_Dat._goURL("../../p03/bin/");
};
common_Dat._goURL7 = function() {
	common_Dat._goURL("../../p06/bin/");
};
common_Dat._goURL8 = function() {
	common_Dat._goURL("../../p09/bin/");
};
common_Dat._goURL = function(url) {
	Tracer.log("goURL " + url);
	window.location.href = url + window.location.hash;
};
common_Dat.show = function(isBorder) {
	if(isBorder == null) isBorder = false;
	if(isBorder) common_StageRef.showBorder();
	common_Dat.gui.domElement.style.display = "block";
};
common_Dat.hide = function() {
	common_StageRef.hideBorder();
	common_Dat.gui.domElement.style.display = "none";
};
common_Dat.prototype = {
	__class__: common_Dat
};
var common_FadeSheet = function(ee) {
	this.opacity = 1;
	this.element = ee;
};
common_FadeSheet.__name__ = true;
common_FadeSheet.prototype = {
	fadeIn: function() {
		if(this.element != null) {
			this.element.style.opacity = "0";
			this.opacity = 0;
			if(this._twn != null) this._twn.kill();
			this._twn = TweenMax.to(this,0.8,{ opacity : 1, delay : 0.2, ease : Power0.easeInOut, onUpdate : $bind(this,this._onUpdate)});
		}
	}
	,fadeOut: function(callback) {
		if(this._twn != null) this._twn.kill();
		this._twn = TweenMax.to(this,0.5,{ opacity : 0, ease : Power0.easeInOut, onUpdate : $bind(this,this._onUpdate), onComplete : callback});
	}
	,_onUpdate: function() {
		if(this.element != null) this.element.style.opacity = "" + this.opacity;
	}
	,__class__: common_FadeSheet
};
var common_Key = function() {
	THREE.EventDispatcher.call(this);
};
common_Key.__name__ = true;
common_Key.init = function() {
	if(common_Key.board == null) {
		common_Key.board = new common_Key();
		common_Key.board.init2();
	}
};
common_Key.__super__ = THREE.EventDispatcher;
common_Key.prototype = $extend(THREE.EventDispatcher.prototype,{
	init2: function() {
		window.document.body.addEventListener("keydown",$bind(this,this._onKeyDown));
	}
	,_onKeyDown: function(e) {
		var n = Std.parseInt(e.keyCode);
		Tracer.info("_onkeydown " + n);
		this._dispatch(n);
	}
	,_dispatch: function(n) {
		if(!common_Dat.bg) {
		}
		this.dispatchEvent({ type : "keydown", keyCode : n});
	}
	,__class__: common_Key
});
var common_Mojis = function() {
	this._rad = 0;
	THREE.Object3D.call(this);
};
common_Mojis.__name__ = true;
common_Mojis.__super__ = THREE.Object3D;
common_Mojis.prototype = $extend(THREE.Object3D.prototype,{
	init: function(callback) {
		this._callback = callback;
		this._shape = data_DataManager.getInstance().fontShape;
		this.scale.set(3,3,3);
	}
	,_onInit0: function() {
		var src = "MERRY CHRISTMAS";
		var list = [];
		var space = 140;
		var spaceY = 250;
		var g = new THREE.Geometry();
		var _g1 = 0;
		var _g = src.length;
		while(_g1 < _g) {
			var j = _g1++;
			var shapes = this._shape.getShapes(HxOverrides.substr(src,j,1),true);
			var geo = new THREE.ExtrudeGeometry(shapes,{ bevelEnabled : true, amount : 30});
			var mat4 = new THREE.Matrix4();
			mat4.multiply(new THREE.Matrix4().makeScale(1,1,1));
			var vv = new THREE.Vector3((j * space - (src.length - 1) / 2 * space) * 0.5,0,0);
			mat4.multiply(new THREE.Matrix4().makeTranslation(vv.x,vv.y,vv.z));
			g.merge(geo,mat4);
		}
		this._material = new THREE.MeshPhongMaterial({ color : 16776960});
		this._meshes = [];
		var _g2 = 0;
		while(_g2 < 1) {
			var i = _g2++;
			var m = new THREE.Mesh(g,this._material);
			m.castShadow = true;
			var rr = Math.random() * 0.1;
			m.position.y += 60 * (Math.random() - 0.5);
			this.add(m);
			this._meshes.push(m);
		}
		if(this._callback != null) this._callback();
	}
	,setEnvMap: function(texture) {
		this._material.envMap = texture;
	}
	,update: function() {
		var _g1 = 0;
		var _g = this._meshes.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._meshes[i].rotation.x += 0.001 * (i + 1);
			this._meshes[i].rotation.y += 0.003 * (i + 1);
			this._meshes[i].rotation.z += 0.004 * (i + 1);
		}
	}
	,__class__: common_Mojis
});
var common_QueryGetter = function() {
};
common_QueryGetter.__name__ = true;
common_QueryGetter.init = function() {
	common_QueryGetter._map = new haxe_ds_StringMap();
	var str = window.location.search;
	if(str.indexOf("?") < 0) Tracer.log("query nashi"); else {
		str = HxOverrides.substr(str,1,str.length - 1);
		var list = str.split("&");
		Tracer.log(list);
		var _g1 = 0;
		var _g = list.length;
		while(_g1 < _g) {
			var i = _g1++;
			var fuga = list[i].split("=");
			common_QueryGetter._map.set(fuga[0],fuga[1]);
		}
	}
	if(common_QueryGetter._map.get("t") != null) common_QueryGetter.t = Std.parseInt(common_QueryGetter._map.get("t"));
	common_QueryGetter._isInit = true;
};
common_QueryGetter.getQuery = function(idd) {
	if(!common_QueryGetter._isInit) common_QueryGetter.init();
	return common_QueryGetter._map.get(idd);
};
common_QueryGetter.prototype = {
	__class__: common_QueryGetter
};
var common_StageRef = function() {
};
common_StageRef.__name__ = true;
common_StageRef.__properties__ = {get_stageHeight:"get_stageHeight",get_stageWidth:"get_stageWidth"}
common_StageRef.showBorder = function() {
	var dom = window.document.getElementById("webgl");
	if(dom != null) dom.style.border = "solid 1px #cccccc";
};
common_StageRef.hideBorder = function() {
	var dom = window.document.getElementById("webgl");
	if(dom != null) dom.style.border = "solid 0px";
};
common_StageRef.fadeIn = function() {
	if(common_StageRef.sheet == null) common_StageRef.sheet = new common_FadeSheet(window.document.getElementById("webgl"));
	common_StageRef.sheet.fadeIn();
};
common_StageRef.fadeOut = function(callback) {
	if(common_StageRef.sheet == null) common_StageRef.sheet = new common_FadeSheet(window.document.getElementById("webgl"));
	common_StageRef.sheet.fadeOut(callback);
};
common_StageRef.setCenter = function(offsetY) {
	if(offsetY == null) offsetY = 0;
	var dom = window.document.getElementById("webgl");
	var yy = window.innerHeight / 2 - common_StageRef.get_stageHeight() / 2 + common_Config.canvasOffsetY + offsetY;
	dom.style.position = "absolute";
	dom.style.zIndex = "1000";
	dom.style.top = Math.round(yy) + "px";
};
common_StageRef.get_stageWidth = function() {
	return window.innerWidth;
};
common_StageRef.get_stageHeight = function() {
	return window.innerHeight;
};
common_StageRef.prototype = {
	__class__: common_StageRef
};
var common_StringUtils = function() {
};
common_StringUtils.__name__ = true;
common_StringUtils.addCommma = function(n) {
	var s;
	if(n == null) s = "null"; else s = "" + n;
	var out = "";
	var _g1 = 0;
	var _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		out += HxOverrides.substr(s,i,1);
		var keta = s.length - 1 - i;
		if(keta % 3 == 0 && keta != 0) out += ",";
	}
	return out;
};
common_StringUtils.addCommaStr = function(s) {
	if(s.length <= 3) return s;
	var out = "";
	var lastIndex = s.length - 1;
	var last = "";
	var _g1 = 0;
	var _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		var j = lastIndex - i;
		var last1 = HxOverrides.substr(s,j,1);
		if(i % 3 == 0 && i != 0) out = last1 + "," + out; else out = last1 + out;
	}
	return out;
};
common_StringUtils.addZero = function(val,keta) {
	var valStr = "" + val;
	var sa = keta - valStr.length;
	while(sa-- > 0) valStr = "0" + valStr;
	return valStr;
};
common_StringUtils.getDecimal = function(t,keta) {
	var n = Math.pow(10,keta - 1);
	n = Math.floor(t * n) / n;
	var str = "" + n;
	if(str.length == 1) str = str + ".";
	while(true) {
		if(str.length >= keta + 1) break;
		str = str + "0";
	}
	return str;
};
common_StringUtils.date2string = function(open_date) {
	if(open_date == null) return "UNDEFINED";
	var out = open_date.getFullYear() + "/" + common_StringUtils.addZero(open_date.getMonth() + 1,2) + "/" + common_StringUtils.addZero(open_date.getDate(),2);
	return out;
};
common_StringUtils.string2date = function(s) {
	var a = s.split("-");
	var date = new Date(Std.parseInt(a[0]),Std.parseInt(a[1]) - 1,Std.parseInt(a[2]),12,0,0);
	return date;
};
common_StringUtils.prototype = {
	__class__: common_StringUtils
};
var common_TimeCounter = function() {
};
common_TimeCounter.__name__ = true;
common_TimeCounter.start = function() {
	common_TimeCounter._time = new Date();
};
common_TimeCounter.getTime = function() {
	var now = new Date();
	var time = Math.floor(now.getTime() - common_TimeCounter._time.getTime());
	var out = "";
	var msec = time % 1000;
	msec = Math.floor(msec / 100);
	var sec = Math.floor(time / 1000);
	var secOut = sec % 60;
	var min = Math.floor(sec / 60);
	var out1 = "00:" + common_StringUtils.addZero(min,2) + ":" + common_StringUtils.addZero(secOut,2);
	return out1;
};
common_TimeCounter.prototype = {
	__class__: common_TimeCounter
};
var data_DataManager = function() {
	if(data_DataManager.internallyCalled) data_DataManager.internallyCalled = false; else throw new js__$Boot_HaxeError("Singleton.getInstance()で生成してね。");
};
data_DataManager.__name__ = true;
data_DataManager.getInstance = function() {
	if(data_DataManager.instance == null) {
		data_DataManager.internallyCalled = true;
		data_DataManager.instance = new data_DataManager();
	}
	return data_DataManager.instance;
};
data_DataManager.prototype = {
	load: function(callback) {
		this._callback = callback;
		this.cats = new loaders_CatsLoader();
		this.cats.load($bind(this,this._onLoad));
	}
	,_onLoad: function() {
		console.log("==onLoad==");
		this.box = new loaders_MyBoxLoader();
		this.box.load("obj/box/box.dae",$bind(this,this._onLoad2));
	}
	,_onLoad2: function() {
		this.fontShape = new FontShapeMaker();
		this.fontShape.init("font/DINBold.json",$bind(this,this._onLoad3));
	}
	,_onLoad3: function() {
		this.moji = new loaders_MyBoxLoader();
		this.moji.load("obj/moji/moji.dae",$bind(this,this._onLoad4));
	}
	,_onLoad4: function() {
		if(this._callback != null) this._callback();
	}
	,__class__: data_DataManager
};
var data_NoteonData = function(o,ttype,iid) {
	this.id = 0;
	this.midi = 0;
	this.id = iid;
	this.type = ttype;
	this.name = o.name;
	this.midi = o.midi;
	this.time = o.time;
	this.velocity = o.velocity;
	this.duration = o.duration;
};
data_NoteonData.__name__ = true;
data_NoteonData.prototype = {
	__class__: data_NoteonData
};
var data_Params = function() {
};
data_Params.__name__ = true;
data_Params.prototype = {
	__class__: data_Params
};
var data_Quality = function() {
};
data_Quality.__name__ = true;
data_Quality.prototype = {
	__class__: data_Quality
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
var haxe_Http = function(url) {
	this.url = url;
	this.headers = new List();
	this.params = new List();
	this.async = true;
};
haxe_Http.__name__ = true;
haxe_Http.prototype = {
	request: function(post) {
		var me = this;
		me.responseData = null;
		var r = this.req = js_Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s;
			try {
				s = r.status;
			} catch( e ) {
				if (e instanceof js__$Boot_HaxeError) e = e.val;
				s = null;
			}
			if(s != null) {
				var protocol = window.location.protocol.toLowerCase();
				var rlocalProtocol = new EReg("^(?:about|app|app-storage|.+-extension|file|res|widget):$","");
				var isLocal = rlocalProtocol.match(protocol);
				if(isLocal) if(r.responseText != null) s = 200; else s = 404;
			}
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) {
				me.req = null;
				me.onData(me.responseData = r.responseText);
			} else if(s == null) {
				me.req = null;
				me.onError("Failed to connect or resolve host");
			} else switch(s) {
			case 12029:
				me.req = null;
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.req = null;
				me.onError("Unknown host");
				break;
			default:
				me.req = null;
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var _g_head = this.params.h;
			var _g_val = null;
			while(_g_head != null) {
				var p;
				p = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				if(uri == null) uri = ""; else uri += "&";
				uri += encodeURIComponent(p.param) + "=" + encodeURIComponent(p.value);
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e1 ) {
			if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
			me.req = null;
			this.onError(e1.toString());
			return;
		}
		if(!Lambda.exists(this.headers,function(h) {
			return h.header == "Content-Type";
		}) && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var _g_head1 = this.headers.h;
		var _g_val1 = null;
		while(_g_head1 != null) {
			var h1;
			h1 = (function($this) {
				var $r;
				_g_val1 = _g_head1[0];
				_g_head1 = _g_head1[1];
				$r = _g_val1;
				return $r;
			}(this));
			r.setRequestHeader(h1.header,h1.value);
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
	,__class__: haxe_Http
};
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
haxe__$Int64__$_$_$Int64.__name__ = true;
haxe__$Int64__$_$_$Int64.prototype = {
	__class__: haxe__$Int64__$_$_$Int64
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = true;
haxe_Timer.delay = function(f,time_ms) {
	var t = new haxe_Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,__class__: haxe_ds_StringMap
};
var haxe_io_Bytes = function() { };
haxe_io_Bytes.__name__ = true;
var haxe_io_Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe_io_Error.Blocked = ["Blocked",0];
haxe_io_Error.Blocked.toString = $estr;
haxe_io_Error.Blocked.__enum__ = haxe_io_Error;
haxe_io_Error.Overflow = ["Overflow",1];
haxe_io_Error.Overflow.toString = $estr;
haxe_io_Error.Overflow.__enum__ = haxe_io_Error;
haxe_io_Error.OutsideBounds = ["OutsideBounds",2];
haxe_io_Error.OutsideBounds.toString = $estr;
haxe_io_Error.OutsideBounds.__enum__ = haxe_io_Error;
haxe_io_Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe_io_Error; $x.toString = $estr; return $x; };
var haxe_io_FPHelper = function() { };
haxe_io_FPHelper.__name__ = true;
haxe_io_FPHelper.i32ToFloat = function(i) {
	var sign = 1 - (i >>> 31 << 1);
	var exp = i >>> 23 & 255;
	var sig = i & 8388607;
	if(sig == 0 && exp == 0) return 0.0;
	return sign * (1 + Math.pow(2,-23) * sig) * Math.pow(2,exp - 127);
};
haxe_io_FPHelper.floatToI32 = function(f) {
	if(f == 0) return 0;
	var af;
	if(f < 0) af = -f; else af = f;
	var exp = Math.floor(Math.log(af) / 0.6931471805599453);
	if(exp < -127) exp = -127; else if(exp > 128) exp = 128;
	var sig = Math.round((af / Math.pow(2,exp) - 1) * 8388608) & 8388607;
	return (f < 0?-2147483648:0) | exp + 127 << 23 | sig;
};
haxe_io_FPHelper.i64ToDouble = function(low,high) {
	var sign = 1 - (high >>> 31 << 1);
	var exp = (high >> 20 & 2047) - 1023;
	var sig = (high & 1048575) * 4294967296. + (low >>> 31) * 2147483648. + (low & 2147483647);
	if(sig == 0 && exp == -1023) return 0.0;
	return sign * (1.0 + Math.pow(2,-52) * sig) * Math.pow(2,exp);
};
haxe_io_FPHelper.doubleToI64 = function(v) {
	var i64 = haxe_io_FPHelper.i64tmp;
	if(v == 0) {
		i64.low = 0;
		i64.high = 0;
	} else {
		var av;
		if(v < 0) av = -v; else av = v;
		var exp = Math.floor(Math.log(av) / 0.6931471805599453);
		var sig;
		var v1 = (av / Math.pow(2,exp) - 1) * 4503599627370496.;
		sig = Math.round(v1);
		var sig_l = sig | 0;
		var sig_h = sig / 4294967296.0 | 0;
		i64.low = sig_l;
		i64.high = (v < 0?-2147483648:0) | exp + 1023 << 20 | sig_h;
	}
	return i64;
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_Browser = function() { };
js_Browser.__name__ = true;
js_Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw new js__$Boot_HaxeError("Unable to create XMLHttpRequest object.");
};
var js_html_compat_ArrayBuffer = function(a) {
	if((a instanceof Array) && a.__enum__ == null) {
		this.a = a;
		this.byteLength = a.length;
	} else {
		var len = a;
		this.a = [];
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			this.a[i] = 0;
		}
		this.byteLength = len;
	}
};
js_html_compat_ArrayBuffer.__name__ = true;
js_html_compat_ArrayBuffer.sliceImpl = function(begin,end) {
	var u = new Uint8Array(this,begin,end == null?null:end - begin);
	var result = new ArrayBuffer(u.byteLength);
	var resultArray = new Uint8Array(result);
	resultArray.set(u);
	return result;
};
js_html_compat_ArrayBuffer.prototype = {
	slice: function(begin,end) {
		return new js_html_compat_ArrayBuffer(this.a.slice(begin,end));
	}
	,__class__: js_html_compat_ArrayBuffer
};
var js_html_compat_DataView = function(buffer,byteOffset,byteLength) {
	this.buf = buffer;
	if(byteOffset == null) this.offset = 0; else this.offset = byteOffset;
	if(byteLength == null) this.length = buffer.byteLength - this.offset; else this.length = byteLength;
	if(this.offset < 0 || this.length < 0 || this.offset + this.length > buffer.byteLength) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
};
js_html_compat_DataView.__name__ = true;
js_html_compat_DataView.prototype = {
	getInt8: function(byteOffset) {
		var v = this.buf.a[this.offset + byteOffset];
		if(v >= 128) return v - 256; else return v;
	}
	,getUint8: function(byteOffset) {
		return this.buf.a[this.offset + byteOffset];
	}
	,getInt16: function(byteOffset,littleEndian) {
		var v = this.getUint16(byteOffset,littleEndian);
		if(v >= 32768) return v - 65536; else return v;
	}
	,getUint16: function(byteOffset,littleEndian) {
		if(littleEndian) return this.buf.a[this.offset + byteOffset] | this.buf.a[this.offset + byteOffset + 1] << 8; else return this.buf.a[this.offset + byteOffset] << 8 | this.buf.a[this.offset + byteOffset + 1];
	}
	,getInt32: function(byteOffset,littleEndian) {
		var p = this.offset + byteOffset;
		var a = this.buf.a[p++];
		var b = this.buf.a[p++];
		var c = this.buf.a[p++];
		var d = this.buf.a[p++];
		if(littleEndian) return a | b << 8 | c << 16 | d << 24; else return d | c << 8 | b << 16 | a << 24;
	}
	,getUint32: function(byteOffset,littleEndian) {
		var v = this.getInt32(byteOffset,littleEndian);
		if(v < 0) return v + 4294967296.; else return v;
	}
	,getFloat32: function(byteOffset,littleEndian) {
		return haxe_io_FPHelper.i32ToFloat(this.getInt32(byteOffset,littleEndian));
	}
	,getFloat64: function(byteOffset,littleEndian) {
		var a = this.getInt32(byteOffset,littleEndian);
		var b = this.getInt32(byteOffset + 4,littleEndian);
		return haxe_io_FPHelper.i64ToDouble(littleEndian?a:b,littleEndian?b:a);
	}
	,setInt8: function(byteOffset,value) {
		if(value < 0) this.buf.a[byteOffset + this.offset] = value + 128 & 255; else this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setUint8: function(byteOffset,value) {
		this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setInt16: function(byteOffset,value,littleEndian) {
		this.setUint16(byteOffset,value < 0?value + 65536:value,littleEndian);
	}
	,setUint16: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
		} else {
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p] = value & 255;
		}
	}
	,setInt32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,value,littleEndian);
	}
	,setUint32: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p++] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >>> 24;
		} else {
			this.buf.a[p++] = value >>> 24;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value & 255;
		}
	}
	,setFloat32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,haxe_io_FPHelper.floatToI32(value),littleEndian);
	}
	,setFloat64: function(byteOffset,value,littleEndian) {
		var i64 = haxe_io_FPHelper.doubleToI64(value);
		if(littleEndian) {
			this.setUint32(byteOffset,i64.low);
			this.setUint32(byteOffset,i64.high);
		} else {
			this.setUint32(byteOffset,i64.high);
			this.setUint32(byteOffset,i64.low);
		}
	}
	,__class__: js_html_compat_DataView
};
var js_html_compat_Uint8Array = function() { };
js_html_compat_Uint8Array.__name__ = true;
js_html_compat_Uint8Array._new = function(arg1,offset,length) {
	var arr;
	if(typeof(arg1) == "number") {
		arr = [];
		var _g = 0;
		while(_g < arg1) {
			var i = _g++;
			arr[i] = 0;
		}
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else if(js_Boot.__instanceof(arg1,js_html_compat_ArrayBuffer)) {
		var buffer = arg1;
		if(offset == null) offset = 0;
		if(length == null) length = buffer.byteLength - offset;
		if(offset == 0) arr = buffer.a; else arr = buffer.a.slice(offset,offset + length);
		arr.byteLength = arr.length;
		arr.byteOffset = offset;
		arr.buffer = buffer;
	} else if((arg1 instanceof Array) && arg1.__enum__ == null) {
		arr = arg1.slice();
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else throw new js__$Boot_HaxeError("TODO " + Std.string(arg1));
	arr.subarray = js_html_compat_Uint8Array._subarray;
	arr.set = js_html_compat_Uint8Array._set;
	return arr;
};
js_html_compat_Uint8Array._set = function(arg,offset) {
	var t = this;
	if(js_Boot.__instanceof(arg.buffer,js_html_compat_ArrayBuffer)) {
		var a = arg;
		if(arg.byteLength + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g1 = 0;
		var _g = arg.byteLength;
		while(_g1 < _g) {
			var i = _g1++;
			t[i + offset] = a[i];
		}
	} else if((arg instanceof Array) && arg.__enum__ == null) {
		var a1 = arg;
		if(a1.length + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g11 = 0;
		var _g2 = a1.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			t[i1 + offset] = a1[i1];
		}
	} else throw new js__$Boot_HaxeError("TODO");
};
js_html_compat_Uint8Array._subarray = function(start,end) {
	var t = this;
	var a = js_html_compat_Uint8Array._new(t.slice(start,end));
	a.byteOffset = start;
	return a;
};
var light_DLight = function(hex,intensity,scene) {
	this.radY = 0.001;
	this.radX = 0.001;
	this.amp = 500;
	THREE.DirectionalLight.call(this,hex,intensity);
	var size = 1000;
	this.castShadow = true;
	this.shadow.camera.near = 1;
	this.shadow.camera.far = 1000;
	this.shadow.camera.right = size;
	this.shadow.camera.left = -size;
	this.shadow.camera.top = size;
	this.shadow.camera.bottom = -size;
	this.shadow.mapSize.width = 1024;
	this.shadow.mapSize.height = 1024;
	this.shadowCameraVisible = true;
	this.radY = Math.PI / 4;
	this._obj = new THREE.Object3D();
	scene.add(this._obj);
	this.target = this._obj;
	common_Dat.gui.add(this,"radX",-6.28,6.28).listen();
	common_Dat.gui.add(this,"radY",-6.28,6.28).listen();
};
light_DLight.__name__ = true;
light_DLight.__super__ = THREE.DirectionalLight;
light_DLight.prototype = $extend(THREE.DirectionalLight.prototype,{
	update: function(tt) {
		if(tt == null) return;
		this.target.position.x = tt.x;
		this.target.position.y = tt.y;
		this.target.position.z = tt.z;
		var amp1 = this.amp * Math.cos(this.radY);
		var xx = tt.x + amp1 * Math.sin(this.radX);
		var yy = tt.y + this.amp * Math.sin(this.radY);
		var zz = tt.z + amp1 * Math.cos(this.radX);
		this.position.x = xx;
		this.position.y = yy;
		this.position.z = zz;
	}
	,__class__: light_DLight
});
var loaders_CatsLoader = function() {
	THREE.Object3D.call(this);
};
loaders_CatsLoader.__name__ = true;
loaders_CatsLoader.__super__ = THREE.Object3D;
loaders_CatsLoader.prototype = $extend(THREE.Object3D.prototype,{
	load: function(callback) {
		this._callback = callback;
		this.head = new loaders_MyCATLoader();
		this.hip = new loaders_MyCATLoader();
		this.body = new loaders_MyCATLoader();
		this.circle = new loaders_MyCATLoader();
		this.tail = new loaders_MyCATLoader();
		this.head.load("./obj/cat/head1.dae",$bind(this,this._onLoad1));
	}
	,_onLoad1: function() {
		this.hip.load("./obj/cat/hip1.dae",$bind(this,this._onLoad2));
	}
	,_onLoad2: function() {
		this.body.load("./obj/cat/body1.dae",$bind(this,this._onLoad3));
	}
	,_onLoad3: function() {
		this.circle.load("./obj/cat/circle.dae",$bind(this,this._onLoad4));
	}
	,_onLoad4: function() {
		var materials = [new THREE.MeshBasicMaterial({ color : 16711680, wireframe : true}),new THREE.MeshBasicMaterial({ color : 65280, wireframe : true})];
		var extrudeMaterial = new THREE.MeshFaceMaterial(materials);
		var shape = new THREE.Shape();
		var _g1 = 0;
		var _g = this.circle.baseGeo.length;
		while(_g1 < _g) {
			var i = _g1++;
			var vv = this.circle.baseGeo[i];
			if(i == 0) shape.moveTo(vv.x,vv.z); else shape.lineTo(vv.x,vv.z);
		}
		var g = new THREE.ExtrudeGeometry(shape,{ steps : 10, amount : 10, bevelEnabled : false, material : 0, extrudeMaterial : 1});
		var extrudeMesh = new THREE.Mesh(g,extrudeMaterial);
		extrudeMesh.scale.set(100,100,100);
		this.add(extrudeMesh);
		if(this._callback != null) this._callback();
	}
	,__class__: loaders_CatsLoader
});
var loaders_MyDAELoader = function() {
};
loaders_MyDAELoader.__name__ = true;
loaders_MyDAELoader.getPosY = function(ratio) {
	ratio = 1 - ratio;
	var maxY = 1.36578;
	var minY = -1.13318;
	return minY + (maxY - minY) * ratio;
};
loaders_MyDAELoader.getRatioY = function(posY,pow,posR) {
	var maxY = 1.36578;
	var minY = -1.13318;
	var r = (posY - minY) / (maxY - minY);
	if(r < posR) r = Math.pow(r,pow); else r = Math.pow(r,1 / pow);
	return r;
};
loaders_MyDAELoader.getHeight = function(ratio) {
	return 2.4989600000000003 * ratio;
};
loaders_MyDAELoader.prototype = {
	load: function(filename,callback) {
		this._callback = callback;
		var loader = new THREE.ColladaLoader();
		loader.options.convertUpAxis = true;
		loader.load(filename,$bind(this,this._onComplete));
	}
	,_onComplete: function(collada) {
		this.dae = collada.scene;
		this.dae.scale.x = this.dae.scale.y = this.dae.scale.z = 170;
		this.material = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("mae_face_.png"), side : 0});
		this.materialB = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("mae_face_blue.png"), side : 0});
		this.materialC = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("mae_faceB.png"), side : 0});
		this.materialD = new THREE.MeshBasicMaterial({ map : THREE.ImageUtils.loadTexture("mae_face_mono.png"), side : 0});
		this.geometry = this.dae.children[0].children[0].geometry;
		this.geometry.verticesNeedUpdate = true;
		this._makeBaseGeo();
		if(this._callback != null) this._callback();
	}
	,_makeBaseGeo: function() {
		this.baseGeo = [];
		var _g1 = 0;
		var _g = this.geometry.vertices.length;
		while(_g1 < _g) {
			var i = _g1++;
			var v = this.geometry.vertices[i].clone();
			this.baseGeo.push(v);
		}
	}
	,__class__: loaders_MyDAELoader
};
var loaders_MyBoxLoader = function() {
	this.scale = 100;
	loaders_MyDAELoader.call(this);
};
loaders_MyBoxLoader.__name__ = true;
loaders_MyBoxLoader.__super__ = loaders_MyDAELoader;
loaders_MyBoxLoader.prototype = $extend(loaders_MyDAELoader.prototype,{
	load: function(filename,callback) {
		this._callback = callback;
		var loader = new THREE.ColladaLoader();
		loader.options.convertUpAxis = true;
		loader.load(filename,$bind(this,this._onComplete));
	}
	,_onComplete: function(ret) {
		var dae = ret.scene;
		this.mat = new THREE.MeshLambertMaterial({ map : THREE.ImageUtils.loadTexture("./box.jpg"), color : 16777215, ambient : 16777215, side : 2});
		this.mat.shading = 2;
		this.mat.alphaTest = 0.9;
		this.meshes = [];
		this.geos = [];
		
			var hoge = this;
			dae.traverse( function(child){
				if( child instanceof THREE.Mesh){
					child.material = hoge.mat;
					hoge.geos.push(child.geometry);
					hoge.meshes.push(child);
				}
			});
		;
		Tracer.info("____");
		Tracer.info(this.geos[0]);
		if(this._callback != null) this._callback();
	}
	,__class__: loaders_MyBoxLoader
});
var loaders_MyCATLoader = function() {
	this.scale = 100;
	loaders_MyDAELoader.call(this);
};
loaders_MyCATLoader.__name__ = true;
loaders_MyCATLoader.__super__ = loaders_MyDAELoader;
loaders_MyCATLoader.prototype = $extend(loaders_MyDAELoader.prototype,{
	load: function(filename,callback) {
		this._callback = callback;
		var loader = new THREE.ColladaLoader();
		loader.options.convertUpAxis = true;
		loader.load(filename,$bind(this,this._onComplete));
	}
	,_onComplete: function(ret) {
		var dae = ret.scene;
		var mm = new shaders_MaeShaderMaterial("./obj/cat/cat_diff.jpg");
		this.mesh = null;
		
			var hoge = this;
			dae.traverse( function(child){
				if( child instanceof THREE.Mesh){
					child.material = mm;
					hoge.mesh = child;
					//alert('hoge ' + child);
					//mm.specular.set(0,0,0);
				}
			});
		;
		if(this.mesh != null) this.mesh.scale.set(this.scale,this.scale,this.scale);
		this.geo = this.mesh.geometry.clone();
		this.geo.verticesNeedUpdate = true;
		this.mat = this.mesh.material;
		this.baseGeo = [];
		var _g1 = 0;
		var _g = this.geo.vertices.length;
		while(_g1 < _g) {
			var i = _g1++;
			var vec = new THREE.Vector3(this.geo.vertices[i].x * 4,this.geo.vertices[i].y * 4,this.geo.vertices[i].z * 4);
			this.baseGeo.push(vec);
		}
		this.geometry = this.geo;
		this.material = mm;
		if(this._callback != null) this._callback();
	}
	,clone: function() {
		if(this.geometry == null) Tracer.error("error geo");
		if(this.material == null) Tracer.error("error mat");
		var m = new THREE.Mesh(this.geometry,this.material);
		m.scale.set(this.scale,this.scale,this.scale);
		return m;
	}
	,__class__: loaders_MyCATLoader
});
var net_badimon_five3D_typography_Typography3D = function() {
	this.motifs = new haxe_ds_StringMap();
	this.widths = new haxe_ds_StringMap();
};
net_badimon_five3D_typography_Typography3D.__name__ = true;
net_badimon_five3D_typography_Typography3D.prototype = {
	getMotif: function($char) {
		return this.motifs.get($char);
	}
	,getWidth: function($char) {
		return this.widths.get($char);
	}
	,getHeight: function() {
		return this.height;
	}
	,__class__: net_badimon_five3D_typography_Typography3D
};
var net_badimon_five3D_typography_GenTypography3D = function() {
	net_badimon_five3D_typography_Typography3D.call(this);
};
net_badimon_five3D_typography_GenTypography3D.__name__ = true;
net_badimon_five3D_typography_GenTypography3D.__super__ = net_badimon_five3D_typography_Typography3D;
net_badimon_five3D_typography_GenTypography3D.prototype = $extend(net_badimon_five3D_typography_Typography3D.prototype,{
	init: function(uri,callback) {
		this._callback = callback;
		var http = new haxe_Http(uri);
		http.onData = $bind(this,this._onLoad);
		http.request(false);
	}
	,initByString: function(jsonStr) {
		this._onLoad(jsonStr);
	}
	,_onLoad: function(data) {
		var o = JSON.parse(data);
		var _g = 0;
		var _g1 = Reflect.fields(o);
		while(_g < _g1.length) {
			var key = _g1[_g];
			++_g;
			if(key == "height") this.height = Reflect.getProperty(o,key); else this._initTypo(key,Reflect.getProperty(o,key));
		}
		this._callback();
	}
	,_initTypo: function(key,ary) {
		var value = ary[0];
		this.widths.set(key,value);
		var motif = [];
		var _g1 = 1;
		var _g = ary.length;
		while(_g1 < _g) {
			var i = _g1++;
			motif.push(this._initAry(ary[i]));
		}
		this.motifs.set(key,motif);
	}
	,_initAry: function(str) {
		var list = str.split(",");
		var out = [];
		out[0] = list[0];
		if(out[0] == "C") out[1] = [parseFloat(list[1]),parseFloat(list[2]),parseFloat(list[3]),parseFloat(list[4])]; else out[1] = [parseFloat(list[1]),parseFloat(list[2])];
		return out;
	}
	,__class__: net_badimon_five3D_typography_GenTypography3D
});
var objects_Cat = function() {
	this._showing = true;
	this._rotSpeed = Math.random() * Math.PI / 42;
	this._limit = 600 + 200 * Math.random();
	this.index = 0;
	THREE.Object3D.call(this);
};
objects_Cat.__name__ = true;
objects_Cat.__super__ = THREE.Object3D;
objects_Cat.prototype = $extend(THREE.Object3D.prototype,{
	init: function(value) {
		this._rotSpeed = Math.pow(value,2);
		this._dataManager = data_DataManager.getInstance();
		this._cat = this._dataManager.cats.head.mesh.clone();
		console.log("_cat.scale " + Std.string(this._cat.scale));
		this.add(this._cat);
		var hat = new THREE.Mesh(new THREE.ConeGeometry(0.1,0.2),new THREE.MeshLambertMaterial({ color : 16711680}));
		hat.rotation.x = -Math.PI / 2;
		hat.position.y = -0.1;
		hat.position.z = -0.4;
		this._cat.add(hat);
		this._body = new objects_CatBody();
		this._body.scale.set(100,0.001,100);
		this._body.init();
		this._body.position.y = -63.743;
		this._body.castShadow = true;
		this.add(this._body);
		this._hip = this._dataManager.cats.hip.mesh.clone();
		this._hip.castShadow = true;
		this.add(this._hip);
		this._showing = true;
		this.castShadow = true;
	}
	,update: function(audio) {
		this._cat.position.y += 2;
		var headPos = this._cat.position.y - 63.743;
		if(this._showing) this._body.setStart(headPos); else {
			this._body.position.y = headPos;
			this._hip.position.y = headPos - this._body.scale.y;
		}
	}
	,getPosY: function() {
		return this._cat.position.y;
	}
	,hide: function(callback) {
		if(this._showing) {
			this._showing = false;
			this._callback = callback;
			haxe_Timer.delay($bind(this,this._onHide),800);
		}
	}
	,_onHide: function() {
		this._callback(this);
	}
	,__class__: objects_Cat
});
var objects_CatBody = function() {
	this._base = [new THREE.Vector2(0,0.15793),new THREE.Vector2(-0.03581,0.14858),new THREE.Vector2(-0.07219,0.10586),new THREE.Vector2(-0.09726,0.05336),new THREE.Vector2(-0.09811,0.00179),new THREE.Vector2(-0.09122,-0.07178),new THREE.Vector2(-0.0645,-0.12716),new THREE.Vector2(0,-0.13991),new THREE.Vector2(0.0645,-0.12716),new THREE.Vector2(0.09122,-0.07178),new THREE.Vector2(0.09862,0.00179),new THREE.Vector2(0.09921,0.05336),new THREE.Vector2(0.07414,0.10586),new THREE.Vector2(0.03624,0.14858),new THREE.Vector2(0,0.15793)];
	this._base2 = [new THREE.Vector2(0,0.14884),new THREE.Vector2(-0.03581,0.1395),new THREE.Vector2(-0.07219,0.09677),new THREE.Vector2(-0.09726,0.04428),new THREE.Vector2(-0.09811,-0.0073),new THREE.Vector2(-0.09122,-0.08087),new THREE.Vector2(-0.0645,-0.13625),new THREE.Vector2(0,-0.149),new THREE.Vector2(0.0645,-0.13625),new THREE.Vector2(0.09122,-0.08087),new THREE.Vector2(0.09862,-0.0073),new THREE.Vector2(0.09921,0.04428),new THREE.Vector2(0.07414,0.09677),new THREE.Vector2(0.03624,0.1395),new THREE.Vector2(0,0.14884)];
	var g = new THREE.PlaneGeometry(100,100,this._base.length - 1,objects_CatBody.SEG_Z);
	if(objects_CatBody._mate == null) objects_CatBody._mate = new shaders_MaeShaderMaterial("cat/body.png");
	THREE.Mesh.call(this,g,objects_CatBody._mate);
};
objects_CatBody.__name__ = true;
objects_CatBody.__super__ = THREE.Mesh;
objects_CatBody.prototype = $extend(THREE.Mesh.prototype,{
	init: function() {
		this.geometry.verticesNeedUpdate = true;
		var depth = 1;
		var segX = this._base.length;
		var _g1 = 0;
		var _g = objects_CatBody.SEG_Z + 1;
		while(_g1 < _g) {
			var j = _g1++;
			var _g2 = 0;
			while(_g2 < segX) {
				var i = _g2++;
				var index = j * segX + i % segX;
				var vertex = this.geometry.vertices[index];
				var v = this._getPos(i,j / objects_CatBody.SEG_Z);
				var s = 1;
				vertex.x = v.x * s;
				vertex.y = -j / objects_CatBody.SEG_Z * depth;
				vertex.z = -v.y * s;
			}
		}
	}
	,updateDoubleSize: function(size) {
		this.position.y = size;
		this.scale.y = size * 2;
	}
	,updateFrontSize: function(size) {
		this.position.y = size;
		this.scale.y = size;
	}
	,update: function() {
	}
	,setStart: function(posY) {
		this.position.y = posY;
		if(posY > 0) {
			this.scale.y = posY;
			this.visible = true;
		} else this.visible = false;
	}
	,_getPos: function(i,ratio) {
		return new THREE.Vector2(this._base[i].x * (1 - ratio) + this._base2[i].x * ratio,this._base[i].y * (1 - ratio) + this._base2[i].y * ratio);
	}
	,__class__: objects_CatBody
});
var objects_LongCat = function() {
	this._rot = 0;
	this._tgtScale = 1;
	this._flag = false;
	this._freqIndex = 0;
	this._mode = 0;
	this._rad = 0;
	this._showing = true;
	this._rotSpeed = Math.random() * Math.PI / 42;
	this._limit = 600 + 200 * Math.random();
	this.index = 0;
	THREE.Object3D.call(this);
};
objects_LongCat.__name__ = true;
objects_LongCat.__super__ = THREE.Object3D;
objects_LongCat.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		this._freqIndex = Math.floor(Math.random() * 10);
		this._dataManager = data_DataManager.getInstance();
		this._container = new THREE.Object3D();
		this.add(this._container);
		this._cat = this._dataManager.cats.head.clone();
		this._container.add(this._cat);
		this._body = new objects_CatBody();
		this._body.castShadow = true;
		this._body.scale.set(100,0.001,100);
		this._body.init();
		this._body.position.y = -63.743;
		this._container.add(this._body);
		this._hip = this._dataManager.cats.hip.clone();
		this._container.add(this._hip);
		this._showing = true;
	}
	,setSize: function(size) {
		if(this._mode == 0) {
			this._cat.position.y = size + 63.743;
			this._body.updateDoubleSize(size);
			this._hip.position.y = -size;
		} else {
			this._cat.position.y = size + 63.743;
			this._body.updateFrontSize(size);
			this._hip.position.y = 0;
			var oy = 60. + size * 0.3;
			this._cat.position.y += oy;
			this._body.position.y += oy;
			this._hip.position.y += oy;
		}
		return size + 67.9 + 63.743;
	}
	,update: function(audio,rot) {
		this._rad += Math.PI / 100;
		if(audio.subFreqByteData[this._freqIndex] > 10) this._flag = !this._flag;
		if(this._flag) this._tgtScale += (1 - this._tgtScale) / 2; else this._tgtScale += (0.001 - this._tgtScale) / 2;
		this.rotation.y += (rot - this.rotation.y) / 2;
		this._container.scale.y += (this._tgtScale - this._container.scale.y) / 4;
	}
	,getPosY: function() {
		return this._cat.position.y;
	}
	,hide: function(callback) {
		if(this._showing) {
			this._showing = false;
			haxe_Timer.delay($bind(this,this._onHide),800);
		}
	}
	,setScale: function(xx,yy,zz) {
	}
	,_onHide: function() {
	}
	,__class__: objects_LongCat
});
var objects_XmasGenerator = function() {
	this._count = 0;
	THREE.Object3D.call(this);
	this._cats = new objects_cat_MidiCats();
	this.add(this._cats);
	this._mojis = new common_Mojis();
	this._mojis.init(null);
	this.add(this._mojis);
	var snow = new objects_snowman_Snowman();
	snow.init();
	this.add(snow);
	this._tree = new objects_tree_XmasTrees();
	this._tree.init();
};
objects_XmasGenerator.__name__ = true;
objects_XmasGenerator.__super__ = THREE.Object3D;
objects_XmasGenerator.prototype = $extend(THREE.Object3D.prototype,{
	reset: function(list) {
		this._count = 0;
		this._mojis.visible = false;
		this._cats.removeCats(list);
	}
	,addObject: function(d,pos) {
		Tracer.info("_count" + this._count);
		if(this._count >= 54) {
			this._mojis.position.copy(pos);
			this._mojis.position.y = 400;
			this._mojis.visible = true;
		}
		this._count++;
		this._cats.playCat(d);
	}
	,beat: function(d) {
		this._tree.beat();
	}
	,update: function() {
		if(this._cats != null) this._cats.update();
	}
	,__class__: objects_XmasGenerator
});
var objects_bg_BgShaderMat = function() {
	this._offsetRatio = 0;
	this._counter = 0;
	this.vv = "\r\n\t\tvarying vec2 vUv;// fragmentShaderに渡すためのvarying変数\r\n\t\tvarying vec3 vPos;\r\n\t\tvoid main()\r\n\t\t{\r\n\t\t  // 処理する頂点ごとのuv(テクスチャ)座標をそのままfragmentShaderに横流しする\r\n\t\t  vUv = uv;\r\n\t\t  vPos = position;\r\n\t\t  // 変換：ローカル座標 → 配置 → カメラ座標\r\n\t\t  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);    \r\n\t\t  // 変換：カメラ座標 → 画面座標\r\n\t\t  gl_Position = projectionMatrix * mvPosition;\r\n\t\t}\r\n\t";
	this._texture = null;
	THREE.ShaderMaterial.call(this,{ vertexShader : this.vv, fragmentShader : this.getFragment(), uniforms : { texture : { type : "t", value : this._texture}, counter : { type : "f", value : 0}, offsetColor : { type : "c", value : new THREE.Color(0)}}});
	this.side = 1;
	this._offsetRatio = 1;
	this.updateOffset();
};
objects_bg_BgShaderMat.__name__ = true;
objects_bg_BgShaderMat.__super__ = THREE.ShaderMaterial;
objects_bg_BgShaderMat.prototype = $extend(THREE.ShaderMaterial.prototype,{
	getFragment: function() {
		var ff0 = "\r\n//\r\n// Description : Array and textureless GLSL 2D/3D/4D simplex \r\n//               noise functions.\r\n//      Author : Ian McEwan, Ashima Arts.\r\n//  Maintainer : ijm\r\n//     Lastmod : 20110822 (ijm)\r\n//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.\r\n//               Distributed under the MIT License. See LICENSE file.\r\n//               https://github.com/ashima/webgl-noise\r\n// \r\n\r\nvec3 mod289(vec3 x) {\r\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\r\n}\r\n\r\nvec4 mod289(vec4 x) {\r\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\r\n}\r\n\r\nvec4 permute(vec4 x) {\r\n\treturn mod289(((x*34.0)+1.0)*x);\r\n}\r\n\r\nvec4 taylorInvSqrt(vec4 r){\r\n\treturn 1.79284291400159 - 0.85373472095314 * r;\r\n}\r\n\r\nfloat snoise(vec3 v) { \r\n\r\n\tconst vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\r\n\tconst vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\r\n\r\n\t// First corner\r\n\tvec3 i  = floor(v + dot(v, C.yyy) );\r\n\tvec3 x0 =   v - i + dot(i, C.xxx) ;\r\n\r\n\t// Other corners\r\n\tvec3 g = step(x0.yzx, x0.xyz);\r\n\tvec3 l = 1.0 - g;\r\n\tvec3 i1 = min( g.xyz, l.zxy );\r\n\tvec3 i2 = max( g.xyz, l.zxy );\r\n\r\n\t//   x0 = x0 - 0.0 + 0.0 * C.xxx;\r\n\t//   x1 = x0 - i1  + 1.0 * C.xxx;\r\n\t//   x2 = x0 - i2  + 2.0 * C.xxx;\r\n\t//   x3 = x0 - 1.0 + 3.0 * C.xxx;\r\n\tvec3 x1 = x0 - i1 + C.xxx;\r\n\tvec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y\r\n\tvec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y\r\n\r\n\t// Permutations\r\n\ti = mod289(i); \r\n\tvec4 p = permute( permute( permute( \r\n\t\t  i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\r\n\t\t+ i.y + vec4(0.0, i1.y, i2.y, 1.0 )) \r\n\t\t+ i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\r\n\r\n\t// Gradients: 7x7 points over a square, mapped onto an octahedron.\r\n\t// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)\r\n\tfloat n_ = 0.142857142857; // 1.0/7.0\r\n\tvec3  ns = n_ * D.wyz - D.xzx;\r\n\r\n\tvec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)\r\n\r\n\tvec4 x_ = floor(j * ns.z);\r\n\tvec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)\r\n\r\n\tvec4 x = x_ *ns.x + ns.yyyy;\r\n\tvec4 y = y_ *ns.x + ns.yyyy;\r\n\tvec4 h = 1.0 - abs(x) - abs(y);\r\n\r\n\tvec4 b0 = vec4( x.xy, y.xy );\r\n\tvec4 b1 = vec4( x.zw, y.zw );\r\n\r\n\t//vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;\r\n\t//vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;\r\n\tvec4 s0 = floor(b0)*2.0 + 1.0;\r\n\tvec4 s1 = floor(b1)*2.0 + 1.0;\r\n\tvec4 sh = -step(h, vec4(0.0));\r\n\r\n\tvec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\r\n\tvec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\r\n\r\n\tvec3 p0 = vec3(a0.xy,h.x);\r\n\tvec3 p1 = vec3(a0.zw,h.y);\r\n\tvec3 p2 = vec3(a1.xy,h.z);\r\n\tvec3 p3 = vec3(a1.zw,h.w);\r\n\r\n\t//Normalise gradients\r\n\tvec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\r\n\tp0 *= norm.x;\r\n\tp1 *= norm.y;\r\n\tp2 *= norm.z;\r\n\tp3 *= norm.w;\r\n\r\n\t// Mix final noise value\r\n\tvec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);\r\n\tm = m * m;\r\n\treturn 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );\r\n\r\n}\r\n\r\nvec3 snoiseVec3( vec3 x ){\r\n\r\n\tfloat s  = snoise(vec3( x ));\r\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\r\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\r\n\tvec3 c = vec3( s , s1 , s2 );\r\n\treturn c;\r\n\r\n}\r\n\r\nvec3 snoiseVec3Abs( vec3 x ){\r\n\r\n\tfloat s  = snoise(vec3( x ));\r\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\r\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\r\n\tvec3 c = vec3( abs(s) , abs(s1) , abs(s2) );\r\n\treturn c;\r\n\r\n}\r\n\r\n\r\nvec3 curlNoise( vec3 p ){\r\n \r\n\tconst float e = .1;\r\n\tvec3 dx = vec3( e   , 0.0 , 0.0 );\r\n\tvec3 dy = vec3( 0.0 , e   , 0.0 );\r\n\tvec3 dz = vec3( 0.0 , 0.0 , e   );\r\n\r\n\tvec3 p_x0 = snoiseVec3( p - dx );\r\n\tvec3 p_x1 = snoiseVec3( p + dx );\r\n\tvec3 p_y0 = snoiseVec3( p - dy );\r\n\tvec3 p_y1 = snoiseVec3( p + dy );\r\n\tvec3 p_z0 = snoiseVec3( p - dz );\r\n\tvec3 p_z1 = snoiseVec3( p + dz );\r\n\r\n\tfloat x = p_y1.z - p_y0.z - p_z1.y + p_z0.y;\r\n\tfloat y = p_z1.x - p_z0.x - p_x1.z + p_x0.z;\r\n\tfloat z = p_x1.y - p_x0.y - p_y1.x + p_y0.x;\r\n\r\n\tconst float divisor = 1.0 / ( 2.0 * e );\r\n\treturn normalize( vec3( x , y , z ) * divisor );\r\n\r\n}\r\n\r\nvec3 curlNoise2( vec3 p ) {\r\n\r\n\tconst float e = .1;\r\n\r\n\tvec3 xNoisePotentialDerivatives = snoiseVec3( p );\r\n\tvec3 yNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 3., -3.,  1. ) );\r\n\tvec3 zNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 2.,  4., -3. ) );\r\n\r\n\tvec3 noiseVelocity = vec3(\r\n\t\tzNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\r\n\t\txNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\r\n\t\tyNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\r\n\t);\r\n\r\n\treturn normalize( noiseVelocity );\r\n\r\n}\r\n\r\nvec4 snoiseD(vec3 v) { //returns vec4(value, dx, dy, dz)\r\n  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\r\n  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\r\n \r\n  vec3 i  = floor(v + dot(v, C.yyy) );\r\n  vec3 x0 =   v - i + dot(i, C.xxx) ;\r\n \r\n  vec3 g = step(x0.yzx, x0.xyz);\r\n  vec3 l = 1.0 - g;\r\n  vec3 i1 = min( g.xyz, l.zxy );\r\n  vec3 i2 = max( g.xyz, l.zxy );\r\n \r\n  vec3 x1 = x0 - i1 + C.xxx;\r\n  vec3 x2 = x0 - i2 + C.yyy;\r\n  vec3 x3 = x0 - D.yyy;\r\n \r\n  i = mod289(i);\r\n  vec4 p = permute( permute( permute(\r\n             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\r\n           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))\r\n           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\r\n \r\n  float n_ = 0.142857142857; // 1.0/7.0\r\n  vec3  ns = n_ * D.wyz - D.xzx;\r\n \r\n  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);\r\n \r\n  vec4 x_ = floor(j * ns.z);\r\n  vec4 y_ = floor(j - 7.0 * x_ );\r\n \r\n  vec4 x = x_ *ns.x + ns.yyyy;\r\n  vec4 y = y_ *ns.x + ns.yyyy;\r\n  vec4 h = 1.0 - abs(x) - abs(y);\r\n \r\n  vec4 b0 = vec4( x.xy, y.xy );\r\n  vec4 b1 = vec4( x.zw, y.zw );\r\n \r\n  vec4 s0 = floor(b0)*2.0 + 1.0;\r\n  vec4 s1 = floor(b1)*2.0 + 1.0;\r\n  vec4 sh = -step(h, vec4(0.0));\r\n \r\n  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\r\n  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\r\n \r\n  vec3 p0 = vec3(a0.xy,h.x);\r\n  vec3 p1 = vec3(a0.zw,h.y);\r\n  vec3 p2 = vec3(a1.xy,h.z);\r\n  vec3 p3 = vec3(a1.zw,h.w);\r\n \r\n  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\r\n  p0 *= norm.x;\r\n  p1 *= norm.y;\r\n  p2 *= norm.z;\r\n  p3 *= norm.w;\r\n \r\n  vec4 values = vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ); //value of contributions from each corner (extrapolate the gradient)\r\n \r\n  vec4 m = max(0.5 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0); //kernel function from each corner\r\n \r\n  vec4 m2 = m * m;\r\n  vec4 m3 = m * m * m;\r\n \r\n  vec4 temp = -6.0 * m2 * values;\r\n  float dx = temp[0] * x0.x + temp[1] * x1.x + temp[2] * x2.x + temp[3] * x3.x + m3[0] * p0.x + m3[1] * p1.x + m3[2] * p2.x + m3[3] * p3.x;\r\n  float dy = temp[0] * x0.y + temp[1] * x1.y + temp[2] * x2.y + temp[3] * x3.y + m3[0] * p0.y + m3[1] * p1.y + m3[2] * p2.y + m3[3] * p3.y;\r\n  float dz = temp[0] * x0.z + temp[1] * x1.z + temp[2] * x2.z + temp[3] * x3.z + m3[0] * p0.z + m3[1] * p1.z + m3[2] * p2.z + m3[3] * p3.z;\r\n \r\n  return vec4(dot(m3, values), dx, dy, dz) * 42.0;\r\n}\r\n\r\n\r\nvec3 curlNoise3 (vec3 p) {\r\n\r\n    vec3 xNoisePotentialDerivatives = snoiseD( p ).yzw; //yzw are the xyz derivatives\r\n    vec3 yNoisePotentialDerivatives = snoiseD(vec3( p.y - 19.1 , p.z + 33.4 , p.x + 47.2 )).zwy;\r\n    vec3 zNoisePotentialDerivatives = snoiseD(vec3( p.z + 74.2 , p.x - 124.5 , p.y + 99.4 )).wyz;\r\n    vec3 noiseVelocity = vec3(\r\n        zNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\r\n        xNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\r\n        yNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\r\n    );\r\n\t\r\n\tconst float e = .1;\r\n\tconst float divisor = 1.0 / ( 2.0 * e );\r\n\treturn normalize( noiseVelocity * divisor );\r\n\r\n}\r\n\t\r\n\t" + "\r\n\t\t\t//uniform 変数としてテクスチャのデータを受け取る\r\n\t\t\tuniform sampler2D texture;\r\n\t\t\tuniform float counter;\r\n\t\t\tuniform vec3 offsetColor;\r\n\t\t\t// vertexShaderで処理されて渡されるテクスチャ座標\r\n\t\t\tvarying vec2 vUv;                                             \r\n\t\t\tvarying vec3 vPos;\r\n\r\n\t\t\tvoid main()\r\n\t\t\t{\r\n\t\t\t  // テクスチャの色情報をそのままピクセルに塗る\r\n\t\t\t  vec3 col = 1.0 * snoiseVec3(vec3(vPos.x * 0.00010, vPos.y * 0.00011, vPos.z * 0.00012 + counter));\r\n\t\t\t  col.x = 2.0 * abs(col.x);\r\n\t\t\t  col.y = 2.0 * abs(col.y);\r\n\t\t\t  //col.x = 0.5 * ( col.x + 1.0 ) / 2.0 + 0.1;\r\n\t\t\t  //col.y *= 0.15;\r\n\t\t\t  //col.z *= 0.35;\r\n\r\n\t\t";
		var ff1;
		if(!data_Quality.HIGH) ff1 = ""; else ff1 = "\r\n\t\t\tcol += vec3( 0.05 * snoiseVec3(vec3(vPos.x * 0.5, vPos.y * 0.5, vPos.z * 0.5 + counter)));\r\n\t\t";
		var ff2 = "\t  \r\n\t\t\t\t//白くする用\r\n\t\t\t\t//col += offsetColor;\r\n\t\t\t\tgl_FragColor = vec4( col, 1.0 );// texture2D(texture, vUv);\r\n\t\t\t\t\r\n\t\t\t}\r\n\t\t";
		return ff0 + ff1 + ff2;
	}
	,startBlack: function(time,delay) {
		TweenMax.to(this,time,{ _offsetRatio : 0, delay : delay, onUpdate : $bind(this,this.updateOffset)});
	}
	,startWhite: function(time,delay) {
		TweenMax.to(this,time,{ _offsetRatio : 1.5, delay : delay, onUpdate : $bind(this,this.updateOffset)});
	}
	,updateOffset: function() {
		var color = this.uniforms.offsetColor.value;
		color.setRGB(this._offsetRatio,this._offsetRatio,this._offsetRatio);
		this.uniforms.offsetColor.value = color;
	}
	,update: function() {
		this.uniforms.counter.value += 0.003;
	}
	,__class__: objects_bg_BgShaderMat
});
var objects_bg_BgSphere = function() {
	var g = new THREE.SphereBufferGeometry(5000,15,15);
	Tracer.log("len = " + Std.string(g.attributes.position.length));
	var nn = g.attributes.position.length;
	var colors = new Float32Array(nn * 3);
	var _g = 0;
	while(_g < nn) {
		var i = _g++;
		colors[i * 3] = Math.random();
		colors[i * 3 + 1] = Math.random();
		colors[i * 3 + 2] = Math.random();
	}
	g.addAttribute("color",new THREE.BufferAttribute(colors,3));
	this._mat = new objects_bg_BgShaderMat();
	this._mat.fog = false;
	THREE.Mesh.call(this,g,this._mat);
};
objects_bg_BgSphere.__name__ = true;
objects_bg_BgSphere.__super__ = THREE.Mesh;
objects_bg_BgSphere.prototype = $extend(THREE.Mesh.prototype,{
	startBlack: function(time,delay) {
		this._mat.startBlack(time,delay);
	}
	,startWhite: function(time,delay) {
		this._mat.startWhite(time,delay);
	}
	,update: function() {
		this._mat.update();
	}
	,__class__: objects_bg_BgSphere
});
var objects_bg_Ground = function() {
	THREE.Mesh.call(this,new THREE.PlaneGeometry(20000,20000,10,10),new THREE.MeshLambertMaterial({ color : 16777215, emissive : 8947848}));
	this.rotation.x = -Math.PI / 2;
	this.receiveShadow = true;
};
objects_bg_Ground.__name__ = true;
objects_bg_Ground.__super__ = THREE.Mesh;
objects_bg_Ground.prototype = $extend(THREE.Mesh.prototype,{
	__class__: objects_bg_Ground
});
var objects_box_GiftBox = function() {
	THREE.Object3D.call(this);
	if(objects_box_GiftBox._mat == null) {
		objects_box_GiftBox._mat = data_DataManager.getInstance().box.mat;
		objects_box_GiftBox._geo1 = data_DataManager.getInstance().box.geos[0];
		objects_box_GiftBox._geo2 = data_DataManager.getInstance().box.geos[1];
	}
	var ss = 0.5;
	this._top = new THREE.Mesh(objects_box_GiftBox._geo1,objects_box_GiftBox._mat);
	this._top.scale.set(ss,ss,ss);
	this._top.position.y = 110 * ss;
	this._bottom = new THREE.Mesh(objects_box_GiftBox._geo2,objects_box_GiftBox._mat);
	this._bottom.scale.set(ss,ss,ss);
	this._bottom.castShadow = true;
	this.add(this._top);
	this.add(this._bottom);
};
objects_box_GiftBox.__name__ = true;
objects_box_GiftBox.__super__ = THREE.Object3D;
objects_box_GiftBox.prototype = $extend(THREE.Object3D.prototype,{
	open: function() {
		TweenMax.to(this._top.position,0.5,{ y : this._top.position.y + 300 + 200 * Math.random()});
		TweenMax.to(this._top.rotation,0.5,{ x : Math.random() * 2 * Math.PI, y : Math.random() * 2 * Math.PI, z : Math.random() * 2 * Math.PI});
	}
	,__class__: objects_box_GiftBox
});
var objects_cat_GiftBoxCat = function() {
	this._tweening = false;
	THREE.Object3D.call(this);
};
objects_cat_GiftBoxCat.__name__ = true;
objects_cat_GiftBoxCat.__super__ = THREE.Object3D;
objects_cat_GiftBoxCat.prototype = $extend(THREE.Object3D.prototype,{
	init: function(d) {
		this.data = d;
		this._box = new objects_box_GiftBox();
		this._box.position.y = 50;
		this.add(this._box);
		this._cat = new objects_LongCat();
		this._cat.init();
		this._cat.setSize(200 * Math.random());
		this._cat.rotation.x = 0.5 * Math.PI * (Math.random() - 0.5);
		this._cat.rotation.y = 0.2 * Math.PI * (Math.random() - 0.5);
		this._cat.rotation.z = 0.2 * Math.PI * (Math.random() - 0.5);
		var ss = 2 * Math.random() + 1;
		this._cat.scale.set(ss,ss,ss);
		this._cat.visible = false;
		this.add(this._cat);
	}
	,show: function() {
		this._tweening = true;
		this._cat.visible = true;
		this._box.open();
		this._cat.position.y = -500;
		TweenMax.to(this._cat.position,0.1,{ y : 0, onComplete : $bind(this,this._onShow)});
	}
	,_onShow: function() {
		this._tweening = false;
	}
	,hide: function() {
		this._cat.visible = false;
	}
	,update: function() {
		if(this._tweening) return;
		this._cat.position.y += 5;
		this._cat.rotation.y += 0.2;
	}
	,__class__: objects_cat_GiftBoxCat
});
var objects_cat_MidiCats = function() {
	this._count = 0;
	THREE.Object3D.call(this);
	this._map = new haxe_ds_StringMap();
	this._cats = [];
};
objects_cat_MidiCats.__name__ = true;
objects_cat_MidiCats.__super__ = THREE.Object3D;
objects_cat_MidiCats.prototype = $extend(THREE.Object3D.prototype,{
	initCat: function() {
	}
	,addCat: function(d,pos) {
	}
	,playCat: function(data) {
		Tracer.info("playCat " + data.id);
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(data.id == this._cats[i].data.id) this._cats[i].show();
		}
	}
	,removeCats: function(list) {
		console.log("remove");
		if(this._cats.length > 0) return;
		var _g1 = 0;
		var _g = list.length;
		while(_g1 < _g) {
			var i = _g1++;
			var data1 = list[i];
			var timeRatio = data1.time / 16.024;
			var cat = new objects_cat_GiftBoxCat();
			cat.init(data1);
			cat.position.x = (this.getX(data1) - 2.5) * 200;
			cat.position.y = 0;
			cat.position.z = timeRatio * data_Params.distance;
			this.add(cat);
			this._cats.push(cat);
		}
	}
	,getX: function(data) {
		if(this._map.get(data.name) != null) return this._map.get(data.name);
		this._count++;
		this._map.set(data.name,this._count);
		return this._count;
	}
	,update: function() {
		var _g1 = 0;
		var _g = this._cats.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._cats[i].update();
		}
	}
	,__class__: objects_cat_MidiCats
});
var objects_snowman_Snowman = function() {
	THREE.Object3D.call(this);
};
objects_snowman_Snowman.__name__ = true;
objects_snowman_Snowman.__super__ = THREE.Object3D;
objects_snowman_Snowman.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		if(objects_snowman_Snowman._geo == null) {
			objects_snowman_Snowman._geo = new THREE.Geometry();
			var g1 = new THREE.SphereGeometry(100,10,10);
			var g2 = new THREE.SphereGeometry(70,10,10);
			var m1 = new THREE.Matrix4();
			m1.makeTranslation(0,100,0);
			objects_snowman_Snowman._geo.merge(g1);
			objects_snowman_Snowman._geo.merge(g2,m1);
			objects_snowman_Snowman._mat = new THREE.MeshLambertMaterial({ color : 16777215, ambient : 16777215, emissive : 8947848});
		}
		var m = new THREE.Mesh(objects_snowman_Snowman._geo,objects_snowman_Snowman._mat);
		m.castShadow = true;
		this.add(m);
	}
	,__class__: objects_snowman_Snowman
});
var objects_tree_XmasTrees = function() {
	this._flag = false;
	this._meshes = [];
	THREE.Object3D.call(this);
};
objects_tree_XmasTrees.__name__ = true;
objects_tree_XmasTrees.__super__ = THREE.Object3D;
objects_tree_XmasTrees.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		this._mat1 = new THREE.MeshBasicMaterial({ color : 16711680});
		this._mat2 = new THREE.MeshBasicMaterial({ color : 34816});
		this._geo = new THREE.SphereGeometry(100,10,10);
		this._meshes = [];
		var _g = 0;
		while(_g < 20) {
			var i = _g++;
			var m = new THREE.Mesh(this._geo,i % 2 == 0?this._mat1:this._mat2);
			m.position.x = 2000 * (Math.random() - 0.5);
			m.position.y = 2000 * Math.random();
			m.position.z = 2000 * Math.random();
			this.add(m);
			this._meshes.push(m);
		}
	}
	,beat: function() {
		if(this._flag) {
			this._mat1.color.setHex(16711680);
			this._mat2.color.setHex(34816);
		} else {
			this._mat1.color.setHex(34816);
			this._mat2.color.setHex(16711680);
		}
		this._flag = !this._flag;
	}
	,__class__: objects_tree_XmasTrees
});
var particles_MojiGeo = function() {
	THREE.BufferGeometry.call(this);
	var num = 2000;
	var scale = 0.5;
	var geo = data_DataManager.getInstance().moji.geos[0];
	var vertexPositions = [];
	var _g1 = 0;
	var _g = geo.vertices.length;
	while(_g1 < _g) {
		var i = _g1++;
		vertexPositions.push([geo.vertices[i].x * scale,geo.vertices[i].y * scale,geo.vertices[i].z * scale]);
	}
	var normals = new Float32Array(vertexPositions.length * 3 * num);
	var vertices = new Float32Array(vertexPositions.length * 3 * num);
	var random = new Float32Array(vertexPositions.length * 3 * num);
	var color = new Float32Array(vertexPositions.length * 3 * num);
	var indices = new Uint32Array(geo.faces.length * 3 * num);
	var pointsLen = vertexPositions.length;
	var _g2 = 0;
	while(_g2 < num) {
		var j = _g2++;
		var xx = 2 * (Math.random() - 0.5);
		var yy = 2 * (Math.random() - 0.5);
		var zz = 2 * (Math.random() - 0.5);
		var rr;
		if(Math.random() < 0.5) rr = 1; else rr = 0;
		var gg;
		if(Math.random() < 0.5) gg = 1; else gg = 0;
		var bb = 0;
		var ss = 1.0;
		var _g11 = 0;
		while(_g11 < pointsLen) {
			var i1 = _g11++;
			vertices[j * (pointsLen * 3) + i1 * 3] = vertexPositions[i1][0] * ss;
			vertices[j * (pointsLen * 3) + i1 * 3 + 1] = vertexPositions[i1][1] * ss;
			vertices[j * (pointsLen * 3) + i1 * 3 + 2] = vertexPositions[i1][2] * ss;
			random[j * (pointsLen * 3) + i1 * 3] = xx;
			random[j * (pointsLen * 3) + i1 * 3 + 1] = yy;
			random[j * (pointsLen * 3) + i1 * 3 + 2] = zz;
			color[j * (pointsLen * 3) + i1 * 3] = rr;
			color[j * (pointsLen * 3) + i1 * 3 + 1] = gg;
			color[j * (pointsLen * 3) + i1 * 3 + 2] = bb;
		}
	}
	var numFace = geo.faces.length;
	var _g3 = 0;
	while(_g3 < num) {
		var j1 = _g3++;
		var _g12 = 0;
		while(_g12 < numFace) {
			var i2 = _g12++;
			indices[j1 * numFace * 3 + i2 * 3] = j1 * pointsLen + geo.faces[i2].a;
			indices[j1 * numFace * 3 + i2 * 3 + 1] = j1 * pointsLen + geo.faces[i2].b;
			indices[j1 * numFace * 3 + i2 * 3 + 2] = j1 * pointsLen + geo.faces[i2].c;
			normals[(j1 * pointsLen + geo.faces[i2].a) * 3] = geo.faces[i2].vertexNormals[0].x;
			normals[(j1 * pointsLen + geo.faces[i2].a) * 3 + 1] = geo.faces[i2].vertexNormals[0].y;
			normals[(j1 * pointsLen + geo.faces[i2].a) * 3 + 2] = geo.faces[i2].vertexNormals[0].z;
			normals[(j1 * pointsLen + geo.faces[i2].b) * 3] = geo.faces[i2].vertexNormals[1].x;
			normals[(j1 * pointsLen + geo.faces[i2].b) * 3 + 1] = geo.faces[i2].vertexNormals[1].y;
			normals[(j1 * pointsLen + geo.faces[i2].b) * 3 + 2] = geo.faces[i2].vertexNormals[1].z;
			normals[(j1 * pointsLen + geo.faces[i2].c) * 3] = geo.faces[i2].vertexNormals[2].x;
			normals[(j1 * pointsLen + geo.faces[i2].c) * 3 + 1] = geo.faces[i2].vertexNormals[2].y;
			normals[(j1 * pointsLen + geo.faces[i2].c) * 3 + 2] = geo.faces[i2].vertexNormals[2].z;
		}
	}
	Tracer.info("------vert");
	Tracer.info(vertices);
	Tracer.info("------idx");
	Tracer.info(indices);
	this.addAttribute("position",new THREE.BufferAttribute(vertices,3));
	this.addAttribute("index",new THREE.BufferAttribute(indices,1));
	this.addAttribute("normal",new THREE.BufferAttribute(normals,3));
	this.addAttribute("random",new THREE.BufferAttribute(random,3));
	this.addAttribute("color",new THREE.BufferAttribute(color,3));
};
particles_MojiGeo.__name__ = true;
particles_MojiGeo.__super__ = THREE.BufferGeometry;
particles_MojiGeo.prototype = $extend(THREE.BufferGeometry.prototype,{
	__class__: particles_MojiGeo
});
var particles_PaperParticle = function() {
	THREE.Object3D.call(this);
	var geometry = new THREE.Geometry();
	var size = 8000;
	var _g = 0;
	while(_g < 1000) {
		var i = _g++;
		var x = (Math.random() - 0.5) * size;
		var y = (Math.random() - 0.5) * size;
		var z = (Math.random() - 0.5) * size;
		geometry.vertices.push(new THREE.Vector3(x,y,z));
	}
	var material = new THREE.PointsMaterial({ color : 16777215, size : 10});
	var points = new THREE.Points(geometry,material);
	this.add(points);
	points.position.z = data_Params.distance / 2;
	points.frustumCulled = false;
};
particles_PaperParticle.__name__ = true;
particles_PaperParticle.__super__ = THREE.Object3D;
particles_PaperParticle.prototype = $extend(THREE.Object3D.prototype,{
	__class__: particles_PaperParticle
});
var particles_PaperParticles = function() {
	THREE.Object3D.call(this);
};
particles_PaperParticles.__name__ = true;
particles_PaperParticles.__super__ = THREE.Object3D;
particles_PaperParticles.prototype = $extend(THREE.Object3D.prototype,{
	init: function() {
		var geo = new particles_MojiGeo();
		this._mat = new particles_PaperParticlesMat();
		var m = new THREE.Mesh(geo,this._mat);
		this.add(m);
		m.frustumCulled = false;
		this.frustumCulled = false;
	}
	,update: function() {
		this._mat.update();
	}
	,__class__: particles_PaperParticles
});
var particles_PaperParticlesGeo = function() {
	THREE.BufferGeometry.call(this);
	var num = 10000;
	var s = 10;
	var vertexPositions = [[-1. * s,-1. * s,0.0 * s],[s,-1. * s,0.0 * s],[s,s,0.0 * s],[-1. * s,s,0.0 * s]];
	var normals = new Float32Array(vertexPositions.length * 3 * num);
	var vertices = new Float32Array(vertexPositions.length * 3 * num);
	var random = new Float32Array(vertexPositions.length * 3 * num);
	var color = new Float32Array(vertexPositions.length * 3 * num);
	var indices = new Uint32Array(6 * num);
	var _g = 0;
	while(_g < num) {
		var j = _g++;
		var pointsLen = 4;
		var xx = 2 * (Math.random() - 0.5);
		var yy = 2 * (Math.random() - 0.5);
		var zz = 2 * (Math.random() - 0.5);
		var rr;
		if(Math.random() < 0.5) rr = 1; else rr = 0;
		var gg;
		if(Math.random() < 0.5) gg = 1; else gg = 0;
		var bb = 0;
		var ss = 0.8 + 0.4 * Math.random();
		var _g1 = 0;
		while(_g1 < pointsLen) {
			var i = _g1++;
			vertices[j * (pointsLen * 3) + i * 3] = vertexPositions[i][0] * ss;
			vertices[j * (pointsLen * 3) + i * 3 + 1] = vertexPositions[i][1] * ss;
			vertices[j * (pointsLen * 3) + i * 3 + 2] = vertexPositions[i][2] * ss;
			random[j * (pointsLen * 3) + i * 3] = xx;
			random[j * (pointsLen * 3) + i * 3 + 1] = yy;
			random[j * (pointsLen * 3) + i * 3 + 2] = zz;
			color[j * (pointsLen * 3) + i * 3] = rr;
			color[j * (pointsLen * 3) + i * 3 + 1] = gg;
			color[j * (pointsLen * 3) + i * 3 + 2] = bb;
		}
		var _g2 = 0;
		var _g11 = vertexPositions.length;
		while(_g2 < _g11) {
			var i1 = _g2++;
			normals[j * (pointsLen * 3) + i1 * 3] = 0;
			normals[j * (pointsLen * 3) + i1 * 3 + 1] = 0;
			normals[j * (pointsLen * 3) + i1 * 3 + 2] = -1;
		}
		var indexOffset = j * 4;
		indices[j * 6] = indexOffset | 0;
		indices[j * 6 + 1] = indexOffset + 1 | 0;
		indices[j * 6 + 2] = indexOffset + 2 | 0;
		indices[j * 6 + 3] = indexOffset + 2 | 0;
		indices[j * 6 + 4] = indexOffset + 3 | 0;
		indices[j * 6 + 5] = indexOffset | 0;
	}
	window.alert("num " + vertices.length);
	this.addAttribute("position",new THREE.BufferAttribute(vertices,3));
	this.addAttribute("index",new THREE.BufferAttribute(indices,1));
	this.addAttribute("normal",new THREE.BufferAttribute(normals,3));
	this.addAttribute("random",new THREE.BufferAttribute(random,3));
	this.addAttribute("color",new THREE.BufferAttribute(color,3));
};
particles_PaperParticlesGeo.__name__ = true;
particles_PaperParticlesGeo.__super__ = THREE.BufferGeometry;
particles_PaperParticlesGeo.prototype = $extend(THREE.BufferGeometry.prototype,{
	__class__: particles_PaperParticlesGeo
});
var particles_PaperParticlesMat = function() {
	this._speed = 0;
	this.ff = "\r\n//\r\n// Description : Array and textureless GLSL 2D/3D/4D simplex \r\n//               noise functions.\r\n//      Author : Ian McEwan, Ashima Arts.\r\n//  Maintainer : ijm\r\n//     Lastmod : 20110822 (ijm)\r\n//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.\r\n//               Distributed under the MIT License. See LICENSE file.\r\n//               https://github.com/ashima/webgl-noise\r\n// \r\n\r\nvec3 mod289(vec3 x) {\r\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\r\n}\r\n\r\nvec4 mod289(vec4 x) {\r\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\r\n}\r\n\r\nvec4 permute(vec4 x) {\r\n\treturn mod289(((x*34.0)+1.0)*x);\r\n}\r\n\r\nvec4 taylorInvSqrt(vec4 r){\r\n\treturn 1.79284291400159 - 0.85373472095314 * r;\r\n}\r\n\r\nfloat snoise(vec3 v) { \r\n\r\n\tconst vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\r\n\tconst vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\r\n\r\n\t// First corner\r\n\tvec3 i  = floor(v + dot(v, C.yyy) );\r\n\tvec3 x0 =   v - i + dot(i, C.xxx) ;\r\n\r\n\t// Other corners\r\n\tvec3 g = step(x0.yzx, x0.xyz);\r\n\tvec3 l = 1.0 - g;\r\n\tvec3 i1 = min( g.xyz, l.zxy );\r\n\tvec3 i2 = max( g.xyz, l.zxy );\r\n\r\n\t//   x0 = x0 - 0.0 + 0.0 * C.xxx;\r\n\t//   x1 = x0 - i1  + 1.0 * C.xxx;\r\n\t//   x2 = x0 - i2  + 2.0 * C.xxx;\r\n\t//   x3 = x0 - 1.0 + 3.0 * C.xxx;\r\n\tvec3 x1 = x0 - i1 + C.xxx;\r\n\tvec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y\r\n\tvec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y\r\n\r\n\t// Permutations\r\n\ti = mod289(i); \r\n\tvec4 p = permute( permute( permute( \r\n\t\t  i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\r\n\t\t+ i.y + vec4(0.0, i1.y, i2.y, 1.0 )) \r\n\t\t+ i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\r\n\r\n\t// Gradients: 7x7 points over a square, mapped onto an octahedron.\r\n\t// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)\r\n\tfloat n_ = 0.142857142857; // 1.0/7.0\r\n\tvec3  ns = n_ * D.wyz - D.xzx;\r\n\r\n\tvec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)\r\n\r\n\tvec4 x_ = floor(j * ns.z);\r\n\tvec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)\r\n\r\n\tvec4 x = x_ *ns.x + ns.yyyy;\r\n\tvec4 y = y_ *ns.x + ns.yyyy;\r\n\tvec4 h = 1.0 - abs(x) - abs(y);\r\n\r\n\tvec4 b0 = vec4( x.xy, y.xy );\r\n\tvec4 b1 = vec4( x.zw, y.zw );\r\n\r\n\t//vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;\r\n\t//vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;\r\n\tvec4 s0 = floor(b0)*2.0 + 1.0;\r\n\tvec4 s1 = floor(b1)*2.0 + 1.0;\r\n\tvec4 sh = -step(h, vec4(0.0));\r\n\r\n\tvec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\r\n\tvec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\r\n\r\n\tvec3 p0 = vec3(a0.xy,h.x);\r\n\tvec3 p1 = vec3(a0.zw,h.y);\r\n\tvec3 p2 = vec3(a1.xy,h.z);\r\n\tvec3 p3 = vec3(a1.zw,h.w);\r\n\r\n\t//Normalise gradients\r\n\tvec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\r\n\tp0 *= norm.x;\r\n\tp1 *= norm.y;\r\n\tp2 *= norm.z;\r\n\tp3 *= norm.w;\r\n\r\n\t// Mix final noise value\r\n\tvec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);\r\n\tm = m * m;\r\n\treturn 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );\r\n\r\n}\r\n\r\nvec3 snoiseVec3( vec3 x ){\r\n\r\n\tfloat s  = snoise(vec3( x ));\r\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\r\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\r\n\tvec3 c = vec3( s , s1 , s2 );\r\n\treturn c;\r\n\r\n}\r\n\r\nvec3 snoiseVec3Abs( vec3 x ){\r\n\r\n\tfloat s  = snoise(vec3( x ));\r\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\r\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\r\n\tvec3 c = vec3( abs(s) , abs(s1) , abs(s2) );\r\n\treturn c;\r\n\r\n}\r\n\r\n\r\nvec3 curlNoise( vec3 p ){\r\n \r\n\tconst float e = .1;\r\n\tvec3 dx = vec3( e   , 0.0 , 0.0 );\r\n\tvec3 dy = vec3( 0.0 , e   , 0.0 );\r\n\tvec3 dz = vec3( 0.0 , 0.0 , e   );\r\n\r\n\tvec3 p_x0 = snoiseVec3( p - dx );\r\n\tvec3 p_x1 = snoiseVec3( p + dx );\r\n\tvec3 p_y0 = snoiseVec3( p - dy );\r\n\tvec3 p_y1 = snoiseVec3( p + dy );\r\n\tvec3 p_z0 = snoiseVec3( p - dz );\r\n\tvec3 p_z1 = snoiseVec3( p + dz );\r\n\r\n\tfloat x = p_y1.z - p_y0.z - p_z1.y + p_z0.y;\r\n\tfloat y = p_z1.x - p_z0.x - p_x1.z + p_x0.z;\r\n\tfloat z = p_x1.y - p_x0.y - p_y1.x + p_y0.x;\r\n\r\n\tconst float divisor = 1.0 / ( 2.0 * e );\r\n\treturn normalize( vec3( x , y , z ) * divisor );\r\n\r\n}\r\n\r\nvec3 curlNoise2( vec3 p ) {\r\n\r\n\tconst float e = .1;\r\n\r\n\tvec3 xNoisePotentialDerivatives = snoiseVec3( p );\r\n\tvec3 yNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 3., -3.,  1. ) );\r\n\tvec3 zNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 2.,  4., -3. ) );\r\n\r\n\tvec3 noiseVelocity = vec3(\r\n\t\tzNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\r\n\t\txNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\r\n\t\tyNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\r\n\t);\r\n\r\n\treturn normalize( noiseVelocity );\r\n\r\n}\r\n\r\nvec4 snoiseD(vec3 v) { //returns vec4(value, dx, dy, dz)\r\n  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\r\n  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\r\n \r\n  vec3 i  = floor(v + dot(v, C.yyy) );\r\n  vec3 x0 =   v - i + dot(i, C.xxx) ;\r\n \r\n  vec3 g = step(x0.yzx, x0.xyz);\r\n  vec3 l = 1.0 - g;\r\n  vec3 i1 = min( g.xyz, l.zxy );\r\n  vec3 i2 = max( g.xyz, l.zxy );\r\n \r\n  vec3 x1 = x0 - i1 + C.xxx;\r\n  vec3 x2 = x0 - i2 + C.yyy;\r\n  vec3 x3 = x0 - D.yyy;\r\n \r\n  i = mod289(i);\r\n  vec4 p = permute( permute( permute(\r\n             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\r\n           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))\r\n           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\r\n \r\n  float n_ = 0.142857142857; // 1.0/7.0\r\n  vec3  ns = n_ * D.wyz - D.xzx;\r\n \r\n  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);\r\n \r\n  vec4 x_ = floor(j * ns.z);\r\n  vec4 y_ = floor(j - 7.0 * x_ );\r\n \r\n  vec4 x = x_ *ns.x + ns.yyyy;\r\n  vec4 y = y_ *ns.x + ns.yyyy;\r\n  vec4 h = 1.0 - abs(x) - abs(y);\r\n \r\n  vec4 b0 = vec4( x.xy, y.xy );\r\n  vec4 b1 = vec4( x.zw, y.zw );\r\n \r\n  vec4 s0 = floor(b0)*2.0 + 1.0;\r\n  vec4 s1 = floor(b1)*2.0 + 1.0;\r\n  vec4 sh = -step(h, vec4(0.0));\r\n \r\n  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\r\n  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\r\n \r\n  vec3 p0 = vec3(a0.xy,h.x);\r\n  vec3 p1 = vec3(a0.zw,h.y);\r\n  vec3 p2 = vec3(a1.xy,h.z);\r\n  vec3 p3 = vec3(a1.zw,h.w);\r\n \r\n  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\r\n  p0 *= norm.x;\r\n  p1 *= norm.y;\r\n  p2 *= norm.z;\r\n  p3 *= norm.w;\r\n \r\n  vec4 values = vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ); //value of contributions from each corner (extrapolate the gradient)\r\n \r\n  vec4 m = max(0.5 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0); //kernel function from each corner\r\n \r\n  vec4 m2 = m * m;\r\n  vec4 m3 = m * m * m;\r\n \r\n  vec4 temp = -6.0 * m2 * values;\r\n  float dx = temp[0] * x0.x + temp[1] * x1.x + temp[2] * x2.x + temp[3] * x3.x + m3[0] * p0.x + m3[1] * p1.x + m3[2] * p2.x + m3[3] * p3.x;\r\n  float dy = temp[0] * x0.y + temp[1] * x1.y + temp[2] * x2.y + temp[3] * x3.y + m3[0] * p0.y + m3[1] * p1.y + m3[2] * p2.y + m3[3] * p3.y;\r\n  float dz = temp[0] * x0.z + temp[1] * x1.z + temp[2] * x2.z + temp[3] * x3.z + m3[0] * p0.z + m3[1] * p1.z + m3[2] * p2.z + m3[3] * p3.z;\r\n \r\n  return vec4(dot(m3, values), dx, dy, dz) * 42.0;\r\n}\r\n\r\n\r\nvec3 curlNoise3 (vec3 p) {\r\n\r\n    vec3 xNoisePotentialDerivatives = snoiseD( p ).yzw; //yzw are the xyz derivatives\r\n    vec3 yNoisePotentialDerivatives = snoiseD(vec3( p.y - 19.1 , p.z + 33.4 , p.x + 47.2 )).zwy;\r\n    vec3 zNoisePotentialDerivatives = snoiseD(vec3( p.z + 74.2 , p.x - 124.5 , p.y + 99.4 )).wyz;\r\n    vec3 noiseVelocity = vec3(\r\n        zNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\r\n        xNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\r\n        yNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\r\n    );\r\n\t\r\n\tconst float e = .1;\r\n\tconst float divisor = 1.0 / ( 2.0 * e );\r\n\treturn normalize( noiseVelocity * divisor );\r\n\r\n}\r\n\t\r\n\t" + "\r\n\t\t//uniform 変数としてテクスチャのデータを受け取る\r\n\t\t//uniform sampler2D texture;\r\n\t\tuniform float counter;\r\n\t\t// vertexShaderで処理されて渡されるテクスチャ座標\r\n\t\tvarying vec2 vUv;                                             \r\n\t\tvarying vec3 vNormal; \r\n\t\tvarying vec3 vColor;\r\n\t\t\r\n\t\tvoid main()\r\n\t\t{\r\n\t\t\tvec3 lightPosition1 = vec3(0, 0, -1.0);\r\n\t\t\t\r\n\t\t\tvec4 viewLightPosition1 = viewMatrix * vec4( lightPosition1, 0.0 );\t\t\t\r\n\t\t\t\r\n\t\t\tvec3 normal = vNormal;\r\n\t\t\t\r\n\t\t\t#ifdef DOUBLE_SIDED\r\n\t\t\t\tnormal = normal * ( float( gl_FrontFacing ) * 2.0 - 1.0 );\t\r\n\t\t\t#endif\r\n\t\t\t\r\n\t\t\tvec3 N = normalize(normal);\r\n\t\t\tvec3 L1 = normalize(viewLightPosition1.xyz);\r\n\t\t\t\r\n\t\t\tfloat dotNL1 = dot(N, L1);\r\n\t\t\t//vec3 diffuse1 = abs(vColor * dotNL1);// + vColor * dotNL2;\r\n\t\t\tvec3 diffuse1 = (vColor * dotNL1);// + vColor * dotNL2;\r\n\t\t\t\r\n\t\t\t\r\n\t\t\t// テクスチャの色情報をそのままピクセルに塗る\r\n\t\t\tgl_FragColor = vec4(diffuse1, 1.0);// texture2D(texture, vUv);\r\n\t\t\t//gl_FragColor = vec4(vec3(1.0,0,0), 1.0);// texture2D(texture, vUv);\r\n\t\t  \r\n\t\t}\t\r\n\t";
	this.vv = "\r\n//\r\n// Description : Array and textureless GLSL 2D/3D/4D simplex \r\n//               noise functions.\r\n//      Author : Ian McEwan, Ashima Arts.\r\n//  Maintainer : ijm\r\n//     Lastmod : 20110822 (ijm)\r\n//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.\r\n//               Distributed under the MIT License. See LICENSE file.\r\n//               https://github.com/ashima/webgl-noise\r\n// \r\n\r\nvec3 mod289(vec3 x) {\r\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\r\n}\r\n\r\nvec4 mod289(vec4 x) {\r\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\r\n}\r\n\r\nvec4 permute(vec4 x) {\r\n\treturn mod289(((x*34.0)+1.0)*x);\r\n}\r\n\r\nvec4 taylorInvSqrt(vec4 r){\r\n\treturn 1.79284291400159 - 0.85373472095314 * r;\r\n}\r\n\r\nfloat snoise(vec3 v) { \r\n\r\n\tconst vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\r\n\tconst vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\r\n\r\n\t// First corner\r\n\tvec3 i  = floor(v + dot(v, C.yyy) );\r\n\tvec3 x0 =   v - i + dot(i, C.xxx) ;\r\n\r\n\t// Other corners\r\n\tvec3 g = step(x0.yzx, x0.xyz);\r\n\tvec3 l = 1.0 - g;\r\n\tvec3 i1 = min( g.xyz, l.zxy );\r\n\tvec3 i2 = max( g.xyz, l.zxy );\r\n\r\n\t//   x0 = x0 - 0.0 + 0.0 * C.xxx;\r\n\t//   x1 = x0 - i1  + 1.0 * C.xxx;\r\n\t//   x2 = x0 - i2  + 2.0 * C.xxx;\r\n\t//   x3 = x0 - 1.0 + 3.0 * C.xxx;\r\n\tvec3 x1 = x0 - i1 + C.xxx;\r\n\tvec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y\r\n\tvec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y\r\n\r\n\t// Permutations\r\n\ti = mod289(i); \r\n\tvec4 p = permute( permute( permute( \r\n\t\t  i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\r\n\t\t+ i.y + vec4(0.0, i1.y, i2.y, 1.0 )) \r\n\t\t+ i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\r\n\r\n\t// Gradients: 7x7 points over a square, mapped onto an octahedron.\r\n\t// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)\r\n\tfloat n_ = 0.142857142857; // 1.0/7.0\r\n\tvec3  ns = n_ * D.wyz - D.xzx;\r\n\r\n\tvec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)\r\n\r\n\tvec4 x_ = floor(j * ns.z);\r\n\tvec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)\r\n\r\n\tvec4 x = x_ *ns.x + ns.yyyy;\r\n\tvec4 y = y_ *ns.x + ns.yyyy;\r\n\tvec4 h = 1.0 - abs(x) - abs(y);\r\n\r\n\tvec4 b0 = vec4( x.xy, y.xy );\r\n\tvec4 b1 = vec4( x.zw, y.zw );\r\n\r\n\t//vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;\r\n\t//vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;\r\n\tvec4 s0 = floor(b0)*2.0 + 1.0;\r\n\tvec4 s1 = floor(b1)*2.0 + 1.0;\r\n\tvec4 sh = -step(h, vec4(0.0));\r\n\r\n\tvec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\r\n\tvec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\r\n\r\n\tvec3 p0 = vec3(a0.xy,h.x);\r\n\tvec3 p1 = vec3(a0.zw,h.y);\r\n\tvec3 p2 = vec3(a1.xy,h.z);\r\n\tvec3 p3 = vec3(a1.zw,h.w);\r\n\r\n\t//Normalise gradients\r\n\tvec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\r\n\tp0 *= norm.x;\r\n\tp1 *= norm.y;\r\n\tp2 *= norm.z;\r\n\tp3 *= norm.w;\r\n\r\n\t// Mix final noise value\r\n\tvec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);\r\n\tm = m * m;\r\n\treturn 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );\r\n\r\n}\r\n\r\nvec3 snoiseVec3( vec3 x ){\r\n\r\n\tfloat s  = snoise(vec3( x ));\r\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\r\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\r\n\tvec3 c = vec3( s , s1 , s2 );\r\n\treturn c;\r\n\r\n}\r\n\r\nvec3 snoiseVec3Abs( vec3 x ){\r\n\r\n\tfloat s  = snoise(vec3( x ));\r\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\r\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\r\n\tvec3 c = vec3( abs(s) , abs(s1) , abs(s2) );\r\n\treturn c;\r\n\r\n}\r\n\r\n\r\nvec3 curlNoise( vec3 p ){\r\n \r\n\tconst float e = .1;\r\n\tvec3 dx = vec3( e   , 0.0 , 0.0 );\r\n\tvec3 dy = vec3( 0.0 , e   , 0.0 );\r\n\tvec3 dz = vec3( 0.0 , 0.0 , e   );\r\n\r\n\tvec3 p_x0 = snoiseVec3( p - dx );\r\n\tvec3 p_x1 = snoiseVec3( p + dx );\r\n\tvec3 p_y0 = snoiseVec3( p - dy );\r\n\tvec3 p_y1 = snoiseVec3( p + dy );\r\n\tvec3 p_z0 = snoiseVec3( p - dz );\r\n\tvec3 p_z1 = snoiseVec3( p + dz );\r\n\r\n\tfloat x = p_y1.z - p_y0.z - p_z1.y + p_z0.y;\r\n\tfloat y = p_z1.x - p_z0.x - p_x1.z + p_x0.z;\r\n\tfloat z = p_x1.y - p_x0.y - p_y1.x + p_y0.x;\r\n\r\n\tconst float divisor = 1.0 / ( 2.0 * e );\r\n\treturn normalize( vec3( x , y , z ) * divisor );\r\n\r\n}\r\n\r\nvec3 curlNoise2( vec3 p ) {\r\n\r\n\tconst float e = .1;\r\n\r\n\tvec3 xNoisePotentialDerivatives = snoiseVec3( p );\r\n\tvec3 yNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 3., -3.,  1. ) );\r\n\tvec3 zNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 2.,  4., -3. ) );\r\n\r\n\tvec3 noiseVelocity = vec3(\r\n\t\tzNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\r\n\t\txNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\r\n\t\tyNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\r\n\t);\r\n\r\n\treturn normalize( noiseVelocity );\r\n\r\n}\r\n\r\nvec4 snoiseD(vec3 v) { //returns vec4(value, dx, dy, dz)\r\n  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\r\n  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\r\n \r\n  vec3 i  = floor(v + dot(v, C.yyy) );\r\n  vec3 x0 =   v - i + dot(i, C.xxx) ;\r\n \r\n  vec3 g = step(x0.yzx, x0.xyz);\r\n  vec3 l = 1.0 - g;\r\n  vec3 i1 = min( g.xyz, l.zxy );\r\n  vec3 i2 = max( g.xyz, l.zxy );\r\n \r\n  vec3 x1 = x0 - i1 + C.xxx;\r\n  vec3 x2 = x0 - i2 + C.yyy;\r\n  vec3 x3 = x0 - D.yyy;\r\n \r\n  i = mod289(i);\r\n  vec4 p = permute( permute( permute(\r\n             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\r\n           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))\r\n           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\r\n \r\n  float n_ = 0.142857142857; // 1.0/7.0\r\n  vec3  ns = n_ * D.wyz - D.xzx;\r\n \r\n  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);\r\n \r\n  vec4 x_ = floor(j * ns.z);\r\n  vec4 y_ = floor(j - 7.0 * x_ );\r\n \r\n  vec4 x = x_ *ns.x + ns.yyyy;\r\n  vec4 y = y_ *ns.x + ns.yyyy;\r\n  vec4 h = 1.0 - abs(x) - abs(y);\r\n \r\n  vec4 b0 = vec4( x.xy, y.xy );\r\n  vec4 b1 = vec4( x.zw, y.zw );\r\n \r\n  vec4 s0 = floor(b0)*2.0 + 1.0;\r\n  vec4 s1 = floor(b1)*2.0 + 1.0;\r\n  vec4 sh = -step(h, vec4(0.0));\r\n \r\n  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\r\n  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\r\n \r\n  vec3 p0 = vec3(a0.xy,h.x);\r\n  vec3 p1 = vec3(a0.zw,h.y);\r\n  vec3 p2 = vec3(a1.xy,h.z);\r\n  vec3 p3 = vec3(a1.zw,h.w);\r\n \r\n  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\r\n  p0 *= norm.x;\r\n  p1 *= norm.y;\r\n  p2 *= norm.z;\r\n  p3 *= norm.w;\r\n \r\n  vec4 values = vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ); //value of contributions from each corner (extrapolate the gradient)\r\n \r\n  vec4 m = max(0.5 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0); //kernel function from each corner\r\n \r\n  vec4 m2 = m * m;\r\n  vec4 m3 = m * m * m;\r\n \r\n  vec4 temp = -6.0 * m2 * values;\r\n  float dx = temp[0] * x0.x + temp[1] * x1.x + temp[2] * x2.x + temp[3] * x3.x + m3[0] * p0.x + m3[1] * p1.x + m3[2] * p2.x + m3[3] * p3.x;\r\n  float dy = temp[0] * x0.y + temp[1] * x1.y + temp[2] * x2.y + temp[3] * x3.y + m3[0] * p0.y + m3[1] * p1.y + m3[2] * p2.y + m3[3] * p3.y;\r\n  float dz = temp[0] * x0.z + temp[1] * x1.z + temp[2] * x2.z + temp[3] * x3.z + m3[0] * p0.z + m3[1] * p1.z + m3[2] * p2.z + m3[3] * p3.z;\r\n \r\n  return vec4(dot(m3, values), dx, dy, dz) * 42.0;\r\n}\r\n\r\n\r\nvec3 curlNoise3 (vec3 p) {\r\n\r\n    vec3 xNoisePotentialDerivatives = snoiseD( p ).yzw; //yzw are the xyz derivatives\r\n    vec3 yNoisePotentialDerivatives = snoiseD(vec3( p.y - 19.1 , p.z + 33.4 , p.x + 47.2 )).zwy;\r\n    vec3 zNoisePotentialDerivatives = snoiseD(vec3( p.z + 74.2 , p.x - 124.5 , p.y + 99.4 )).wyz;\r\n    vec3 noiseVelocity = vec3(\r\n        zNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\r\n        xNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\r\n        yNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\r\n    );\r\n\t\r\n\tconst float e = .1;\r\n\tconst float divisor = 1.0 / ( 2.0 * e );\r\n\treturn normalize( noiseVelocity * divisor );\r\n\r\n}\r\n\t\r\n\t" + "\r\n\t\tvarying vec2 vUv;// fragmentShaderに渡すためのvarying変数\r\n\t\tvarying vec3 vNormal;\r\n\t\tvarying vec3 vColor;\r\n\t\tattribute vec3 color; // 頂点カラー\r\n\t\tattribute vec3 random;\r\n\t\tuniform float counter;\r\n\t\t\r\n\t\tvec3 rotateVec3(vec3 p, float angle, vec3 axis){\r\n\t\t  vec3 a = normalize(axis);\r\n\t\t  float s = sin(angle);\r\n\t\t  float c = cos(angle);\r\n\t\t  float r = 1.0 - c;\r\n\t\t  mat3 m = mat3(\r\n\t\t\ta.x * a.x * r + c,\r\n\t\t\ta.y * a.x * r + a.z * s,\r\n\t\t\ta.z * a.x * r - a.y * s,\r\n\t\t\ta.x * a.y * r - a.z * s,\r\n\t\t\ta.y * a.y * r + c,\r\n\t\t\ta.z * a.y * r + a.x * s,\r\n\t\t\ta.x * a.z * r + a.y * s,\r\n\t\t\ta.y * a.z * r - a.x * s,\r\n\t\t\ta.z * a.z * r + c\r\n\t\t  );\r\n\t\t  return m * p;\r\n\t\t}\r\n\t\t\r\n\t\t//音楽 NAKAMURA\r\n\t\t//映像 Kitasenju Design\r\n\t\t//尊敬 Nyan Cat\r\n\t\t\r\n\t\tvoid main()\r\n\t\t{\r\n\t\t\t\r\n\t\t\tfloat size = 4000.0;\r\n\t\t\tfloat fall = 1000.0;\r\n\t\t\t//pos.z += radius;\r\n\t\t\t//vec3 pos = rotateVec3(position, counter, vec3(0.0, 1.0, 0.0)) + random * 300.0;\t\t\r\n\t\t\t//vec3 pos = rotateVec3( position, counter+random.x*100.0, normalize(random) ) + random * size;\t\t\r\n\t\t\tvec3 pos = rotateVec3( position, counter + random.x * 100.0, normalize(random) ) + random * size;\t\r\n\t\t\t\r\n\t\t\t//1000下がる\r\n\t\t\tfloat d = mod( abs(random.y)*fall + counter * (10.0+10.0*abs(random.x)), fall );\r\n\t\t\t\r\n\t\t\tpos.x = pos.x + (50.0+100.0*random.z) * sin( counter * random.x * 0.3 + random.y * 6.28 );\r\n\t\t\tpos.y = pos.y - d;\r\n\t\t\tpos.z = pos.z + (50.0+100.0*random.x) * sin( counter * random.y * 0.3 + random.z * 6.28 );\r\n\t\t\t\r\n\t\t\t\r\n\t\t\tvec3 nn\t= rotateVec3(normal, counter+random.x*100.0, normalize(random) );\r\n\t\t\t\r\n\t\t\tvColor = color;\r\n\t\t\tvNormal = normalMatrix * nn;\r\n\t\t\t\r\n\t\t\t// 処理する頂点ごとのuv(テクスチャ)座標をそのままfragmentShaderに横流しする\r\n\t\t  vUv = uv;\r\n\t\t\t// 変換：ローカル座標 → 配置 → カメラ座標\r\n\t\t  vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);    \r\n\t\t\t// 変換：カメラ座標 → 画面座標\r\n\t\t  gl_Position = projectionMatrix * mvPosition;\r\n\t\t}\r\n\t";
	THREE.ShaderMaterial.call(this,{ vertexShader : this.vv, fragmentShader : this.ff, uniforms : { map : { type : "t", value : null}, counter : { type : "f", value : 0}}});
	this.side = 2;
	common_Dat.gui.add(this.uniforms.counter,"value",0,10);
	sound_MyAudio.a.addEventListener("noteon",$bind(this,this._onNote));
};
particles_PaperParticlesMat.__name__ = true;
particles_PaperParticlesMat.__super__ = THREE.ShaderMaterial;
particles_PaperParticlesMat.prototype = $extend(THREE.ShaderMaterial.prototype,{
	_onNote: function(e) {
		var n = e.data;
		if(n.type == "BEAT") {
			if(n.name == "C2") if(this._speed == 0.2) this._speed = 0.05; else this._speed = 0.2;
		}
	}
	,update: function() {
		this.uniforms.counter.value += this._speed;
	}
	,__class__: particles_PaperParticlesMat
});
var shaders_MaeShaderMaterial = function(uri) {
	this.ff = "\r\n\t\t//uniform 変数としてテクスチャのデータを受け取る\r\n\t\tuniform sampler2D map;\r\n\t\tuniform float counter;\r\n\t\t// vertexShaderで処理されて渡されるテクスチャ座標\r\n\t\tvarying vec2 vUv;                                             \r\n\t\tvarying vec4 vPos;\r\n\r\n\t\tvoid main()\r\n\t\t{\r\n\r\n\t\t\tif (vPos.y < 0.0) discard;\r\n\t\t\t\r\n\t\t  // テクスチャの色情報をそのままピクセルに塗る\r\n\t\t  gl_FragColor = texture2D(map, vUv);\r\n\t\t}\t\r\n\t";
	this.vv = "\r\n\t\tvarying vec2 vUv;// fragmentShaderに渡すためのvarying変数\r\n\t\tvarying vec4 vPos;\r\n\t\t\r\n\t\tvoid main()\r\n\t\t{\r\n\t\t  // 処理する頂点ごとのuv(テクスチャ)座標をそのままfragmentShaderに横流しする\r\n\t\t  vUv = uv;\r\n\t\t  // 変換：ローカル座標 → 配置 → カメラ座標\r\n\t\t  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);    \r\n\t\t  \r\n\t\t  //world座標\r\n\t\t  \r\n\t\t  // 変換：カメラ座標 → 画面座標\r\n\t\t\tvPos = modelMatrix * vec4(position, 1.0);\r\n\t\t \r\n\t\t  gl_Position = projectionMatrix * mvPosition;\r\n\t\t}\r\n\t";
	this._texture1 = THREE.ImageUtils.loadTexture(uri);
	THREE.ShaderMaterial.call(this,{ vertexShader : this.vv, fragmentShader : this.ff, uniforms : { map : { type : "t", value : this._texture1}}});
	this.side = 2;
};
shaders_MaeShaderMaterial.__name__ = true;
shaders_MaeShaderMaterial.__super__ = THREE.ShaderMaterial;
shaders_MaeShaderMaterial.prototype = $extend(THREE.ShaderMaterial.prototype,{
	update: function() {
		this.uniforms.counter.value += 0.01;
	}
	,__class__: shaders_MaeShaderMaterial
});
var shaders_SimplexNoise = function() {
};
shaders_SimplexNoise.__name__ = true;
shaders_SimplexNoise.prototype = {
	__class__: shaders_SimplexNoise
};
var sound_MidiJsonLoader = function() {
};
sound_MidiJsonLoader.__name__ = true;
sound_MidiJsonLoader.prototype = {
	load: function(uri,type,callback) {
		this._callback = callback;
		this._type = type;
		this._http = new haxe_Http(uri);
		this._http.onData = $bind(this,this._onData);
		this._http.request();
	}
	,_onData: function(str) {
		var d = JSON.parse(str);
		console.log(d);
		this.noteList = [];
		var idx = 0;
		var _g1 = 0;
		var _g = d.tracks.length;
		while(_g1 < _g) {
			var j = _g1++;
			var notes = d.tracks[j].notes;
			var _g3 = 0;
			var _g2 = notes.length;
			while(_g3 < _g2) {
				var i = _g3++;
				var data1 = new data_NoteonData(notes[i],this._type,idx);
				this.noteList.push(data1);
				idx++;
			}
		}
		if(this._callback != null) this._callback();
	}
	,__class__: sound_MidiJsonLoader
};
var sound_MyAudio = function() {
	this._oldTime = 0;
	this.globalVolume = 1.5;
	this.isStart = false;
	this.freqByteDataAryEase = [];
	this._impulse = [];
	this.time = 0.0001;
	this.timeRatio = 0.0001;
	THREE.EventDispatcher.call(this);
};
sound_MyAudio.__name__ = true;
sound_MyAudio.__super__ = THREE.EventDispatcher;
sound_MyAudio.prototype = $extend(THREE.EventDispatcher.prototype,{
	init: function(callback) {
		if(sound_MyAudio.a != null) {
			window.alert("no");
			return;
		}
		sound_MyAudio.a = this;
		this._callback = callback;
		this._midiA = new sound_MidiJsonLoader();
		this._midiA.load("sound/nekodemo_bpm120vo.json","VOCAL",$bind(this,this._onLoad1));
	}
	,_onLoad1: function() {
		this._midiB = new sound_MidiJsonLoader();
		this._midiB.load("sound/nekodemo_bpm120beat.json","BEAT",$bind(this,this._onLoad2));
	}
	,_onLoad2: function() {
		this._midis = [this._midiA,this._midiB];
		this._init();
	}
	,_init: function() {
		var _this = window.document;
		this.audio = _this.createElement("audio");
		this.audio.src = "sound/nekodemobpm120.mp3";
		window.document.body.appendChild(this.audio);
		if(utils_OsChecker.isMobile()) {
			this.audio.autoplay = false;
			this.audio.volume = 0.1;
			window.document.getElementById("btn").onmousedown = $bind(this,this._onTouchStart);
		} else {
			window.document.getElementById("btn").style.display = "none";
			this.audio.addEventListener("canplaythrough",$bind(this,this._onLoad));
			this.audio.autoplay = false;
			this.audio.volume = 0.1;
			this.audio.loop = true;
		}
		common_Dat.gui.add(this,"timeRatio").listen();
		common_Dat.gui.add(this,"time").listen();
		common_Dat.gui.add(this.audio,"currentTime").listen();
	}
	,_onTouchStart: function() {
		window.document.getElementById("btn").style.display = "none";
		this.audio.addEventListener("canplaythrough",$bind(this,this._onLoad));
		this.audio.load();
	}
	,_onLoad: function(e) {
		this.audio.removeEventListener("canplaythrough",$bind(this,this._onLoad));
		this._callback();
	}
	,play: function() {
		this.isStart = true;
		this.audio.play();
		this.update();
	}
	,update: function() {
		if(!this.isStart) {
			console.log("not work");
			return;
		}
		this.timeRatio = this.getTimeRatio();
		this.time = this.getTime();
		this._calcMidi();
	}
	,_calcMidi: function() {
		var currentTime = this.getTime();
		var _g1 = 0;
		var _g = this._midis.length;
		while(_g1 < _g) {
			var j = _g1++;
			var midi = this._midis[j];
			var notes = midi.noteList;
			var _g3 = 0;
			var _g2 = notes.length;
			while(_g3 < _g2) {
				var i = _g3++;
				var time0 = this._oldTime;
				var time1 = currentTime;
				var t = notes[i].time;
				if(time0 < t && t <= time1) this.dispatchEvent({ type : "noteon", data : notes[i]});
			}
		}
		if(currentTime < this._oldTime) this.dispatchEvent({ type : "finish"});
		this._oldTime = currentTime;
	}
	,getTime: function() {
		return this.audio.currentTime % (this.audio.duration / 2);
	}
	,getTimeRatio: function() {
		return this.getTime() / (this.audio.duration / 2);
	}
	,getDuration: function() {
		return this.audio.duration / 2;
	}
	,__class__: sound_MyAudio
});
var three_Face = function() { };
three_Face.__name__ = true;
three_Face.prototype = {
	__class__: three_Face
};
var three_IFog = function() { };
three_IFog.__name__ = true;
three_IFog.prototype = {
	__class__: three_IFog
};
var three_Mapping = function() { };
three_Mapping.__name__ = true;
var three_Renderer = function() { };
three_Renderer.__name__ = true;
three_Renderer.prototype = {
	__class__: three_Renderer
};
var utils_MojiGeoGetter = function() {
};
utils_MojiGeoGetter.__name__ = true;
utils_MojiGeoGetter.getGeo = function() {
	var _shape = data_DataManager.getInstance().fontShape;
	var src = "NYAN";
	var list = [];
	var space = 140;
	var spaceY = 250;
	var g = new THREE.Geometry();
	var _g1 = 0;
	var _g = src.length;
	while(_g1 < _g) {
		var j = _g1++;
		var shapes = _shape.getShapes(HxOverrides.substr(src,j,1),true);
		var geo = new THREE.ExtrudeGeometry(shapes,{ bevelEnabled : false, amount : 30});
		var mat4 = new THREE.Matrix4();
		mat4.multiply(new THREE.Matrix4().makeScale(1,1,1));
		var vv = new THREE.Vector3((j * space - (src.length - 1) / 2 * space) * 0.5,0,0);
		mat4.multiply(new THREE.Matrix4().makeTranslation(vv.x,vv.y,vv.z));
		g.merge(geo,mat4);
	}
	return g;
};
utils_MojiGeoGetter.prototype = {
	__class__: utils_MojiGeoGetter
};
var utils_OsChecker = function() {
};
utils_OsChecker.__name__ = true;
utils_OsChecker.isMobile = function() {
	var s = utils_OsChecker.osis();
	return s == utils_OsChecker.IOS || s == utils_OsChecker.ANDROID;
};
utils_OsChecker.isAndroid = function() {
	return utils_OsChecker.osis() == utils_OsChecker.ANDROID;
};
utils_OsChecker.isIE = function() {
	if(utils_OsChecker._hasAgent("msie") || utils_OsChecker._hasAgent("trident")) return true;
	return false;
};
utils_OsChecker.isIosChrome = function() {
	return utils_OsChecker._hasAgent("crios");
};
utils_OsChecker.isSafari = function() {
	return utils_OsChecker._hasAgent("safari");
};
utils_OsChecker.isFirefox = function() {
	return utils_OsChecker._hasAgent("firefox");
};
utils_OsChecker.isWindows = function() {
	return utils_OsChecker._hasAgent("win");
};
utils_OsChecker.osis = function() {
	if(utils_OsChecker._hasAgent("iphone") || utils_OsChecker._hasAgent("ipad") || utils_OsChecker._hasAgent("ipod")) return utils_OsChecker.IOS;
	if(utils_OsChecker._hasAgent("mac")) return utils_OsChecker.MAC;
	if(utils_OsChecker._hasAgent("win")) return utils_OsChecker.WIN;
	if(utils_OsChecker._hasAgent("android")) return utils_OsChecker.ANDROID;
	return utils_OsChecker.ANDROID;
};
utils_OsChecker.goSupport = function() {
	if(utils_OsChecker._hasAgent("google") || utils_OsChecker._hasAgent("yahoo") || utils_OsChecker._hasAgent("y!")) return false;
	if(!Detector.webgl) return true;
	if(utils_OsChecker.isIosChrome()) return true;
	return false;
};
utils_OsChecker._hasAgent = function(str) {
	return window.navigator.userAgent.toLowerCase().indexOf(str) >= 0;
};
utils_OsChecker.prototype = {
	__class__: utils_OsChecker
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {}
var ArrayBuffer = $global.ArrayBuffer || js_html_compat_ArrayBuffer;
if(ArrayBuffer.prototype.slice == null) ArrayBuffer.prototype.slice = js_html_compat_ArrayBuffer.sliceImpl;
var DataView = $global.DataView || js_html_compat_DataView;
var Uint8Array = $global.Uint8Array || js_html_compat_Uint8Array._new;
Main3d.W = 1280;
Main3d.H = 720;
Three.CullFaceNone = 0;
Three.CullFaceBack = 1;
Three.CullFaceFront = 2;
Three.CullFaceFrontBack = 3;
Three.FrontFaceDirectionCW = 0;
Three.FrontFaceDirectionCCW = 1;
Three.BasicShadowMap = 0;
Three.PCFShadowMap = 1;
Three.PCFSoftShadowMap = 2;
Three.FrontSide = 0;
Three.BackSide = 1;
Three.DoubleSide = 2;
Three.NoShading = 0;
Three.FlatShading = 1;
Three.SmoothShading = 2;
Three.NoColors = 0;
Three.FaceColors = 1;
Three.VertexColors = 2;
Three.NoBlending = 0;
Three.NormalBlending = 1;
Three.AdditiveBlending = 2;
Three.SubtractiveBlending = 3;
Three.MultiplyBlending = 4;
Three.CustomBlending = 5;
Three.AddEquation = 100;
Three.SubtractEquation = 101;
Three.ReverseSubtractEquation = 102;
Three.ZeroFactor = 200;
Three.OneFactor = 201;
Three.SrcColorFactor = 202;
Three.OneMinusSrcColorFactor = 203;
Three.SrcAlphaFactor = 204;
Three.OneMinusSrcAlphaFactor = 205;
Three.DstAlphaFactor = 206;
Three.OneMinusDstAlphaFactor = 207;
Three.MultiplyOperation = 0;
Three.MixOperation = 1;
Three.AddOperation = 2;
Three.RepeatWrapping = 1000;
Three.ClampToEdgeWrapping = 1001;
Three.MirroredRepeatWrapping = 1002;
Three.NearestFilter = 1003;
Three.NearestMipMapNearestFilter = 1004;
Three.NearestMipMapLinearFilter = 1005;
Three.LinearFilter = 1006;
Three.LinearMipMapNearestFilter = 1007;
Three.LinearMipMapLinearFilter = 1008;
Three.UnsignedByteType = 1009;
Three.ByteType = 1010;
Three.ShortType = 1011;
Three.UnsignedShortType = 1012;
Three.IntType = 1013;
Three.UnsignedIntType = 1014;
Three.FloatType = 1015;
Three.UnsignedShort4444Type = 1016;
Three.UnsignedShort5551Type = 1017;
Three.UnsignedShort565Type = 1018;
Three.AlphaFormat = 1019;
Three.RGBFormat = 1020;
Three.RGBAFormat = 1021;
Three.LuminanceFormat = 1022;
Three.LuminanceAlphaFormat = 1023;
Three.RGB_S3TC_DXT1_Format = 2001;
Three.RGBA_S3TC_DXT1_Format = 2002;
Three.RGBA_S3TC_DXT3_Format = 2003;
Three.RGBA_S3TC_DXT5_Format = 2004;
Three.LineStrip = 0;
Three.LinePieces = 1;
camera_CamData.camA = new camera_CamData("normal_1",8000,0,0);
camera_CamData.camB = new camera_CamData("normal_2",5400,0,0);
camera_CamData.camC = new camera_CamData("normal_3",2700,0,0);
camera_CamData.camD = new camera_CamData("normal_4",7215,-0.3,-0.65);
camera_CamData.camE = new camera_CamData("normal_5",2800,1,0);
camera_CamData.camF = new camera_CamData("normal_6",3800,0,-1.419);
camera_CamData.cam1 = new camera_CamData("zoom",3800,0,0);
camera_CamData.cam2 = new camera_CamData("zoom_naname",4640,-0.609,-0.609);
camera_CamData.cam2b = new camera_CamData("zoom_naname",4640,0.581,-0.609);
camera_CamData.cam3 = new camera_CamData("zoom_down",4412,0,0.91);
camera_CamData.cam4 = new camera_CamData("zoom_yoko",6000,1.5,0);
camera_CamData.cams = [camera_CamData.camA,camera_CamData.camA,camera_CamData.camB,camera_CamData.camC,camera_CamData.camE,camera_CamData.camF];
camera_CamData.camsH = [camera_CamData.camA,camera_CamData.cam2,camera_CamData.cam3,camera_CamData.camD,camera_CamData.camF];
camera_CamData.camsV = [camera_CamData.camA,camera_CamData.cam2,camera_CamData.cam2b,camera_CamData.cam3,camera_CamData.cam4];
common_Config.canvasOffsetY = 0;
common_Config.globalVol = 1.0;
common_Config.particleSize = 10000;
common_Config.bgLight = 0.5;
common_Dat.UP = 38;
common_Dat.DOWN = 40;
common_Dat.LEFT = 37;
common_Dat.RIGHT = 39;
common_Dat.SPACE = 32;
common_Dat.K1 = 49;
common_Dat.K2 = 50;
common_Dat.K3 = 51;
common_Dat.K4 = 52;
common_Dat.K5 = 53;
common_Dat.K6 = 54;
common_Dat.K7 = 55;
common_Dat.K8 = 56;
common_Dat.K9 = 57;
common_Dat.K0 = 58;
common_Dat.A = 65;
common_Dat.B = 66;
common_Dat.C = 67;
common_Dat.D = 68;
common_Dat.E = 69;
common_Dat.F = 70;
common_Dat.G = 71;
common_Dat.H = 72;
common_Dat.I = 73;
common_Dat.J = 74;
common_Dat.K = 75;
common_Dat.L = 76;
common_Dat.M = 77;
common_Dat.N = 78;
common_Dat.O = 79;
common_Dat.P = 80;
common_Dat.Q = 81;
common_Dat.R = 82;
common_Dat.S = 83;
common_Dat.T = 84;
common_Dat.U = 85;
common_Dat.V = 86;
common_Dat.W = 87;
common_Dat.X = 88;
common_Dat.Y = 89;
common_Dat.Z = 90;
common_Dat.hoge = 0;
common_Dat.bg = false;
common_Dat._showing = true;
common_Dat._soundFlag = true;
common_Key.keydown = "keydown";
common_QueryGetter.NORMAL = 0;
common_QueryGetter.SKIP = 1;
common_QueryGetter._isInit = false;
common_QueryGetter.t = 0;
common_StageRef.$name = "webgl";
data_DataManager.internallyCalled = false;
data_NoteonData.BEAT = "BEAT";
data_NoteonData.VOCAL = "VOCAL";
data_Params.duration = 16.024;
data_Params.distance = 8000;
data_Quality.HIGH = true;
haxe_io_FPHelper.i64tmp = (function($this) {
	var $r;
	var x = new haxe__$Int64__$_$_$Int64(0,0);
	$r = x;
	return $r;
}(this));
js_Boot.__toStr = {}.toString;
js_html_compat_Uint8Array.BYTES_PER_ELEMENT = 1;
objects_CatBody.SEG_Z = 10;
objects_LongCat.SIZE_HEAD = 63.743;
objects_LongCat.SIZE_HIP = 67.9;
shaders_SimplexNoise.glsl = "\r\n//\r\n// Description : Array and textureless GLSL 2D/3D/4D simplex \r\n//               noise functions.\r\n//      Author : Ian McEwan, Ashima Arts.\r\n//  Maintainer : ijm\r\n//     Lastmod : 20110822 (ijm)\r\n//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.\r\n//               Distributed under the MIT License. See LICENSE file.\r\n//               https://github.com/ashima/webgl-noise\r\n// \r\n\r\nvec3 mod289(vec3 x) {\r\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\r\n}\r\n\r\nvec4 mod289(vec4 x) {\r\n\treturn x - floor(x * (1.0 / 289.0)) * 289.0;\r\n}\r\n\r\nvec4 permute(vec4 x) {\r\n\treturn mod289(((x*34.0)+1.0)*x);\r\n}\r\n\r\nvec4 taylorInvSqrt(vec4 r){\r\n\treturn 1.79284291400159 - 0.85373472095314 * r;\r\n}\r\n\r\nfloat snoise(vec3 v) { \r\n\r\n\tconst vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\r\n\tconst vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\r\n\r\n\t// First corner\r\n\tvec3 i  = floor(v + dot(v, C.yyy) );\r\n\tvec3 x0 =   v - i + dot(i, C.xxx) ;\r\n\r\n\t// Other corners\r\n\tvec3 g = step(x0.yzx, x0.xyz);\r\n\tvec3 l = 1.0 - g;\r\n\tvec3 i1 = min( g.xyz, l.zxy );\r\n\tvec3 i2 = max( g.xyz, l.zxy );\r\n\r\n\t//   x0 = x0 - 0.0 + 0.0 * C.xxx;\r\n\t//   x1 = x0 - i1  + 1.0 * C.xxx;\r\n\t//   x2 = x0 - i2  + 2.0 * C.xxx;\r\n\t//   x3 = x0 - 1.0 + 3.0 * C.xxx;\r\n\tvec3 x1 = x0 - i1 + C.xxx;\r\n\tvec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y\r\n\tvec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y\r\n\r\n\t// Permutations\r\n\ti = mod289(i); \r\n\tvec4 p = permute( permute( permute( \r\n\t\t  i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\r\n\t\t+ i.y + vec4(0.0, i1.y, i2.y, 1.0 )) \r\n\t\t+ i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\r\n\r\n\t// Gradients: 7x7 points over a square, mapped onto an octahedron.\r\n\t// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)\r\n\tfloat n_ = 0.142857142857; // 1.0/7.0\r\n\tvec3  ns = n_ * D.wyz - D.xzx;\r\n\r\n\tvec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)\r\n\r\n\tvec4 x_ = floor(j * ns.z);\r\n\tvec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)\r\n\r\n\tvec4 x = x_ *ns.x + ns.yyyy;\r\n\tvec4 y = y_ *ns.x + ns.yyyy;\r\n\tvec4 h = 1.0 - abs(x) - abs(y);\r\n\r\n\tvec4 b0 = vec4( x.xy, y.xy );\r\n\tvec4 b1 = vec4( x.zw, y.zw );\r\n\r\n\t//vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;\r\n\t//vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;\r\n\tvec4 s0 = floor(b0)*2.0 + 1.0;\r\n\tvec4 s1 = floor(b1)*2.0 + 1.0;\r\n\tvec4 sh = -step(h, vec4(0.0));\r\n\r\n\tvec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\r\n\tvec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\r\n\r\n\tvec3 p0 = vec3(a0.xy,h.x);\r\n\tvec3 p1 = vec3(a0.zw,h.y);\r\n\tvec3 p2 = vec3(a1.xy,h.z);\r\n\tvec3 p3 = vec3(a1.zw,h.w);\r\n\r\n\t//Normalise gradients\r\n\tvec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\r\n\tp0 *= norm.x;\r\n\tp1 *= norm.y;\r\n\tp2 *= norm.z;\r\n\tp3 *= norm.w;\r\n\r\n\t// Mix final noise value\r\n\tvec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);\r\n\tm = m * m;\r\n\treturn 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );\r\n\r\n}\r\n\r\nvec3 snoiseVec3( vec3 x ){\r\n\r\n\tfloat s  = snoise(vec3( x ));\r\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\r\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\r\n\tvec3 c = vec3( s , s1 , s2 );\r\n\treturn c;\r\n\r\n}\r\n\r\nvec3 snoiseVec3Abs( vec3 x ){\r\n\r\n\tfloat s  = snoise(vec3( x ));\r\n\tfloat s1 = snoise(vec3( x.y - 19.1 , x.z + 33.4 , x.x + 47.2 ));\r\n\tfloat s2 = snoise(vec3( x.z + 74.2 , x.x - 124.5 , x.y + 99.4 ));\r\n\tvec3 c = vec3( abs(s) , abs(s1) , abs(s2) );\r\n\treturn c;\r\n\r\n}\r\n\r\n\r\nvec3 curlNoise( vec3 p ){\r\n \r\n\tconst float e = .1;\r\n\tvec3 dx = vec3( e   , 0.0 , 0.0 );\r\n\tvec3 dy = vec3( 0.0 , e   , 0.0 );\r\n\tvec3 dz = vec3( 0.0 , 0.0 , e   );\r\n\r\n\tvec3 p_x0 = snoiseVec3( p - dx );\r\n\tvec3 p_x1 = snoiseVec3( p + dx );\r\n\tvec3 p_y0 = snoiseVec3( p - dy );\r\n\tvec3 p_y1 = snoiseVec3( p + dy );\r\n\tvec3 p_z0 = snoiseVec3( p - dz );\r\n\tvec3 p_z1 = snoiseVec3( p + dz );\r\n\r\n\tfloat x = p_y1.z - p_y0.z - p_z1.y + p_z0.y;\r\n\tfloat y = p_z1.x - p_z0.x - p_x1.z + p_x0.z;\r\n\tfloat z = p_x1.y - p_x0.y - p_y1.x + p_y0.x;\r\n\r\n\tconst float divisor = 1.0 / ( 2.0 * e );\r\n\treturn normalize( vec3( x , y , z ) * divisor );\r\n\r\n}\r\n\r\nvec3 curlNoise2( vec3 p ) {\r\n\r\n\tconst float e = .1;\r\n\r\n\tvec3 xNoisePotentialDerivatives = snoiseVec3( p );\r\n\tvec3 yNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 3., -3.,  1. ) );\r\n\tvec3 zNoisePotentialDerivatives = snoiseVec3( p + e * vec3( 2.,  4., -3. ) );\r\n\r\n\tvec3 noiseVelocity = vec3(\r\n\t\tzNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\r\n\t\txNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\r\n\t\tyNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\r\n\t);\r\n\r\n\treturn normalize( noiseVelocity );\r\n\r\n}\r\n\r\nvec4 snoiseD(vec3 v) { //returns vec4(value, dx, dy, dz)\r\n  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;\r\n  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);\r\n \r\n  vec3 i  = floor(v + dot(v, C.yyy) );\r\n  vec3 x0 =   v - i + dot(i, C.xxx) ;\r\n \r\n  vec3 g = step(x0.yzx, x0.xyz);\r\n  vec3 l = 1.0 - g;\r\n  vec3 i1 = min( g.xyz, l.zxy );\r\n  vec3 i2 = max( g.xyz, l.zxy );\r\n \r\n  vec3 x1 = x0 - i1 + C.xxx;\r\n  vec3 x2 = x0 - i2 + C.yyy;\r\n  vec3 x3 = x0 - D.yyy;\r\n \r\n  i = mod289(i);\r\n  vec4 p = permute( permute( permute(\r\n             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))\r\n           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))\r\n           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));\r\n \r\n  float n_ = 0.142857142857; // 1.0/7.0\r\n  vec3  ns = n_ * D.wyz - D.xzx;\r\n \r\n  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);\r\n \r\n  vec4 x_ = floor(j * ns.z);\r\n  vec4 y_ = floor(j - 7.0 * x_ );\r\n \r\n  vec4 x = x_ *ns.x + ns.yyyy;\r\n  vec4 y = y_ *ns.x + ns.yyyy;\r\n  vec4 h = 1.0 - abs(x) - abs(y);\r\n \r\n  vec4 b0 = vec4( x.xy, y.xy );\r\n  vec4 b1 = vec4( x.zw, y.zw );\r\n \r\n  vec4 s0 = floor(b0)*2.0 + 1.0;\r\n  vec4 s1 = floor(b1)*2.0 + 1.0;\r\n  vec4 sh = -step(h, vec4(0.0));\r\n \r\n  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;\r\n  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;\r\n \r\n  vec3 p0 = vec3(a0.xy,h.x);\r\n  vec3 p1 = vec3(a0.zw,h.y);\r\n  vec3 p2 = vec3(a1.xy,h.z);\r\n  vec3 p3 = vec3(a1.zw,h.w);\r\n \r\n  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));\r\n  p0 *= norm.x;\r\n  p1 *= norm.y;\r\n  p2 *= norm.z;\r\n  p3 *= norm.w;\r\n \r\n  vec4 values = vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ); //value of contributions from each corner (extrapolate the gradient)\r\n \r\n  vec4 m = max(0.5 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0); //kernel function from each corner\r\n \r\n  vec4 m2 = m * m;\r\n  vec4 m3 = m * m * m;\r\n \r\n  vec4 temp = -6.0 * m2 * values;\r\n  float dx = temp[0] * x0.x + temp[1] * x1.x + temp[2] * x2.x + temp[3] * x3.x + m3[0] * p0.x + m3[1] * p1.x + m3[2] * p2.x + m3[3] * p3.x;\r\n  float dy = temp[0] * x0.y + temp[1] * x1.y + temp[2] * x2.y + temp[3] * x3.y + m3[0] * p0.y + m3[1] * p1.y + m3[2] * p2.y + m3[3] * p3.y;\r\n  float dz = temp[0] * x0.z + temp[1] * x1.z + temp[2] * x2.z + temp[3] * x3.z + m3[0] * p0.z + m3[1] * p1.z + m3[2] * p2.z + m3[3] * p3.z;\r\n \r\n  return vec4(dot(m3, values), dx, dy, dz) * 42.0;\r\n}\r\n\r\n\r\nvec3 curlNoise3 (vec3 p) {\r\n\r\n    vec3 xNoisePotentialDerivatives = snoiseD( p ).yzw; //yzw are the xyz derivatives\r\n    vec3 yNoisePotentialDerivatives = snoiseD(vec3( p.y - 19.1 , p.z + 33.4 , p.x + 47.2 )).zwy;\r\n    vec3 zNoisePotentialDerivatives = snoiseD(vec3( p.z + 74.2 , p.x - 124.5 , p.y + 99.4 )).wyz;\r\n    vec3 noiseVelocity = vec3(\r\n        zNoisePotentialDerivatives.y - yNoisePotentialDerivatives.z,\r\n        xNoisePotentialDerivatives.z - zNoisePotentialDerivatives.x,\r\n        yNoisePotentialDerivatives.x - xNoisePotentialDerivatives.y\r\n    );\r\n\t\r\n\tconst float e = .1;\r\n\tconst float divisor = 1.0 / ( 2.0 * e );\r\n\treturn normalize( noiseVelocity * divisor );\r\n\r\n}\r\n\t\r\n\t";
sound_MyAudio.EVENT_NOTEON = "noteon";
sound_MyAudio.EVENT_FINISH = "finish";
sound_MyAudio.FFTSIZE = 64;
sound_MyAudio.LOOP_NUM = 2;
utils_OsChecker.WIN = "win";
utils_OsChecker.MAC = "mac";
utils_OsChecker.IOS = "ios";
utils_OsChecker.ANDROID = "android";
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
