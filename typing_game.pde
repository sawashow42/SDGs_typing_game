import ddf.minim.*; //<--new 
Minim minim; //<--new 
AudioPlayer bgm; //<--new 
AudioPlayer key_press;
AudioPlayer pikon;
AudioPlayer miss;
PImage back; 
PImage SDGs;
PImage fish; 
PImage earth;
String letters[]={"No poverty","Zero hunger","Good health and well-being","Quality education",
"Gender equality","Clean water and sanitation","Affordable and clean energy","Decent work and economic growth",
"Industry,innovation,infrastructure","Reduced inequalities","Sustainable cities and communities",
"Responsible consumption,production","Climate action","Life below water","Life on land",
"Peace,justice and strong institutions","Partnerships for the goals"}; 
String letter; 
int now=0; 
int time=3600; //<--new 時間
int missCount=0; //<--new ミスタイプ数
int cnt=0; //<--new 連続タイプ(10ごとに0になる)
boolean error=false; //<--new 間違えたかどうか
int errorCount=0; //<--new 間違い画像を表示する回数
int score=0; //<--new スコア
boolean continuous=false; //<--new 連続タイプができたかどうか
int continuousCount=0; //<--new タイム延長のテキストを表示する回数

//最初に呼ばれる関数
void setup(){
    size(900,560);
    back=loadImage("back3.png"); 
    SDGs=loadImage("SDGs.png");
    fish=loadImage("sakana.png");
    earth=loadImage("earth.png");
    letter=letters[(int)random(letters.length)];
    textSize(50);
    textAlign(CENTER);
    
    //サウンドの読み込み
    minim = new Minim( this ); //<--new 
    bgm = minim.loadFile( "bgm.mp3" ); //<--new 
    key_press=minim.loadFile("key.mp3");
    pikon=minim.loadFile("pikon.mp3");
    miss=minim.loadFile("type_miss.mp3");
    
    bgm.play();

}

//1秒間に60回呼び出される関数
void draw(){
    image(back,0,0); 
    image(SDGs,frameCount*3/2-100,400); 

    if(error){//<--new ミスタイプをしたら呼び出される。
        image(fish,0,0); //<--new ミスタイプ時に呼び出される画像
        errorCount++; //<--new この部分が呼び出される回数を数える
        if(errorCount>=30) { //<--new 0.5秒間画像を表示する
            error=false; //<--new ミスはなかったことに...
            errorCount=0; //<--new 回数は0に戻しておきましょう
        }
    }
    fill(255,140,0);
    text(letter,450,200);
    text("now : "+letter.charAt(now),450,260);

    if(time<=0) {//<--new タイムが0になったら
        image(back,0,0); //<--new 背景を読み込み直す
        fill(255,140,0); //<--new テキストの色を白にする
        text("RESULT",450,150);
        text("SCORE:"+score+"  MISS :"+missCount,450,200); //<--new結果のテキストを表示する
        image(earth,-100,60); //<--new　大きい方の猫を表示する
        noLoop(); //<--new　draw関数の動きが止まる
         bgm.close(); //<--new 
    }

    // 残り時間を四角形で表示する
    fill(141,217,163); //<--new 色を設定
    noStroke(); //<--new 縁の色はなしにする
    rect(0,0,time/4,20); //<--new 四角形を書く命令

    if(continuous){
        fill(255,165,0); //<--new テキスト色の変更
        text("+1s",800,80); //<--new テキストを表示
            continuousCount++; //<--new 何回表示されたかを記録
        if(continuousCount>=50){ //<--new PLUSを表示するのは50回まで！
            continuousCount=0; //<--new 回数を0に戻す
            continuous=false; //<--new 呼び出されなくする
        }
    }

    if(frameCount>=540){
        letter=letters[(int)random(letters.length)]; 
        now=0; 
        frameCount=0; 
    }
    time--; //<--new 残り時間を減らす
}

//キーボードが押されたら呼ばれる関数
void keyPressed() {
    key_press.rewind();
    key_press.play();
    if(key==letter.charAt(now)){
        cnt++; //<--new 連続タイプ数を増やす
        score++; //<--new スコアを増やす
        now++;
        if(now==letter.length()){
          letter=letters[(int)random(letters.length)];   
          now=0; 
          frameCount=0; 
          pikon.rewind();
          pikon.play();
        }
        if(cnt>=10){ //<--new 連続タイプが10以上になると
              cnt=0;
              time+=60; //<--new タイムが1秒増える
              continuous=true; //<--new 連続タイプできたことを伝える
          }
    }else if(keyCode==SHIFT){//<--new シフトキーはミスではない
        cnt++; //<--new 正しいタイピングなので数える
    }else{ //<--new ミス
        missCount++; //<--new ミスタイプを数える
        cnt=0; //<--new ミスすると連続タイプ数が0に戻る
        error=true; //<--new 間違えたことを伝える
        miss.rewind();
        miss.play();
    }
}
