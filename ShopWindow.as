package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class ShopWindow extends MovieClip {
		
		const EMPTY_FRAME:int=1;
		const LOCKED_FRAME:int=2;
		const FAST_FORWARD_PERK:int=3;
		const BUY_FRAME:int = 4;
		private var perk1:int = 0;
		private var perk2:int = 0;
		private var perkList:String = "";
		var userCoins:int = 0;
		
		public const DEFAULT_DESCRIPTION:String="Šajā logā Jūs varat izvēlēties superspēkus. Pārbrauciet ar peli, lai parādītos apraksts par to. Noklikšķiniet lai iegādātos vai aktivizētu, ja superspēks jau ir iegādāts.";
		
		
		public function ShopWindow(perk1:int = 0, perks:String = "",coins:int=0 ) {
			this.perk1 = perk1;
			this.perk2 = 0;
			perkList = perks;
			userCoins = coins;
			
			setDefaultView();
			
			closeButton.addEventListener(MouseEvent.CLICK, onCloseWindow);


/*
			var i:int=1;
			for (i=1;i<5;i++){
				this.getChildByName("perk"+i)
			}
*/			
			
			
			//var asd:SpecialItem=new SpecialItem();
			//this.addChild(asd);
/*			
			asd.x=10;
			asd.y=10;
			asd.setDescription("Lai varētu lietot papildiespējas, no sākuma nepieciešams atslēgt papildiespēju logus. Pirmo papildiespēju var atslēgt samaksājot 10 monētas.");
			asd.addEventListener(GameEvent.MOUSE_OVER_SHOP_ITEM, onMouseOverItem);
			asd.setPerkName("");
*/		
			//specialOne.setDescription("Lai varētu lietot papildiespējas, no sākuma nepieciešams atslēgt papildiespēju logus. Pirmo papildiespēju var atslēgt samaksājot 10 monētas.");
			//specialOne.setPerkName("");
			//specialTwo.setPerkName("Uzrāviens");
			//specialTwo.setDescription("Dod 2x vairāk punktus par katru plaukšķi. Darbojas līdz 6. līmenim ieskaitot. Tiek dots par brīvu, atslēdzot pirmo papildiespēju.");
			//specialTwo.setUnAvailable();
			//specialOne.addEventListener(GameEvent.MOUSE_OVER_SHOP_ITEM, onMouseOverItem);
			
			
		}
		
		
		private function setDefaultView(){
			itemDescription.text=DEFAULT_DESCRIPTION;
			
			perkSlotOne.gotoAndStop(BUY_FRAME);
			perkSlotOne.setDescription("Lai varētu lietot superspēkus, no sākuma nepieciešams atslēgt superspēka logus. Pirmo superspēku var atslēgt samaksājot 10 monētas.");
			perkSlotOne.addEventListener(GameEvent.MOUSE_OVER_SHOP_ITEM, onMouseOverItem);
			perkSlotOne.addEventListener(GameEvent.SHOP_ITEM_SELECTED, onClickItem);

			perkSlotTwo.gotoAndStop(LOCKED_FRAME);
			perkSlotTwo.setDescription("Pagaidām nav pieejams.");
			perkSlotTwo.addEventListener(GameEvent.MOUSE_OVER_SHOP_ITEM, onMouseOverItem);
			
			perkOne.gotoAndStop(FAST_FORWARD_PERK);
			perkOne.setDescription("Par katru plaukši tiek doti 2x vairāk punkti. Superspēks darbojas līdz 6. līmenim ieskaitot un tiek dots par brīvu aktivizējot pirmo superspēku.");
			perkOne.addEventListener(GameEvent.MOUSE_OVER_SHOP_ITEM, onMouseOverItem);
			perkOne.addEventListener(GameEvent.SHOP_ITEM_SELECTED, onClickItem);
			
			perkTwo.gotoAndStop(LOCKED_FRAME);
			perkTwo.setDescription("Pagaidām nav pieejams.");
			perkTwo.addEventListener(GameEvent.MOUSE_OVER_SHOP_ITEM, onMouseOverItem);
			
			perkThree.gotoAndStop(LOCKED_FRAME);
			perkThree.setDescription("Pagaidām nav pieejams.");
			perkThree.addEventListener(GameEvent.MOUSE_OVER_SHOP_ITEM, onMouseOverItem);
			
			perkFour.gotoAndStop(LOCKED_FRAME);
			perkFour.setDescription("Pagaidām nav pieejams.");
			perkFour.addEventListener(GameEvent.MOUSE_OVER_SHOP_ITEM, onMouseOverItem);
			
		}
		
		private function onMouseOverItem(evt:GameEvent){
			itemDescription.text=evt.gameData[0] ;
		}
		
		private function onClickItem(evt:MouseEvent){
			
		}
		
		private function onCloseWindow(evt:MouseEvent){
			trace("closing off");
			this.parent.removeChild(this);
		}
		
		
		
	
	
	}
	
}
