package zygame.data;

import starling.textures.Texture;
import starling.textures.TextureAtlas;
import openfl.Vector;
import zygame.core.GameCore;
import zygame.data.SpriteFrameData;

/**
 *  精灵表的数据
 */
class SpriteData{

    public var xmlData:Xml;
    public var textureAtlas:TextureAtlas;
    public var textures:Vector<Texture>;
    public var frames:Array<SpriteFrameData>;

    public function new(id:String,xml:Xml){
        xmlData = xml;
        textureAtlas = GameCore.roleManager.roleAssets.getTextureAtlas(id);
        textures = textureAtlas.getTextures();
        frames = [];
        var childs:Iterator<Xml> = xml.elements();
        while(childs.hasNext())
        {
            var frame:Xml = childs.next();
            frames.push(new SpriteFrameData(this,frame));
        }
    }

}