import zygame.display.DisplayObjectContainer;
import starling.display.Image;
import zygame.core.GameCore;

class GameSprite extends DisplayObjectContainer
{

    private var bg:Image;

    public function new(){
        super();
    }

    override public function onInit():Void
    {   
        super.onInit();
        bg = new Image(GameCore.getTexture("icon"));
        bg.alignPivot();
        bg.width = 50;
        bg.height = 50;
        this.addChild(bg);
    }

    override public function onFrame():Void
    {
        super.onFrame();
        bg.rotation ++;
        
    }
}