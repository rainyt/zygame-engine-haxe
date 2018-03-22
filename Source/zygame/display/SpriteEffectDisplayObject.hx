package zygame.display;

import zygame.display.EffectDisplayObject;
import starling.display.Image;
import zygame.core.GameCore;
import zygame.data.EffectData;
import zygame.display.BaseRole;
import zygame.data.SpriteData;
import zygame.data.SpriteFrameData;

/**
 *  用于处理精灵表渲染的特效
 */
class SpriteEffectDisplayObject extends EffectDisplayObject
{

    public var image:Image;

    public var spriteData:SpriteData;

    public function new(id:String,data:EffectData,role:BaseRole = null){
        super(id,data,role);
        spriteData = GameCore.roleManager.spriteDataManager.getSpriteData(id);
        if(spriteData == null)
        {
            throw "Error: SpriteData is null from "+id;
        }
    }

    override public function onInit():Void
    {
        super.onInit();
        image = new Image(spriteData.textures[0]);
        this.addChild(image);
        image.x = Std.parseFloat(spriteData.xmlData.get("px"));
        image.y = Std.parseFloat(spriteData.xmlData.get("py"));
    }

    override public function onFrame():Void
    {
        super.onFrame();
        if(currentFrame() != null){
            this.onHitData(currentFrame());
        }
    }

    /**
     *  进行绘制显示
     */
    override public function onDraw():Void
    {
        if(frame >= spriteData.textures.length){
            this.removeFromParent(true);
        }
        else
        {
            image.texture = spriteData.textures[frame];
        }
    }

    /**
     *  获取当前帧数据
     *  @return SpriteData
     */
    public function currentFrame():SpriteFrameData
    {
        return spriteData.frames[frame];
    }

}