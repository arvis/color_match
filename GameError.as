package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class GameError extends MovieClip {
		
		
		public function GameError(msg:String="") {
			// constructor code
			var msgText:TextField=new TextField();
			//msgText.length=300;
			//msgText.height=300;
			msgText.selectable=true;
			msgText.text=msg;
			//this.addChild(msgText);
			errTxt2.text=msg;
		}
	}
	
}
