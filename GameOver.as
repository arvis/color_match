package  {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	
	
	public class GameOver extends MovieClip {
		private var recordScore:Number=0;
		
		public function GameOver(score:Number, reason:String="game_over") {

			// TODO: make array of texts
			if (reason=="times_up"){
				reasonLabel.text="Laiks beidzies!";
			}
			scoreLabel.text=""+score;
			
			
			//restartButton.addEventListener( MouseEvent.CLICK, onClickRestart );
		}

/*
		public function onClickRestart( event:MouseEvent ):void{
			trace("restart game");
			dispatchEvent( new NavigationEvent( NavigationEvent.START ) );
		}
*/		
	}
	
}
