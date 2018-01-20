var fs = require('fs');

//ファイル一覧取得関数
function readdir(dir) {
  fs.readdir(dir, function (err, files) {
    if (err) {
        throw err;
    }

    //ここに処理
    console.log(files);
  });
}

//使い方
readdir("./public/img/");
