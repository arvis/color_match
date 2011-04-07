/* Customizable  AS3 Tooltip */
/* Developed by Carlos Yanez */

package 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;

	public class Tooltip extends Sprite
	{
		/* Vars */

		var tween:Tween;

		var tooltip:Sprite = new Sprite();
		var bmpFilter:BitmapFilter;

		var textfield:TextField = new TextField();
		var textformat:TextFormat = new TextFormat();
		//var font:Harmony = new Harmony();
		var font:mainFont=new mainFont();

		public function Tooltip(w:int, h:int, cornerRadius:int, txt:String, color:uint, txtColor:uint, alfa:Number, useArrow:Boolean, dir:String, dist:int):void
		{
			/* TextField and TextFormat Properties */

			textfield.selectable = false;

			textformat.align = TextFormatAlign.CENTER;
			textformat.font = font.fontName;
			textformat.size = 12;
			
			textformat.color = txtColor;

			textfield = new TextField();
			textfield.embedFonts = true;
			textfield.width = w;
			textfield.height = h;
			textfield.defaultTextFormat = textformat;
			textfield.text = txt;

			/* Create tooltip */

			tooltip = new Sprite();

			tooltip.graphics.beginFill(color, alfa);
			tooltip.graphics.drawRoundRect(0, 0, w, h, cornerRadius, cornerRadius);

			if (useArrow && dir == "up")
			{
				tooltip.graphics.moveTo(tooltip.width / 2 - 6, tooltip.height);
				tooltip.graphics.lineTo(tooltip.width / 2, tooltip.height + 4.5);
				tooltip.graphics.lineTo(tooltip.width / 2 + 6, tooltip.height - 4.5);
			}

			if (useArrow && dir == "down")
			{
				tooltip.graphics.moveTo(tooltip.width / 2 - 6, 0);
				tooltip.graphics.lineTo(tooltip.width / 2, -4.5);
				tooltip.graphics.lineTo(tooltip.width / 2 + 6, 0);
			}

			tooltip.graphics.endFill();

			/* Filter */

			bmpFilter = new DropShadowFilter(1,90,color,1,2,2,1,15);

			tooltip.filters = [bmpFilter];

			/* Add to Stage */

			tooltip.addChild(textfield);

			addChild(tooltip);

			tween = new Tween(tooltip,"alpha",Strong.easeOut,0,tooltip.alpha,1,true);
		}
	}
}