package zygame.utils;

import flash.display.Stage;

/**
	 * 一种模仿PCSX2的跳帧策略，可跳过某些帧来获取更多的性能。
	 */
class AutoSkipUtils
{
    public var maxSkipFrameCount(never, set) : Int;
    public var minDarwFrameCount(never, set) : Int;

    private var lastTimer : Int;
    private var deadLine : Int;
    private var minContiguousFrames : Int;
    private var maxContiguousSkips : Int;
    private var framesRendered : Int;
    private var framesSkipped : Int;
    
    /**
     * 
     * @param stage 舞台对象
     * @param deadLineRate 当两次调用之间时差高于标准值多少开始跳帧，推荐1.2以上
     * @param minContiguousFrames  进行跳帧前最少连续渲染了多少帧，推荐1以上
     * @param maxContiguousSkips  最多可以连续跳过的帧数，推荐1
     * 
     */
    public function new(stage:Stage, deadLineRate:Float = 1.20, minContiguousFrames:Int = 1, maxContiguousSkips:Int = 1)
    {
        this.lastTimer = 0;
        this.deadLine = Math.ceil((1000 / stage.frameRate) * deadLineRate);
        this.minContiguousFrames = minContiguousFrames;
        this.maxContiguousSkips = maxContiguousSkips;
        framesRendered = 0;
        framesSkipped = 0;
    }

    /**
     * 设置最大可跳过的帧数
     * @param fps 帧
     */
    private function set_maxSkipFrameCount(fps : Int) : Int
    {
        this.maxContiguousSkips = fps;
        return fps;
    }
    
    /**
     * 设置最少连续渲染多少帧
     * @param fps 帧
     */
    private function set_minDarwFrameCount(fps : Int) : Int
    {
        this.minContiguousFrames = fps;
        return fps;
    }
    
    /**
     * 使用该方法检验游戏是否需要跳帧
     */
    public function requestFrameSkip():Bool
    {
        var rt:Bool = false;
        var timer:Int = Math.round(haxe.Timer.stamp() * 1000);
        var dtTimer:Int = Std.int(timer - lastTimer);
        if (dtTimer > deadLine && framesRendered >= minContiguousFrames && framesSkipped < maxContiguousSkips)
        {
            //如果满足一系列条件才能批准跳帧
            rt = true;
            framesRendered = 0;
            framesSkipped += 1;
        }
        else
        {
            framesSkipped = 0;
            framesRendered += 1;
        }  //end if  
        lastTimer = timer;
        return rt;
    }
}