package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Point;
	
	public class Enemy extends MovieClip {
		
		private var id:int;
		private var stageInstance:Stage;
		
		public function Enemy(_stageInstance:Stage, position:Point) {
			// constructor code
			this.stageInstance = _stageInstance;
			id = getNumber(1,1000);
			spawn(position);
		}
		private function getNumber(minInt:int, maxInt:int):int{
			return(Math.floor(Math.random() * (maxInt - minInt + 1)) + minInt);
		}
		
		public function getID():int{
			return(id);
		}
		
		private function spawn(position:Point):void{
			stageInstance.addChild(this);
			this.x = position.x;
			this.y = position.y;
		}
	}
}
