[eval exp="tf.tmpstring = '---'"] 


  [iscript]
  src="https://maps.google.com/maps/api/js?key=AIzaSyDJivRs4qeoJt2ZWoBfeQCu_uf-Us77QdI";

		//使用可否をチェック
		if(navigator.geolocation){
			 //alert("位置情報が使用できます");
		}else{
			alert("位置情報が使用できません");
		}

		//Android用オプション
		var option={enableHighAccuracy:true,timeout:10000,maximumAge:0};

		get1();
		function get1(){
			navigator.geolocation.getCurrentPosition(seiko,shippai,option);
		}
		//成功した場合の処理
		function seiko(position){
			//alert("住所の成功");
			var latitude = position.coords.latitude;
			var longitude = position.coords.longitude;
			//alert("緯度:" + latitude);
			//alert("経度:" + longitude);
			tf.latitude = latitude;
			tf.longitude = longitude;
			//var genzaichi = new google.maps.LatLng(latitude,longitude); //この処理がうまくいっていない模様

			//alert("いいい");
			//住所の取得
			var geocoder = new google.maps.Geocoder();
			geocoder.geocode({'latLng':genzaichi},function(res,status){
				alert("住所の成功②");
				if(status != google.maps.GeocoderStatus.OK){
					var jushoString = "住所の取得失敗"+status;return;
				}
				var jushoString = res[0].formatted_address;
				var json = JSON.stringify( jushoString );
				alert("あああ");
				//alert(jushoString.toString());
				tf.tmpstring = json;
			});
		}
		//失敗
		function shippai(err){
			//alert("失敗"+err.code+err.message);
		}
	//tf.tmpstring = JSON.stringify(jushoString);
  [endscript]

;変数の内容をシナリオで表示したい場合は[emb]タグを使用


;#wakana
こんにちは！[p]
[chara/face exp_name="2"]
緯度は、 [emb exp="tf.latitude"]、経度は[emb exp="tf.longitude"]ですね。[p]

[eval exp="tf.Code=0"] 

	[iscript]
		var AreaCode=0;
		var LocArea = [
			[139.8188782,36.66910737],
			[139.9975544,36.48318499], // 緯度は仮
			[139.5862807,35.74856243],
			[139.9015872,35.54740611] ];

		var LocTestArea = [
			[139.73098755,35.66590855],// midtown
			[139.86479759,36.49576853],// godai e-school
			[139.87127599,37.67331662], // kitakata
			[140.01633167,36.57528391], // HGT
			[140.15556116,35.97492229] ]; // ushiku

		if(!isNaN(tf.latitude)){
			var x = tf.longitude;
			var y = tf.latitude;
		}
		else {
			var selectLoc = 3; 
			var x = LocTestArea[selectLoc-1][0];
			var y = LocTestArea[selectLoc-1][1];
		}

		if(!isNaN(tf.latitude)){
		// ①：x1＜x＜x2,y2＜y＜y1
			if ((x > LocArea[0][0]) && (LocArea[1][0] > x) && (y > LocArea[1][1]) && (LocArea[0][1] > y)) AreaCode=1;
		// ②：x3＜x＜x4,y4＜y＜y3
			if ((x > LocArea[2][0]) && (LocArea[3][0] > x) && (y > LocArea[3][1]) && (LocArea[2][1] > y)) AreaCode=2;
		// ③：x1＜x＜x2,y3＜y＜y2
			if ((x > LocArea[0][0]) && (LocArea[1][0] > x) && (y > LocArea[2][1]) && (LocArea[1][1] > y)) AreaCode=3;
		// ④：x＜x3
			if (LocArea[2][0] > x) AreaCode=4;
		// ⑤：y1＜y
			if (y > LocArea[0][1]) AreaCode=5;
		// ⑥：x2＜x,y2＜y＜y1
			if ((x > LocArea[1][0]) && (y > LocArea[1][1]) && (LocArea[0][1] > y)) AreaCode=6;
		// ⑦：x2＜x,y4＜y＜y2
			if ((x > LocArea[1][0]) && (y > LocArea[3][1]) && (LocArea[1][1] > y)) AreaCode=7;
		}else {
		alert("位置が取得できていません");
		}

		f.Loc_Area = AreaCode;

	[endscript]

	;[emb exp="f.Loc_x"],[emb exp="f.Loc_y"][p]
	現在のエリアコードは[emb exp="f.Loc_Area"]です。[p]
;[return]

@jump storage="stage1/Greeting.ks"
