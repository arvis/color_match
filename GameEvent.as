package  {
	import flash.events.Event;
	
	public class GameEvent extends Event  {

		public static const GAME_ERROR:String = "game_error";
		public static const GET_SCORE:String = "get_score";
		public static const GET_FRIENDS_LIST:String = "get_friends_list";
		public static const GAME_OVER:String = "game_over";
		public static const START_GAME:String = "start_game";
		public static const GET_MORE_GAMES:String = "get_more_games";
		public static const GET_MORE_COINS:String = "get_more_coins";
		
		public static const MOUSE_OVER_SHOP_ITEM:String = "mouse_over_shop_item";
		public static const SHOP_ITEM_SELECTED:String = "shop_item_selected";
		
		
		var gameData:Array;
		var currentGameScore:Number =0;
		var gameOverReason:String="game_over";

		public function GameEvent(postData:Array, type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			// constructor code
/*			
			if (type==GAME_OVER){
				currentGameScore=postData[0];
				gameOverReason==postData[0];
			}
			else
*/			
				gameData=postData;
			
			super( type, bubbles, cancelable );
		}

	}
	
}
