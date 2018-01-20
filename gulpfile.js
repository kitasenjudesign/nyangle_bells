var gulp = require('gulp');
var pug = require('gulp-pug');
var sass = require('gulp-sass');
var connect = require('gulp-connect');
var browserSync = require('browser-sync');
var concat = require("gulp-concat");
var spritesmith = require('gulp.spritesmith');
var uglify = require('gulp-uglify');
var stripDebug = require( 'gulp-strip-debug' );
var imagemin = require('gulp-imagemin');
var rimraf = require('rimraf');
var del = require('del');
var ftp = require('gulp-ftp');



gulp.task('pug', () => {
  return gulp.src(['./pug/**/*.pug', '!./pug/**/_*.pug'])
  .pipe(pug({
    pretty: true
  }))
  .pipe(gulp.dest('./public/'));
});

gulp.task('sass', function(){
  gulp.src('./sass/*.sass')
    .pipe(sass())
    .pipe(gulp.dest('./public/css/'));
});

//サーバーを起動する
gulp.task('connect', function() {
  connect.server({
    root: './public/',
    index:"index.html",
    livereload: true
  });
});

//ブラウザのリロード
gulp.task('browser-sync', function() {
    browserSync({
        server: {
            baseDir: "./public/"
        }
    });
});

gulp.task('bs-reload', function () {
    browserSync.reload();
});

//jsの連結と圧縮
gulp.task("concat", function() {
  var files = [
    "lib/jquery.min.js",
    "lib/dat.gui.min.js",
    //"lib/createjs-2015.11.26.min.js",
    "lib/three/three.min87.js",
    "lib/TweenMax.min.js",
    "lib/_ColladaLoader.js"
    //"lib/three/postprocessing/EffectComposer.js",
    //"lib/three/postprocessing/RenderPass.js",
    //"lib/three/postprocessing/ShaderPass.js",
    //"lib/three/postprocessing/MaskPass.js",
    //"lib/three/postprocessing/BloomPass.js",
    //"lib/three/shaders/CopyShader.js",
    //"lib/three/shaders/ConvolutionShader.js"

    //"js/three/js/controls/OrbitControls.js",
    //"js/three/js/controls/DeviceOrientationControls.js",
    //"js/three/js/controls/TrackballControls.js",
    //"js/three/js/postprocessing/BloomBlendPass.js"
  ];
  gulp.src(files)
    .pipe(concat('lib.js'))
    .pipe(stripDebug())
    .pipe(uglify())
    .pipe(gulp.dest('./public/js/'))
    ;
});

//css用のsprite
gulp.task('sprite', function () {

    ////sp用
    var spriteData = gulp.src('img/*.png').pipe(spritesmith({
        imgName: 'sprite.png',
        cssName: '_sprite.sass',
        padding: 5,
        imgPath: '../img/sprite/sprite.png',//生成されるscssに記載されるパス
        cssFormat: 'sass',
        cssVarMap: function (sprite) {
            sprite.name = 'sprite-' + sprite.name;
        }
    }));

    spriteData.img
        .pipe(gulp.dest('./public/img/sprite/'));

    spriteData.css
        .pipe(gulp.dest('sass/'));


    ////pc用
    var spriteData2 = gulp.src('img_pc/*.png').pipe(spritesmith({
        imgName: 'sprite_pc.png',
        cssName: '_sprite_pc.sass',
        padding: 5,
        imgPath: '../img/sprite/sprite_pc.png',//生成されるscssに記載されるパス
        cssFormat: 'sass',
        cssVarMap: function (sprite) {
            sprite.name = 'sprite_pc-' + sprite.name;
        }
    }));

    spriteData2.img
        .pipe(gulp.dest('./public/img/sprite/'));//画像保存先

    spriteData2.css
        .pipe(gulp.dest('sass/'));//sass画像保存先

});

//画像の圧縮
gulp.task('imagemin', function () {
    gulp.src('./public/img/about/about.png')
        .pipe(imagemin())
        .pipe(gulp.dest('./public/img/'))
});

gulp.task('upload', function () {
    return gulp.src([
        './public/index.html',
        './public/v3/css/*.css',
        './public/v3/js/*.js',
        './public/v3/json/*.json'
    ],{ base: 'public' })
        .pipe(ftp({
            host: 'ftp.7904f63549ad9ac2.lolipop.jp',
            user: 'lolipop.jp-7904f63549ad9ac2',
            pass: 'nabetaka7',
            remotePath: "/" // リモート側のパス　（デフォルトは "/"）
        }))
        // you need to have some kind of stream after gulp-ftp to make sure it's flushed
        // this can be a gulp plugin, gulp.dest, or any kind of stream
        // here we use a passthrough stream
        .pipe(gutil.noop());
});



//watch
gulp.task("default", ["browser-sync"], function() {
  // pug sassフォルダー以下のファイルを監視
  //gulp.watch("js/**", ["concat"]);
  gulp.watch("pug/**", ["pug"]);
  gulp.watch("sass/**", ["sass"]);
  gulp.watch("./public/**", ["bs-reload"]);
});
