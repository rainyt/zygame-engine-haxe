package zygame.display;

import zygame.display.BodyDisplayObject;
import zygame.data.EffectData;
import zygame.display.BaseRole;
import zygame.utils.FPSUtil;
import zygame.utils.ZYMath;
import zygame.data.HitDatas;
import zygame.data.HitBody;
import zygame.data.SpriteFrameData;

/**
 *  实现技能显示（精灵表特效）
 */
class EffectDisplayObject extends BodyDisplayObject {

    public var effectData:EffectData;

    public var role:BaseRole;

    public var frame:Int = 0;

    public var fps:FPSUtil;

    /**
     *  攻击数据整理
     */
    private var _hitDatas:HitDatas;
    private var _hitBody:HitBody;

    public function new(id:String,data:EffectData,role:BaseRole = null){
        super();
        this.targetName = id;
        this.effectData = data;
        fps = new FPSUtil(this.effectData.fps());
        if(fps.fps == -1 && role != null)
            fps.fps = role.fps.fps;
        this.role = role;
        _hitDatas = new HitDatas(this.role);
    }

    override public function onInit():Void
    {
        this.scaleX *= this.role.scaleX;
        this.posx = this.role.posx + effectData.x() * role.scaleX;
        this.posy = this.role.posy + effectData.y();
        this.addToParentFrameEvents();
        this.rotation = ZYMath.deg2rad(effectData.rotation()) * (this.scaleX > 0?1:-1);
    }

    override public function onFrame():Void
    {
        if(fps.update())
        {
            frame ++;
            onDraw();
        }
    }

    /**
     *  用于计算碰撞数据，不同的绘制都可能会有自已独有的数据读取方式，因此请额外自已实现
     *  @param id - 该帧独立id
     *  @param arr - 该帧的碰撞坐标
     */
    public function onHitData(frameData:SpriteFrameData):Void
    {
        if(frameData.hitPoint == null)
            return;
        frameData.updateBeHitData(effectData);
        var hitBody:HitBody = _hitDatas.getHitBody(frameData.id,frameData.beHitData,frameData.hitPoint);
        if(hitBody != _hitBody)
        {
            if(_hitBody != null)
            {
                _hitBody.body.space = null;
                _hitBody = null;
            }
            if(hitBody != null)
            {
                _hitBody = hitBody;
                _hitBody.body.space = world.nape;
            }
        }
        if(_hitBody != null)
        {
            _hitBody.body.position.x = this.x;
            _hitBody.body.position.y = this.y;
            _hitBody.setScaleX(this.scaleX>0?1:-1);
            role.onHitArbiter(_hitBody);
        }
        
    }

    /**
     *  绘制图形
     */
    public function onDraw():Void
    {

    }

    /**
     *  释放
     */
    override public function dispose():Void
    {
        super.dispose();
        if(_hitBody != null)
        {
            _hitBody.body.space = null;
        }
        role = null;
        fps = null;
        _hitBody = null;
        _hitDatas = null;
    }
}