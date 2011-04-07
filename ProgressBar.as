package  {
	
	import flash.display.MovieClip;
	
	
	public class ProgressBar extends MovieClip {
		
		var pxPerSecond:int=5; // for how many pixels to move in one second
		var barWidth:int=370;
		
		public function ProgressBar() {
			
			//setting one second shrink
			//movingPart.x=0;
			//movingPart.width=10;//this.width-150; // FIXME: somehow moving part is too big 
			pxPerSecond=Math.round(this.width/60);
		}
		
		public function hideBar(){
			this.width=0;
		}
		
		public function shrinkBar(secLeft:int){
			this.width=this.width-pxPerSecond;
			//movingPart.width=movingPart.width-pxPerSecond;
			//secondsLeft.text=""+secLeft;//
			
		}
		
		public function resetAll(w:int){
			this.width=barWidth;
			
		}
		
		
		
	}
	
}
