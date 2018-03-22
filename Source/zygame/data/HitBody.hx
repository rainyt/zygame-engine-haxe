package zygame.data;

import nape.phys.Body;
import zygame.data.BeHitData;

/**
 *  碰撞身体
 */
class HitBody {
    
    public var body:Body;

    public var beHitData:BeHitData;

    private var _scaleX:Int = 1;
    
    public function new(body:Body,data:BeHitData){
        this.body = body;
        this.body.userData.ref = this;
        this.beHitData = data;
    }

    /**
     *  设置Body的方向
     *  @param i - 值必须为-1和1，只做翻转
     */
    public function setScaleX(i:Int):Void
    {
        if(i != _scaleX)
        {
            _scaleX = i;
            body.scaleShapes(-1,1);
        }
    }
}