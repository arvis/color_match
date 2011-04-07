package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class GameScore extends MovieClip {
		
		//private var scr:TextField;
		const DEFAULT_TIME_LEN:int=60;
		private var scoreField:TextField;
		private var txtFormat:TextFormat;
		private var timeLeft:int=DEFAULT_TIME_LEN;
		
		
		public function GameScore() {
			// constructor code
			txtFormat=dummyTxtField.getTextFormat();
			scoreField=new TextField();
			scoreField.x=dummyTxtField.x;
			scoreField.y=dummyTxtField.y;
			
			scoreField.setTextFormat(txtFormat);
			this.addChild(scoreField);
			scoreField.text="0";
			scoreField.setTextFormat(txtFormat);
			dummyTxtField.text="";
			timeLeftLabel.text=""+timeLeft;
		}
		
		public function resetAll(){
			
			timeLeft=DEFAULT_TIME_LEN;
			timeLeftBar.resetAll(timeLeftBar.width);
		}
		
		
		public function setScore(gameScore:Number){
			//trace("new gameScore "+ gameScore);

			scoreField.setTextFormat(txtFormat);
			var scoreStr:String="a";
			//dummyTxtField.text=""+gameScore;
			scoreField.text=""+gameScore;
			scoreField.setTextFormat(txtFormat);
			
		}
		
		public function setLevel(level:int){
			playerLevel.text=level.toString();
		}
		
		public function setGameOver(){
			timeLeftLabel.text="0";
			timeLeftBar.hideBar();
			
		}
		
		
		/**
		shows gow much game time left
		*/
		
		public function gameTimeLeft(seconds:int){
			timeLeft=seconds;
			timeLeftLabel.text=""+seconds;
			timeLeftBar.shrinkBar(seconds);
		}
		
		public function setUserName(userName:String) {
			//gamesLeft.text = ""+games_left;
		}
		
		
	}
	
}
