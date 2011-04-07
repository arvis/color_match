package  {
	
	import flash.display.MovieClip;
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.*;
    import flash.errors.*;
	import flash.text.TextField;
	import flash.utils.Timer;

	
	public class MainDocument extends MovieClip {
		var startMenu:StartMenu;
		var gameField:GameField;
		var gameOverMenu:GameOver;
		var waitWindow:WaitWindow;
		var db:DbAccess;
		var userData:Object;
		var offline_play:Boolean=false;
		//var preloader:Preloader;
		
		
		public function MainDocument() {
			//initGame();
			
			showPreloader();
		}
		
		private function showPreloader(){
			//var loaded:Number = this.stage.loaderInfo.bytesLoaded;
			//trace("loaded "+loaded);
			
			//preloader=new Preloader();
			preloader.visible=true;
			preloader.x=0;
			preloader.y=0;
			preloader.addEventListener(Event.COMPLETE, onPreloaderComplete);
			
		}
		
		private function onPreloaderComplete(e:Event):void {
			trace("preloader complete");
			initGame();
			//hidePreloader();
		}
		
		private function hidePreloader(){
			if (!preloader) return;
			
			preloader.removeEventListener(Event.COMPLETE, onPreloaderComplete);
			preloader.visible=false;
			this.removeChild(preloader);
			preloader=null;
			//initGame();
			
		}
		
		private function initGame(){
			initUserData();
			//showStartMenu();
			getDataFromDb();
		}
		
		
		private function initUserData(){
			userData=new Object();
			userData["uid"]=0;
			userData["name"]="";
			userData["last_score"]=0;
			userData["level"]=1;
			userData["top_score"]=0;
			userData["games_left"]=0;
			userData["friends_best"]=0;
			userData["level_cap"]=1;
			userData["experience"]=1;
			userData["coins"]=0;
			userData["name"] = "";
			userData["perk1"] = 0;
			userData["perks"] = "";
		}
		
		
		public function showStartMenu(){
			try {
				hideWaitWindow();
				hidePreloader();
				
				startMenu=new StartMenu(userData);
				startMenu.addEventListener( NavigationEvent.START, initGameStart);

				this.addChild(startMenu);
			}
			catch (err:Error) {
				trace("showStartMenu "+err.message); 
			}
			
		}
		
		//public function getDataFromDb (navigationEvent:NavigationEvent):void{
		public function getDataFromDb (function_url:String="get_user_data.php"):void{
			try {
				
				if (!db) {
					db=new DbAccess();
					db.addEventListener( GameEvent.GET_SCORE , getScore);
					db.addEventListener( GameEvent.START_GAME , startGameEvent);
					db.addEventListener( GameEvent.GAME_ERROR , onError);
				}
				
				//FIXME: more elegant solution
				// FIXME: game fails, if there is reading from db fails
				if (function_url=="new_game.php"){
					db.getNewGameData(function_url);
				}
				else
					db.getDataTemplate(function_url);
			}
			catch (err:Error) {
				trace("getDataFromDb "+err.message); 
			}
		}
		
		/**
		signals to server that user pressed start game button
		on success inits game field
		*/
		
		function initGameStart(evt:NavigationEvent){
			try {
				//TODO: maybe need to check for event type
				if (startMenu) {
					trace("start menu "+startMenu );
					this.removeChild(startMenu);
					startMenu=null;
				}
				userData["games_left"]=Number(userData["games_left"])-1;
				startGame();
				// sending new game status to DB
				getDataFromDb("new_game.php");
				
				
			}
			catch (err:Error) {
				trace("startGame "+err.message); 
			}
		}

		function startGameEvent(evt:GameEvent){
			try {
				var jsonObj:Object = evt.gameData[0];
				trace("new game data successfully initialised");
				
			}
			catch (err:Error) {
				trace("startGame "+err.message); 
			}
		}
		
		function startGame(jsonObj:Object=null){
			try {
				//TODO: maybe need to check for event type
				if (startMenu) {
					this.removeChild(startMenu);
					startMenu=null;
				}
								
				//if we already have data dont set anything
				//if (jsonObj) setUserData(jsonObj);
				
				if (!gameField)
					gameField=new GameField(userData["level"],userData["perk1"], userData["name"]);
				else
					gameField.resetGameField(userData["level"],userData["perk1"],userData["name"]);
				
				gameField.x=10;
				gameField.y=10;
				this.addChild(gameField);
				
				gameField.addEventListener( GameEvent.GAME_ERROR , onError);
				gameField.addEventListener( GameEvent.GAME_OVER, gameOver );
			
			}
			catch (err:Error) {
				trace("startGame "+err.message); 
			}
		}

		public function gameOver(evt:GameEvent):void{
			try {
				
				
				var gameScore:Number=evt.gameData[0];
				var gameOverReason:String="game_over";
				if (evt.gameData[1]) gameOverReason=evt.gameData[1];
				
				gameOverMenu=new GameOver(gameScore,gameOverReason);
				gameOverMenu.x=0;
				gameOverMenu.y=0;
				this.addChild(gameOverMenu);
				trace("start game over");
				//FIXME: testing 
				//var ww:WaitWindow=new WaitWindow();
				//this.addChild(ww);				
				
				
				//wait 1 second then remove menu
				//var waitTimer:Timer=new Timer(1000,1);
				//waitTimer.start();
				
				gameField.initGameFieldData();

				db.saveScore(userData["uid"],gameScore);
				trace("game score saved-"+gameScore);
				//showStartMenu();


				//gameOverMenu.addEventListener( NavigationEvent.START, restartGame );
				//this.addChild(gameOverMenu);  
			}
			catch (err:Error) {
				trace("gameOver "+err.message); 
			}
			
			
		}
		
		public function getScore(gameEvent:GameEvent):void {
			try{
				var jsonObj:Object = gameEvent.gameData[0];				
				setUserData(jsonObj);
				
				hideGameOverMenu();
				
				if (waitWindow){
					this.removeChild(waitWindow);
					waitWindow=null;
				}
				
				showStartMenu();
			}
			catch (err:Error) {
				trace("getScore "+err.message); 
			}
		}
		
		
		private function setUserData(jsonObj:Object){
			try {			
				trace("getScore "+jsonObj["last_score"]);
				
				//FIXME: what needs to be done, if any of these data are absent?
				userData["uid"]= jsonObj["uid"] ;
				userData["level"]=jsonObj["level"];// gameEvent.gameData[1];
				userData["last_score"]= jsonObj["last_score"];
				userData["name"]= jsonObj["name"];
				userData["top_score"]= jsonObj["top_score"];
				userData["games_left"]= Number(jsonObj["games_left"]);
				userData["coins"]= jsonObj["coins"];
				if (jsonObj["experience"]) userData["experience"]= jsonObj["experience"]+"";
				if (jsonObj["level_cap"]) userData["level_cap"]= jsonObj["level_cap"]+"";
				if (jsonObj["name"]) userData["name"]= jsonObj["name"]+"";
				if (jsonObj["perk1"]) userData["perk1"]= jsonObj["perk1"]+"";
				if (jsonObj["perks"]) userData["perks"]= jsonObj["perks"]+"";
				
				
			
			}
			catch (err:Error) {
				trace("getScore "+err.message); 
			}
			
		}
		
		
		public function onError(gameEvent:GameEvent):void {
			trace("game error");
			//debugWin.text= gameEvent.gameData[0];
		}
		
		
		function showErrorWindow(err:String=""){
			//var err:GameOver=new GameOver();
			this.addChild(new GameError(err));
			
		}
		
		public function hideGameOverMenu(){
			if (gameOverMenu){
				this.removeChild(gameOverMenu);
				gameOverMenu=null;
			}
		}

		public function hideWaitWindow(){
			if (waitWindow){
				this.removeChild(waitWindow);
				waitWindow=null;
			}
			
		}
		
		
	}
	
}
