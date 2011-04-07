package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	
	public class Perk extends MovieClip {
		
		public var price:int=0;
		public var perkId:int=0;
		public var description:String="";
		public var forSale:Boolean=false;
		public var bitmapLink:String="";
		public var perkSlot:Boolean=false;
		public var locked:Boolean=false;
		private const DEFAULT_DESCRIPTION:String="Šajā logā Jūs varat izvēlēties superspēkus. Pārbrauciet ar peli, lai parādītos apraksts par to. Noklikšķiniet lai iegādātos, vai aktivizētu, ja superspēks jau ir iegādāts.";
		
		
		public function Perk() {
			// constructor code
			//perkPriceLabel.visible=false;
			this.buttonMode=true;
			setMouseOutLook();
			//this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOn);
			//this.addEventListener(MouseEvent.MOUSE_OUT ,onMouseOut);
			this.addEventListener(MouseEvent.CLICK ,onMouseClick);
			
		}
		
		
		
		
		public function onMouseClick(evt:MouseEvent){
			setMouseOutLook();
			var itemInfo:Array=new Array();
			itemInfo['id']=this.perkId;
			dispatchEvent(new GameEvent(itemInfo, GameEvent.SHOP_ITEM_SELECTED));
			
		}
		
		
		public function onMouseOut(evt:MouseEvent){
			setMouseOutLook();
			// setting description to empty
			var itemInfo:Array=new Array();
			itemInfo.push(DEFAULT_DESCRIPTION);
			dispatchEvent(new GameEvent(itemInfo, GameEvent.MOUSE_OVER_SHOP_ITEM));

		}
		
		public function setMouseOutLook(){
			this.alpha=0.8;
			this.scaleX=1;
			this.scaleY=1;
			
		}
		
		public function onMouseOn(evt:MouseEvent){
			setMouseOnLook();
			var itemInfo:Array=new Array();
			itemInfo.push(description);
			//itemInfo['description']=description;
			dispatchEvent(new GameEvent(itemInfo, GameEvent.MOUSE_OVER_SHOP_ITEM));
		}
		
		public function setMouseOnLook(){
			this.alpha=1;
			//this.scaleX=1.1;
			//this.scaleY=1.1;
		}
		
		public function setDescription(inStr:String){
			//if (inStr=="") return;
			description=inStr;
		}
		
		
		public function setAsSaleItem(price:int){
			if (price<1) return;
			perkPriceLabel.text=price+"$";
		}
		
		/**
		sets item as perk slot that is located in front of others
		*/
		
		public function setAsPerkSlot(){
			perkPriceLabel.text="";
			perkPriceLabel.visible=false;
			perkSlot=true;
		}
		
		public function setAsLocked(){
			perkPriceLabel.text="";
			perkPriceLabel.visible=false;
			//perkSlot=false;
			locked=true;
		}
		
		public function hidePriceLabel(){
			perkPriceLabel.visible=false;
		}
		
		/**
		if perk is bought price tag becomes perk name label
		*/
		
		public function setPerkName(perkName:String){
			perkPriceLabel.visible=true;
			perkPriceLabel.text=perkName;
		}

		
		public function setupPerk(perkId:int,picture:String){
			this.perkId=perkId;
			this.bitmapLink=picture;
		}
		
		public function setAsUnavailable(){
			this.alpha=0.4;
			locked=true;
		}
		
		
		
	}
	
}
