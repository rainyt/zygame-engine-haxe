package zygame.data;

import nape.geom.Vec2;
import zygame.utils.NapeUtils;
import zygame.data.BeHitData;
import zygame.data.FrameData;
import zygame.data.SpriteData;
import zygame.data.EffectData;

/**
 *  角色帧数据
 */
class SpriteFrameData extends FrameData{
    
    /**
     *  碰撞块
     */
    public var hitPoint:Array<Vec2>;

    /**
     *  碰撞数据
     */
    public var beHitData:BeHitData;

    /**
     *  唯一ID
     */
    public var id:String;

    public function new(group:SpriteData,xml:Xml)
    {
        super();
        id = xml.get("name");
        var hitPointData:String = xml.get("hitPoint");
        if(hitPointData != null)
        {
            hitPoint = NapeUtils.parsingPoint(hitPointData);
        }
        var hitEffect:String = xml.get("hitEffect");
        var hurtInterval:String = xml.get("hurtInterval");
        beHitData = new BeHitData(this);
        beHitData.hitEffect = hitEffect!=null?Std.parseInt(hitEffect):0;
        beHitData.hitInterval = hurtInterval!=null?Std.parseInt(xml.get("hurtInterval")):0;
        at = group.frames.length;
    }

    /**
     *  更新特效的攻击数据
     *  @param data - 
     */
    public function updateBeHitData(data:EffectData):Void
    {
        beHitData.hitX = data.hitX();
        beHitData.hitY = data.hitY();
        beHitData.straight = data.straight();
    }

}