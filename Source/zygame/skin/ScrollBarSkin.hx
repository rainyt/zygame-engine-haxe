package zygame.skin;

import starling.textures.Texture;
import openfl.geom.Rectangle;

/**
 *  滚动轮的Skin配置
 */
class ScrollBarSkin {

    public var bgSkin:Texture;

    public var moveSkin:Texture;

    public var bgS9Rect:Rectangle;

    public var moveS9Rect:Rectangle;

    public function new(bgSkin:Texture,moveSkin:Texture,bgSkinS9rect:Rectangle = null,moveSkinS9rect:Rectangle = null)
    {
        this.bgSkin = bgSkin;
        this.moveSkin = moveSkin;
        this.bgS9Rect = bgSkinS9rect;
        this.moveS9Rect = moveSkinS9rect;
    }

}