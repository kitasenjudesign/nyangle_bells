
Model = function(mat){


    if( mat == undefined ){
	this.material = new CatMaterial();
    } else {
	this.material = mat;
    }

    // Three.js形式のベースモデルを読み込む時
    this.load = function( fn, callback){
	var that = this;
	var loader = new THREE.JSONLoader();
	loader.load( fn, function (geometry){

	    if( callback){
		callback();
	    }
	});

	
    };

    // Collada形式のベースモデルを読み込む
    this.loadDAE = function( fn, callback ){
	var that = this;
	var loader = new THREE.ColladaLoader();
	loader.load(fn, function (ret){

	    
	    dae = ret.scene;

	    dae.traverse( function(child){
		if( child instanceof THREE.Mesh){
		    child.material = that.material;
		}
	    });

	    THREE.Object3D.call(that);

	    that.add( dae );

	    if ( callback){
		callback();
	    }
	});	

    };


    this.RegistScene = function( scene ){
	scene.add(this);
    }


    //
    this.update = function(){

    };


    //
    this.stop = function(){
    }



};

Model.prototype = Object.create(THREE.Object3D.prototype);
