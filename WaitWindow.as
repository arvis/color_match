package  {
	
	import flash.display.MovieClip;
	
	
	public class WaitWindow extends MovieClip {
		
		
		public function WaitWindow() {
			// constructor code
		}
		
		public function setWaitText(windowText:String){
			
		}
		
		public function showWaitWinow(){
			this.parent.addChild(this);
			this.x=0;
			this.y=0;
			this.height=this.parent.height;
			this.width=this.parent.width;
			
		}
		
		public function hideWaitWinow(){
			this.parent.removeChild(this);
		}
		
		
		
	}
	
	
	
	
}
