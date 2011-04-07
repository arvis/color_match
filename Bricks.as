package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class Bricks extends MovieClip {
		
		const EMPTY_FRAME:int=9;
		public var frameNr:int=EMPTY_FRAME;
		public var marked_for_delete:Boolean=false;
		public var score:Number=1; 
		public var row:int;
		public var col:int;
		private var mulitply:int=1;
		
		public function Bricks() {
			// constructor code
			
			cls.visible=false;

			
			frameNr=EMPTY_FRAME;
			gotoAndStop(EMPTY_FRAME);
			//var aaa:TextField=this.getChildByName("multiplierText") as TextField;
			//trace(aaa.text);			
			//multiplierText.text="";

		}
		
		public function setEmpty(){
			setFrame(EMPTY_FRAME);
			mulitply = 1;
			cls.visible = false;

		}
		
		public function isEmpty():Boolean{
			if (frameNr==EMPTY_FRAME) return true;
			else return false
		}
		
		public function getFrame():int {
			return frameNr;
		}
		
		public function setFrame(current_frame_no:int){
			frameNr=current_frame_no;
			cls.visible=false;
			this.gotoAndStop(current_frame_no);

		}
		
		public function getTileScore():Number{
			return score*mulitply;
		}
		
		public function setTileScore(amount:Number){
			score=amount;
		}
		public function setMulitplier(amount:int=1){
			if (frameNr == EMPTY_FRAME) {
				mulitply=1;
				return;
			}
			
			if (amount>1){
				mulitply=amount;
				cls.visible=true;
				cls.gotoAndStop(amount);
				//multiplierText.text=mulitply+"x";

			}
			else if (amount==1) {
				mulitply=amount;
				cls.visible=false;
				//multiplierText.text="";
			}
			
		}
		


		public function getMulitplier():int{
			return mulitply;
		}
		
	}
	
}
