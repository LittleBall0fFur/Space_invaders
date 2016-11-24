package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	import flash.text.*;
	
	public class SpaceInvaders extends MovieClip {
		private var enemies:Array = new Array();
		private var bullets:Array = new Array();
		private var player:Player = new Player();
		private var banner:Death = new Death();
		private var movingLeft:Boolean = false;
		
		private var life:int = 3;
		private var textLife:TextField = new TextField();
		private var speed:int = 2;
		
		private var numberOfEnemies = 3;
		private var positionY:int = 100;
		private var positionX:int = 150;
		private var leftBorder:int = 70;
		private var rightBorder:int = 480;
		
		private var left:Boolean = false;
		private var right:Boolean = false;
		private var shoot:Boolean = false;
		
		public function SpaceInvaders(){
			addEventListener(Event.ENTER_FRAME, Update);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyCheckUp);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyCheckDown);
			
			player.x = 250;
			player.y = 290;
			this.stage.addChild(player);
			spawnEnemies();
			
			var myIndetifier:Timer = new Timer(3000, 0);
			myIndetifier.addEventListener(TimerEvent.TIMER, enemyShoots);
			myIndetifier.start();
		}
		
		private function enemyShoots (enemyShoots:TimerEvent):void{
			if(enemies.length > 0){
				var pointer:int = randomRange(0, enemies.length - 1);
				var myPoint:Point = new Point();
				myPoint.x = enemies[pointer].x;
				myPoint.y = enemies[pointer].y + 10;
				addEnemieBullet(myPoint);	
			}
		}
		
		private function Update(e:Event):void{
			movePlayer();			
			moveOther();
			Collision();
			addLifeTxt();
			player.x > leftBorder;
			player.x < rightBorder;
			
			if(numberOfEnemies > 11){
				numberOfEnemies = 11;
			}
			if(enemies.length == 0){
				numberOfEnemies += 1;
				positionX = 100;
				positionY = 50;
				spawnEnemies();	
			}
		}
		
		
		private function spawnEnemies(){
			for (var loop:int = 0; loop < numberOfEnemies; loop++){
				addEnemy();
			}
		}
		
		private function addEnemy():void{
			if(enemies.length == 4 || enemies.length == 8 || enemies.length == 12){
				positionY += 100;
				positionX = 100;
			}
			var position:Point = new Point(positionX, positionY);
			positionX += 100;
			enemies.push(new Enemy(this.stage, position));
		}
		
		private function addEnemieBullet(position:Point):void{
			bullets.push(new Bullet(false, position, this.stage));
		}
		
		private function addBullet():void{
			var myPoint:Point = new Point();
			myPoint.x = player.x;
			myPoint.y = player.y - 10;
			bullets.push(new Bullet(true, myPoint, this.stage));
		}
		
		private function removeEnemy(id:int):void{
			for each(var currentEnemie:Enemy in enemies){
				if(currentEnemie.getID() == id){
					this.stage.removeChild(currentEnemie);
					enemies.splice(enemies.indexOf(currentEnemie) ,1);
				}
			}
		}
		
		private function removeBullet(id:int):void{
			for each(var currentBullet:Bullet in bullets){
				if(currentBullet.getID() == id){
					this.stage.removeChild(currentBullet);
					bullets.splice(bullets.indexOf(currentBullet), 1);
				}
			}
		}
		
		private function movePlayer():void{
			if(left == true && player.x > leftBorder){
				player.x -= speed;
			}
			if(right == true && player.x < rightBorder){
				player.x +=speed;
			}
			if(shoot == true){
				addBullet();
				shoot = false;
			}
			speed += 1.9;
		}
		
		private function moveOther():void{
			for each(var currentBullet:Bullet in bullets){
				if(currentBullet.isOwner()){
					currentBullet.y -= 10;
					if(currentBullet.y <= 0){
						removeBullet(currentBullet.getID());
					}
				}
				else{
					currentBullet.y += 10;
					if(currentBullet.y >= 400){
						removeBullet(currentBullet.getID());
					}
				}
			}
			
			//movement enemies
			if(movingLeft){
				if(enemies[0].x <= 50){
					movingLeft = false;
					for each(var currentEnemy:Enemy in enemies){
						currentEnemy.y += 10;				
					}
				}
				else{
					for each(var currentEnemy2:Enemy in enemies){
						currentEnemy2.x -= 2;				
					}
				}
			}
			else{
				for each (var enemyEastBorder:Enemy in enemies){
					if(enemyEastBorder.x >= 480){
						movingLeft = true;
						for each(var currentEnemy4:Enemy in enemies){
							currentEnemy4.y += 10;				
						}
					}
					else{
						enemyEastBorder.x += 2;
					}
				}
			}		
		}
		
		private function Collision():void{
			for each(var currentBullet:Bullet in bullets){
				if(currentBullet.isOwner()){
					for each(var currentEnemie:Enemy in enemies){
						if(currentBullet.hitTestObject(currentEnemie)){
							removeEnemy(currentEnemie.getID());
							removeBullet(currentBullet.getID());
						}
					}
				}
				else{
					if(currentBullet.hitTestObject(player)){
						if(life >= 1){
							life--;
							removeBullet(currentBullet.getID());
						}
					}
			    		else if(life  <= 0){
						//game over
						death();
						trace('game over');
					}
				}
			}
			for each(var currentEnemy:Enemy in enemies){
				if(currentEnemy.hitTestObject(player)){
					trace('game over');
					death();
				}
			}
		}
		
		private function randomRange(minNum:int, maxNum:int):int{
			return (Math.floor(Math.random() * (maxNum - minNum +1)) + minNum);
		}
		
		private function keyCheckUp(event:KeyboardEvent):void {
			speed = 2;
			switch(event.keyCode){
				case Keyboard.LEFT :
					left = false;
					break;
				
				case Keyboard.RIGHT :
					right = false;
					break;
				
				case Keyboard.SPACE :
					shoot = false;
					break;
				
				default :
					break;
			}
		}
		
		private function keyCheckDown(event:KeyboardEvent):void {
			switch(event.keyCode){
				case Keyboard.LEFT :
					left = true;
					break;
				
				case Keyboard.RIGHT :
					right = true;
					break;
				
				case Keyboard.SPACE :
					shoot = true;
					break;
				
				default :
					break;
			}
		}
		private function death():void{
			if(life == 0){
				this.stage.removeEventListener(KeyboardEvent.KEY_UP, keyCheckUp);
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyCheckDown);
				player.x = stage.width/2;
				this.stage.addChild(banner);
				banner.y = stage.height/2;
			}
			else if(enemies[enemies.length - 1].y >= player.y){
				this.stage.removeEventListener(KeyboardEvent.KEY_UP, keyCheckUp);
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyCheckDown);
				this.stage.addChild(banner);
				banner.y = stage.height/2;
			}
		}
		public function addLifeTxt():void{
			var myFormat:TextFormat = new TextFormat();
			var font1:Font1 = new Font1();
			textLife.x = 10;
			textLife.y = 10;
			textLife.width = 500;
			myFormat.size = 20;
			myFormat.font = font1.fontName;
			textLife.defaultTextFormat = myFormat;
			textLife.embedFonts = true;
			textLife.antiAliasType = AntiAliasType.ADVANCED;
			textLife.text = "Lives: "+ life;
			if(!stage.contains(textLife)){
				addChild(textLife);
			}
		}
	}
}