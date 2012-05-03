package  {
	
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.display.Sprite;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.*;
	import flash.display.Loader;
	//TODO: add explicit imports	
	
	
	import com.adobe.serialization.json.JSON;

	//TODO: extends sprite just for dispatchevent, need to replace extend clasess to other, more meaningfull
	public class DbAccess extends Sprite  {

		const hostName:String="";
		var sendLoad:URLLoader; 
		var offline:Boolean=true;

		public function DbAccess() {
			// constructor code
			
			
		}
		
		
		
		public function saveScore(uid:Number,score:Number,return_Json:Boolean=true){
			try {
			if (offline) return;	
			var save_link="save_data.php";
			
			var URLReq:URLRequest = new URLRequest(hostName+save_link);
			var variables:URLVariables = new URLVariables();
			variables.game_score=""+score;
			variables.uid=""+uid;
			
			//xmlURLReq.data = book;
			URLReq.data = variables;
			
			//xmlURLReq.contentType = "text/xml";
			URLReq.method = URLRequestMethod.POST;
			
			sendLoad= new URLLoader();
			sendLoad.dataFormat = URLLoaderDataFormat.TEXT;

			var funct:Function;
			funct=onJsonComplete;


			sendLoad.addEventListener(Event.COMPLETE, funct, false, 0, true);
			sendLoad.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			sendLoad.load(URLReq);
			}
			catch (err:Error) {
				trace("saveScore "+err.message); 
			}
			
		}
		
		public function getNewGameData(function_url:String="new_game.php" ){
			getDataTemplate(function_url,onNewGameComplete);
			
		}
		
		public function buyMoreGames(){
			getDataTemplate("buy_games.php",onBuyGamesComplete);
		}
		
		public function buyPerk(perkId:int) {
			var urlVars:URLVariables = new URLVariables();
			urlVars.perk_id = perkId;
			getDataTemplate("buy_perks.php",onBuyGamesComplete,urlVars );
		}
		
		
		
		public function buyMoreCoins(serviceId:int,price:int){
			var urlVars= new URLVariables();
			urlVars.service=serviceId;
			urlVars.price=price;
			
			getDataTemplate("start_payment.php", onBuyCoinsStartComplete,urlVars );
		}
		
		public function getDataTemplate(function_url:String="get_user_data.php", funct:Function=null,variables:URLVariables=null){
			try {
				var url:String;
				
				url=hostName+function_url;				
				var URLReq:URLRequest = new URLRequest(url);
				//var variables:URLVariables = new URLVariables();
				if (variables==null){
					variables= new URLVariables();
				}
				
				//variables.uid=""+uid;
				//xmlURLReq.data = book;
				URLReq.data = variables;
				
				//xmlURLReq.contentType = "text/xml";
				URLReq.method = URLRequestMethod.POST;
				
				sendLoad= new URLLoader();
				sendLoad.dataFormat = URLLoaderDataFormat.TEXT;
				
				//var funct:Function;
				if (funct==null){
					funct=onJsonComplete;
				}
				//trace("getDataTemplate on process" );
				sendLoad.addEventListener(Event.COMPLETE, funct, false, 0, true);
				sendLoad.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
				sendLoad.load(URLReq);
			}
			catch (err:Error) {
				trace("getData "+err.message); 
			}

		}
		
		public function onIOError(evt:IOErrorEvent):void {
			trace("onIOError" + evt.text);
			var responseText:String  = "" + evt.text;
			
			dispatchEvent(new GameEvent(processText(responseText), GameEvent.GAME_ERROR));
		}
		
		
		function onNewGameComplete(evt:Event){
			var funct:String =GameEvent.START_GAME;
			onJsonCompleteTemplate(evt,funct);
		}
		
		function onBuyGamesComplete(evt:Event){
			//TODO: set other event listener
			var funct:String =GameEvent.GET_MORE_GAMES;
			onJsonCompleteTemplate(evt,funct);
		}
		
		function onBuyCoinsStartComplete(evt:Event){
			//TODO: set other event listener
			trace("start onBuyCoinsStartComplete");
			var funct:String =GameEvent.GET_MORE_COINS;
			onJsonCompleteTemplate(evt,funct);
		}
		
		
		
		function onJsonCompleteTemplate(evt:Event,complete_function:String){
			try {
				var responseText:String = ""+evt.target.data;
				//trace("onJsonCompleteTemplate "+ responseText);
				
				sendLoad.removeEventListener(Event.COMPLETE, onJsonComplete);
				sendLoad.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				var JsonData:Object=processJson(responseText);
				
				var retArr:Array=new Array();
				retArr.push(JsonData);
				
				//trace("onJsonCompleteTemplate "+responseText);
				//based on return info choose event 
				dispatchEvent(new GameEvent(retArr,complete_function));
				
			} catch (err:TypeError) {
				responseText = "Error: " + err.message; //+err.text;
				dispatchEvent(new GameEvent(processText(responseText), GameEvent.GAME_ERROR));
			}
			
		}
		
		
		function onJsonComplete(evt:Event){
			try {
				var responseText:String = ""+evt.target.data;
				
				sendLoad.removeEventListener(Event.COMPLETE, onJsonComplete);
				sendLoad.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				var JsonData:Object=processJson(responseText);
				
				var retArr:Array=new Array();
				retArr.push(JsonData);
				
				//trace("onJsonComplete "+responseText);
				//based on return info choose event 
				if (JsonData["uid"])
					dispatchEvent(new GameEvent(retArr, GameEvent.GET_SCORE));
				else
					dispatchEvent(new GameEvent(retArr, GameEvent.GET_FRIENDS_LIST ));
				
			} catch (err:TypeError) {
				responseText = "Error: " + err.message; //+err.text;
				dispatchEvent(new GameEvent(processText(responseText), GameEvent.GAME_ERROR));
			}
		}



		public function getFriendsList(currentPage:int,friendsPerPage:int) {
			//TODO: think if we need uid to pass
			//trace("getFriendsList start");
			var variables:URLVariables = new URLVariables();
			variables.page_no=""+currentPage;
			
			getDataTemplate("friends_list.php",null, variables);
		}
		
		
		public function processJson(jsonText:String):Object {
			//jsonText = '[{"uid":"10226","level":"3","experience":"473","top_score":"382","img":"http:\/\/i6.ifrype.com\/profile\/010\/226\/v1297201342\/sm_10226.jpg"},{"uid":"127704","level":"5","experience":"860","top_score":"388","img":"http:\/\/i6.ifrype.com\/profile\/010\/226\/v1297201342\/sm_10226.jpg"}] ';
			var friendsData:Object= JSON.decode(jsonText);
			
			//trace(friendsData['uid']);
			return friendsData;
		}



		//FIXME: just for testing
		public function testgetFriendsList(jsonText:String):Object {
			jsonText = '[{"uid":"10226","level":"3","experience":"473","top_score":"382","img":"http:\/\/i6.ifrype.com\/profile\/010\/226\/v1297201342\/sm_10226.jpg"},{"uid":"127704","level":"5","experience":"860","top_score":"388","img":"http:\/\/i6.ifrype.com\/profile\/010\/226\/v1297201342\/sm_10226.jpg"}] ';
			trace("testgetFriendsList");
			var friendsData:Object= JSON.decode(jsonText);
			trace(friendsData);
			return friendsData;
		}
		
/*		
		public function processFriendsList(friendsList:Object) {
				var friendData:Object;
				var uid;
				for(var uid in friendsList){
					//trace(jsonObj[i]);
					friendData=jsonObj[uid];
					trace(a['img']);
				}
		}
*/		
		
		public function loadImage(url:String){
			//TODO: security if wrong image url is given
			
			var urlReq:URLRequest = new URLRequest(url);
			var loader:Loader = new Loader();
			loader.load(urlReq);
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoadComplete);
		}
		
		function onImgLoadComplete(event:Event):void{
			trace("img load complete");
			//dispatchEvent(new GameEvent(retArr, GameEvent.GET_FRIENDS_LIST));
			
		}
		
		/**
		splits response text
		text are storeed in format 
		value1|value2|value3
		returns array
		*/
		
		function processText(inText:String ):Array {
			var dataArr:Array= inText.split("|");
			// TODO: check for data correctness
			return dataArr;
		}
		




	}
	
}
