package  {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import fl.containers.UILoader;
	import fl.controls.Button;
    import flash.events.*;
    import flash.utils.Timer;
    import flash.external.ExternalInterface;
	
	public class StartMenu extends MovieClip {
		
		private var canStartGame:Boolean=true;
		private var db:DbAccess ;
		private var userData:Object;
		private var waitWindow:WaitWindow;
		private var nextGameTimer:Timer;
		private var secTillNextGame:int;
		//private var moreGamesWin:BuyGames;
		private const gameAddDelay:int=305 // every 5 min new game is added, 5 sec added just to be sure
		private var getCoins:CoinShop;
		private var tooltip:Tooltip;


		public function StartMenu(userInData:Object) {
			
			userData=userInData;
			waitWindow=new WaitWindow();
			fillUserData();
			startButton.addEventListener( MouseEvent.CLICK, onClickStart);
			getMoreGames.addEventListener( MouseEvent.CLICK, onClickGetMoreGames);
			getMoreGames.addEventListener( MouseEvent.MOUSE_OVER, onOverMoreGames);
			getMoreGames.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut);
			
			
			getMoreCoins.addEventListener( MouseEvent.CLICK, onClickGetMoreCoins);
			getMoreCoins.addEventListener( MouseEvent.MOUSE_OVER, onOverMoreCoins);
			getMoreCoins.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut);
			
			initPerks();
			//TODO: must show disabled effect
			//getMoreCoins.alpha=0.2;
			//getMoreCoins.enabled=false;
			//getMoreCoins.visible=false;
			
		}
		
		public function initPerks(){
			//perksButton.addEventListener( GameEvent.SHOP_ITEM_SELECTED, onPerkSelected);
			perksButton.addEventListener( MouseEvent.MOUSE_OVER, onPerks);
			perksButton.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut);
			setupPerks();
		}
		
		private function setupPerks() {
			var perk1:int =Number(userData['perk1']);
			
			if (perk1==0){
				perkLabel.visible=true;
				perksButton.gotoAndStop(4);
				perksButton.setupPerk(1,"");
				perksButton.setDescription("Pieslēdz superspēju un tu iegūsi 2x vairāk punktu\n par katru notverto plaukšķi.\n Darbojas tikai līdz 6. līmenim.");
				perksButton.addEventListener( GameEvent.SHOP_ITEM_SELECTED, onPerkSelected);
			}else if (perk1==1) {
				//perkLabel.visible=false;
				perkLabel.text="Aktuālā superspēja:";
				perksButton.gotoAndStop(3);
				perksButton.setDescription("Tu iegūsti 2x vairāk punktu par katru notverto\n plaukšķi. Darbojas tikai līdz 6. līmenim.");
				perksButton.setPerkName("Uzrāviens");
			}
			
		}




		public function fillUserData() {

			if ( Number(userData["games_left"])<1){
				
				//TODO: must show disabled effect on some frame
				startButton.alpha=0.5;
				startButton.enabled=false;
				canStartGame=false;
				showTillNextGame();
				
			}
			else {
				startButton.alpha=1;
				startButton.enabled=true;
				canStartGame=true;
				tillNextGame.visible=false;
				startButton.visible=true;
				startButton.enabled=true;
				
			}
			
			gamesLeft.text=""+userData["games_left"];
			coinsLeft.text=""+userData["coins"];
			levelTxt.text=""+userData["level"];
			
			if(userData["top_score"]) bestResult.text=Number(userData["top_score"])+"";
			if(userData["last_score"]) lastResult.text=userData["last_score"]+"";
			
			var user_exp:Number =Number(userData["experience"]);
			var lev_cap:Number =Number(userData["level_cap"]);
			experience.text=""+user_exp;
				
			trace("% is " + userData["level_cap"]);
			nextlvlPercent.text=lev_cap +"%";
			
			setupPerks();

			//friendsBest.text="";//FIXME: not yet implemented  userData["score"]+"";
			//gamesLeft.text="10";//FIXME: not yet implemented  userData["score"]+"";
		}
		
		private function showTillNextGame(){
			
			//FIXME: static text for now
			
			startButton.enabled=false;
			startButton.visible=false;
			
			tillNextGame.visible=true;
			
			return;
			
			nextGameTimer=new Timer(1000,0);
			nextGameTimer.addEventListener(TimerEvent.TIMER,onTimerTick);
			nextGameTimer.start();
			//secTillNextGame
			setTimeTillNext();
			
		}
		
		private function hideTillNextGame(){
			tillNextGame.text="0";
			tillNextGame.visible=false;
			
			if (nextGameTimer){
				nextGameTimer.removeEventListener(TimerEvent.TIMER,onTimerTick);
				nextGameTimer=null;
			}
			startButton.alpha=1;
			startButton.enabled=true;
			canStartGame=true;
		}
		
		private function setTimeTillNext(){
			
			var unixTime = Math.round(new Date().getTime()/1000);
			var secTillNext:int= unixTime -Number(userData["last_accessed"]);
			if (secTillNext>=gameAddDelay){
				hideTillNextGame();
			}
			else {
				tillNextGame.text=secondsToMin(secTillNext);
			}
		}


		//TODO: move it to some kind of utility class
		/**
		turns int seconds to minute string
		for example: 100 turns into 1:40 
		@param sec seonods that need to be converted to minutes standart
		@out min:sec as string 
		*/
		
		public function secondsToMin(sec:int):String {
			return Math.floor(sec/60)+":"+ sec%60;
		}
		

		private function onTimerTick(evt:Event){
			setTimeTillNext();
		}
		
//		public function onClickPerks( event:MouseEvent ):void{
		public function onPerkSelected( evt:GameEvent):void{
			try {
				var perkData:Array= evt.gameData;
				trace("perkdata is "+perkData);
				
				var perkId:int=perkData['id'];
				trace("perk clicked "+perkId);
				
				showWaitWinow();
				db=new DbAccess();
				db.addEventListener( GameEvent.GET_MORE_GAMES,buyingMoreGames);
				db.addEventListener( GameEvent.GAME_ERROR , onError);
				showWaitWinow();
				//TODO: add game customisation
				db.buyPerk(1);
			}
			catch (err:Error) {
				trace("showWaitWinow "+err.message); 
			}

			
		}
		
		public function onClickStart( event:MouseEvent ):void{
			
			if (!canStartGame) return;
			dispatchEvent( new NavigationEvent( NavigationEvent.START ) );
		}
		
		public function onClickGetMoreGames( event:MouseEvent ):void {
			db=new DbAccess();
			//db.getDataTemplate(1,"buy_games.php");
			db.addEventListener( GameEvent.GET_MORE_GAMES,buyingMoreGames);
			db.addEventListener( GameEvent.GAME_ERROR , onError);
			showWaitWinow();
			db.buyMoreGames();
		}
		
		public function onClickGetMoreCoins( event:MouseEvent ):void {
			if (!getCoins) getCoins=new CoinShop();
			this.addChild(getCoins);
			
/*			
			if (!db) db=new DbAccess();

			db.addEventListener( GameEvent.GET_MORE_COINS,buyingMoreCoins);
			db.addEventListener( GameEvent.GAME_ERROR , onError);
			showWaitWinow();
			
			//TODO: get numbers from another window
			db.buyMoreCoins(760,5);
*/			
		}
		
		
		public function onOverMoreGames( evt:MouseEvent ):void {
			
			tooltip= new Tooltip(300,50 , 4, "Iepērc spēles, ja ir izbeigušās, bet vēlies spēlēt.\n Par vienu monētu vari iegādāt 30 spēles.",
								 0x3467A8,0xFFFFFF , 0.8, true, "left", 10);
			tooltip.x=evt.stageX;
			tooltip.y=evt.stageY;
			this.addChild(tooltip);
			//evt.stageX, evt.stageY
			
		}
		
		public function onOverMoreCoins( evt:MouseEvent ):void {
			tooltip= new Tooltip(300,50 , 4, "Ja vajadzīgas monētas, tās vienmēr var iegādāties.\n Cena atkarīga no iegādāto monētu daudzuma.",
								 0x3467A8,0xFFFFFF, 0.8, true, "left", 10);
			tooltip.x=evt.stageX;
			tooltip.y=evt.stageY;
			this.addChild(tooltip);
			//evt.stageX, evt.stageY
		}
		
		public function onPerks( evt:MouseEvent ):void {
			tooltip= new Tooltip(300,50 , 4, perksButton.description ,
								 0x3467A8,0xFFFFFF, 0.8, true, "left", 10);
			tooltip.x=evt.stageX;
			tooltip.y=evt.stageY;
			this.addChild(tooltip);
		}
		
		
		
		public function onMouseOut( evt:MouseEvent ):void {
			this.removeChild(tooltip);
			tooltip=null;
		}
		
		
		public function showWaitWinow(){
			try {
				if (!waitWindow) waitWindow=new WaitWindow();
				waitWindow.x=0;
				waitWindow.y=0;
				this.addChild(waitWindow);
			}
			catch (err:Error) {
				trace("showWaitWinow "+err.message); 
			}
		}
		
		public function onError(evt:GameEvent){
			trace("error happened");
		}
		
		public function buyingMoreGames(evt:GameEvent){
			try {
				if (waitWindow) removeChild(waitWindow);
				waitWindow=null;
				//this.removeChild(moreGamesWin);
				var jsonObj:Object = evt.gameData[0];
				trace("buyingMoreGames coins left " + jsonObj["coins"]);
				
				if (jsonObj["games_left"]) userData["games_left"]=jsonObj["games_left"];
				if (jsonObj["coins"]) userData["coins"]=jsonObj["coins"];
				if (jsonObj["perk1"]) userData["perk1"]=jsonObj["perk1"];
				fillUserData();
				
				db.removeEventListener(GameEvent.GET_MORE_GAMES,buyingMoreGames);
				db.removeEventListener( GameEvent.GAME_ERROR , onError);
				db=null;
			}
			catch (err:Error) {
				trace("buyingMoreGames "+err.message); 
			}
		}

		public function buyingMoreCoins(evt:GameEvent){
			try {
				var jsonObj:Object = evt.gameData[0];
				db.removeEventListener(GameEvent.GET_MORE_COINS,buyingMoreGames);
				db.removeEventListener( GameEvent.GAME_ERROR , onError);
				db=null;
				
				//passing info to Javascript
				ExternalInterface.call("loadPayWindow",String(jsonObj["transaction"]["link"]));
				
			}
			catch (err:Error) {
				trace("buyingMoreGames "+err.message); 
			}
		}
		



		
		
	}
	
}
