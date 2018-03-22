package zygame.display;

import zygame.display.BaseRole;
import starling.display.Image;
import starling.textures.TextureAtlas;
import zygame.core.GameCore;
import openfl.geom.Point;
import zygame.data.RoleAttributeData;

/**
 *  精灵角色绘制
 */
class SpriteRole extends BaseRole
{  
    /**
     *  显示对象
     */
    private var display:Image;
    
    /**
     *  显示图文集
     */
    private var textures:TextureAtlas;

    /**
     *  图文偏移坐标
     */
    private var offestPoint:Point;

    public function new(roleTarget : String, xz : Float, yz : Float, pworld : World, fps : Int = 24, pscale : Float = 1, troop : Int = -1, roleAttr : RoleAttributeData = null)
    {
        super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
        textures = GameCore.roleManager.roleAssets.getTextureAtlas(roleTarget);
        display = new Image(textures.getTextures()[0]);
        this.addChild(display);
        //获取图文集的坐标偏移位置
        var currentXml:Xml = GameCore.roleManager.roleAssets.getXml(roleTarget);
        offestPoint = new Point();
        offestPoint.x = Std.parseFloat(currentXml.get("px"));
        offestPoint.y = Std.parseFloat(currentXml.get("py"));
        // this.debug();
    }

    /**
     *  精灵角色绘制
     */
    override public function onDraw():Void
    {
        super.onDraw();
        if(this.actionGroup == null)
        {
            return;
        }
        display.texture = textures.getTexture(this.currentFrame().textureName);
        display.x = offestPoint.x;
        display.y = offestPoint.y;
    }
}