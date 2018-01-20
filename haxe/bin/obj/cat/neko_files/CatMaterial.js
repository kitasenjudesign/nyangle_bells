CatMaterial = function(){
    
    this.texture = THREE.ImageUtils.loadTexture( "./data/cat_diff.jpg");
    this.texture2 = THREE.ImageUtils.loadTexture( "./data/cat_norm.jpg");
    this.texture3 = THREE.ImageUtils.loadTexture( "./data/cat_spec.jpg");

    var param = {
	map : this.texture,
	specularMap: this.texture3,
	normalMap: this.texture2,
	skinning : false,
	depthWrite: true,
	depthTest: true,
//	transpatent: true,
    }

    
    THREE.MeshPhongMaterial.call(this,param );
    this.alphaTest = 0.9;
    this.shiness = 0;
    this.specular.set(0,0,0);
//    this.emissive.setRGB(0.1,0.1,0.1);

};

CatMaterial.prototype = Object.create( THREE.MeshLambertMaterial.prototype);
