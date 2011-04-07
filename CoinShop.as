package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	
	public class CoinShop extends MovieClip {
		
		private var waitWindow:WaitWindow;
		private var db:DbAccess;
		
		public function CoinShop() {
			// constructor code
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);
			sms10coins.addEventListener(MouseEvent.CLICK, onBuyTenCoins);
			sms30coins.addEventListener(MouseEvent.CLICK, onBuyThirtyCoins);

			db=new DbAccess();
			db.addEventListener( GameEvent.GET_MORE_COINS,buyingMoreCoins);
			db.addEventListener( GameEvent.GAME_ERROR,onError);
			
		}
		
		
		private function onBuyTenCoins (evt:MouseEvent){
			try {
				//showWaitWinow();
				db.buyMoreCoins(760,5);

			}
			catch (err:Error) {
				trace("onBuyTenCoins "+err.message); 
			}
		}
		
		private function onBuyThirtyCoins (evt:MouseEvent){
			try {
				//TODO: new pyament addition
				db.buyMoreCoins(760,5);

			}
			catch (err:Error) {
				trace("onBuyTenCoins "+err.message); 
			}
		}
		
		
		public function showWaitWinow(){
			try {
				if (!waitWindow) waitWindow=new WaitWindow();
				waitWindow.x=0;
				waitWindow.y=0;
				this.addChild(waitWindow);
			}
			catch (err:Error) {
				trace("buyingMoreGames "+err.message); 
			}
		}
		
		private function hideWaitWinow(){
			if (!waitWindow) return;
			this.removeChild(waitWindow);
			waitWindow=null;
		}
		
		public function buyingMoreCoins(evt:GameEvent){
			try {
				//removeChild(waitWindow);
				//waitWindow=null;
				//this.removeChild(moreGamesWin);
				var jsonObj:Object = evt.gameData[0];
				
				//trace("buyingMoreGames "+jsonObj["transaction"]["link"]+"id "+jsonObj["transaction"]["id"]);
				
				
				//passing info to Javascript
				ExternalInterface.call("loadPayWindow",String(jsonObj["transaction"]["link"]));
				
			}
			catch (err:Error) {
				trace("buyingMoreGames "+err.message); 
			}
		}
	
		private function onCloseWindow(evt:MouseEvent){
			trace("closing off");
			this.parent.removeChild(this);
		}
		
		
		public function onError(evt:GameEvent){
			trace("error happened");
		}
		
		
	}
	
}
