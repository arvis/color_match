package
{
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.display.DisplayObject;

	public class Preloader extends MovieClip
	{
		public function Preloader(){
			trace("start loader");
			this.addEventListener(Event.ENTER_FRAME, loading);
		}

		public function setLoaderInfo(ldrInf:LoaderInfo):void
		{

		}

/*
		private function onProgress(e:ProgressEvent):void
		{
			var percent:int = Math.round(e.bytesLoaded / e.bytesTotal * 100);
			progressBar.width = percent / 100 * progressArea.width;
			percentageText.text = percent + "%";
		}
*/




		function loading(e:Event):void {
		
			trace("loading");
			var total:Number = this.stage.loaderInfo.bytesTotal;
			var loaded:Number = this.stage.loaderInfo.bytesLoaded;
			
			trace("loaded "+loaded+" total "+total);
			var loading_percents:int=Math.floor((loaded/total)*100);
		
			//bar_mc.scaleX = loaded/total;
			//loader_txt.text = loading_percents + "%";
		
			if (total == loaded) {
				//play();
				//this.gotoAndPlay(2);
				trace("page loaded");
				this.removeEventListener(Event.ENTER_FRAME, loading);
				dispatchEvent(new Event(Event.COMPLETE));
				//this.parent.removeChild(this);

				
			}
		
		}




		private function onComplete(e:Event):void
		{
			dispatchEvent(e);
		}
	}
}