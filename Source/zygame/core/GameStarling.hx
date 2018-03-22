package zygame.core;

import openfl.display.Stage;
import openfl.display.Stage3D;
import openfl.geom.Rectangle;
import starling.core.Starling;
import zygame.utils.AutoSkipUtils;
import zygame.utils.FPSUtil;
import zygame.core.CoreStarup;

/**
 *  实现压力跳帧处理，需要isSkinFrame为true时发生。
 */
class GameStarling extends Starling
{
    public var fps(never, set) : Int;

    /**
     *  自动跳帧，如果FPS降低了，那么这个可以为游戏减轻渲染上的压力，避免了低可能假死的情况，但如果FPS下降得太厉害，这个也是于事无补。
     */
    public var autoSkip:AutoSkipUtils;
    
    /**
     *  渲染计算器
     */
    private var _fps:FPSUtil;
    
    /**
     *  实现了跳帧逻辑
     *  @param rootClass - 主逻辑类
     *  @param stage - 舞台
     *  @param viewPort - 可见视窗
     *  @param stage3D - stage3d
     *  @param renderMode - 渲染模式
     *  @param profile - 渲染配置
     */
    public function new(rootClass : Class<Dynamic>, stage : Stage, viewPort : Rectangle = null, stage3D : Stage3D = null, renderMode : String = "auto", profile : Dynamic = "baselineConstrained")
    {
        if(stage3D == null)
            stage3D = stage.stage3Ds[0];
        super(rootClass, stage, viewPort, stage3D, renderMode, profile);
        autoSkip = new AutoSkipUtils(stage, 2);
        trace("GameStarling start");
        _fps = new FPSUtil(60);
    }

    /**
     *  固定字体的尺寸比例
     *  @return Float
     */
    override public function get_contentScaleFactor():Float
    {
        return 3;
    }
    
    /**
     *  实现渲染跳帧逻辑
     */
    override public function render() : Void
    {
        #if flash
         //如果进行跳帧逻辑，那么就开始计算逻辑
        if (CoreStarup.getInstance().isSkinFrame && autoSkip.requestFrameSkip())
        {
            return;
        }
        //进行FPS计算，如果为30时，就会自动渲染
        if (CoreStarup.getInstance().stage.frameRate == 30 || _fps.update())
        {
            super.render();
        }
        #else
        super.render();
        #end
    }
    
    private function set_fps(i : Int) : Int
    {
        _fps.fps = i;
        return i;
    }
    
}