
import starling.display.Sprite;
import zygame.core.GameCore;
import zygame.events.GameCoreEvent;

@:keep() class GameMain extends Sprite
{

    public function new(){
        super();
        trace("GameMain inited!");
        GameCore.currentCore.addEventListener(GameCoreEvent.INIT_COMPLETE,onInitComplete);
    }

    public function onInitComplete(e:GameCoreEvent):Void
    {
        trace("回调：！");
        // var game:Game = new Game();
        // this.addChild(game);
        // GameCore.roleManager.enqueue(["suixing"]);
        GameCore.mapManager.loadMap("tmx/zx0.tmx",function(num:Float):Void{
            trace("地图载入："+Std.int(num * 100)+"%");
            if(num == 1)
            {
                var game:Game = new Game();
                this.addChild(game);
            }
        },null);
        // GameCore.roleManager.loadQueue(function(pro:Float):Void{
        //     trace("角色载入：",Std.int(pro*100)+"%");
        //     if(pro == 1)
        //     {
        //         var game:Game = new Game();
        //         addChild(game);
        //     }
        // });
    }
}