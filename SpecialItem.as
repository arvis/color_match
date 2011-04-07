package  {
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	
	public class SpecialItem extends MovieClip  {
		
		var description:String;
		//var perkName:String;
		var id:int;
		
		public function SpecialItem() {
			// constructor code
			buyLabel.text="";
			//perkLabel.text="";

			
/*			
			activateLabel.visible=false;
			perkLabel.text="";
			
			this.addEventListener(MouseEvent.CLICK,onMouseClick);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT ,onMouseOut);
*/			
			
		}
		
		private function onMouseClick(evt:MouseEvent){
			var itemInfo:Array=new Array();
			itemInfo['id']=id;
			dispatchEvent(new GameEvent(itemInfo, GameEvent.SHOP_ITEM_SELECTED));
		}
		
		public function setDescription(str:String):void {
			description=str;
		}
		
		private function onMouseOver(evt:MouseEvent){
			var itemInfo:Array=new Array();
			itemInfo['description']=description;
			dispatchEvent(new GameEvent(itemInfo, GameEvent.MOUSE_OVER_SHOP_ITEM));
		}
		
		private function onMouseOut(evt:MouseEvent){
			//dispatchEvent(new GameEvent(GameEvent.MOUSE_OVER_SHOP_ITEM));
		}
		
		public function getDescription():String{
			return description;
		}
		
		public function setPerkName(perkName:String){
			perkLabel.text=perkName;
		}
		
		/*
		shows button to acrivate this perk
		*/
		
		public function setActivateButton(){
			buyLabel.visible=false;
			activateLabel.visible=true;
		}
		
		public function setBuyButton(){
			this.enabled=true;
			activateLabel.visible=false;
		}
		
		public function setAsActive(){
			this.enabled=true;
			activateLabel.visible=false;
			buyLabel.visible=false;
		}
		
		public function setAsInactive(){
			this.enabled=true;
			activateLabel.visible=true;
			buyLabel.visible=false;
		}
		public function setUnAvailable(){
			activateLabel.visible=false;
			buyLabel.visible=false;
			this.enabled=false;
			this.alpha=0.5;
		}
		
	}
	
}
