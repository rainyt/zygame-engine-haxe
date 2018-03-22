package zygame.data;

import zygame.data.FrameData;

/**
 *  攻击数据
 */
class BeHitData {
    
    /**
     *  击退值
     */
    public var hitX:Float = 0;

    /**
     *  击飞值
     */
    public var hitY:Float = 0;

    /**
     * 物理伤害百分比，以1为100% 
     */
    public var armorScale : Float = 1;
    
    /**
     * 魔法伤害百分比，以1为100% 
     */
    public var magicScale : Float = 0;

    /**
     *  僵直
     */
    public var straight:Int;

    /**
     *  攻击有效帧
     */
    public var hitEffect:Int = 0;

    /**
     *  攻击间隔，0为1次。
     */
    public var hitInterval:Int = 0;

    /**
     *  帧数据
     */
    public var frame:FrameData;

    public function new(frame:FrameData){
        this.frame = frame;
    }

    public function activationMinFrame():Int
    {
        return frame.at;
    }

    public function activationMaxFrame():Int
    {
        return activationMinFrame() + hitEffect;
    }

    public function copy(data:BeHitData):Void
    {
        this.hitX = data.hitX;
        this.hitY = data.hitY;
        this.straight = data.straight;
        this.frame = data.frame;
        this.armorScale = data.armorScale;
        this.magicScale = data.magicScale;
        this.hitEffect = data.hitEffect;
    }

}