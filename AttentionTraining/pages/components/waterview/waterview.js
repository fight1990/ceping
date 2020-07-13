// pages/components/waterview.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    randus :  Number,
  },

  /**
   * 组件的初始数据
   */
  data: {
    lastFrameTime :  0,
    Sin : Math.sin,
    Cos : Math.cos,
    Sqrt : Math.sqrt,
    Pow : Math.pow,
    PI : Math.PI,
    Round : Math.round,
    oW : Number,
    oH : Number,
    // 线宽
    lineWidth : Number,
    // 大半径
    r : Number,
    cR : Number,
    // 水波动画初始参数
    axisLength : Number, // Sin 图形长度
    unit : Number, // 波浪宽
    range : Number, // 浪幅
    nowrange : Number,
    xoffset : Number, // x 轴偏移量
    
    data : Number,   // 数据量
    
    sp : Number, // 周期偏移量
    nowdata : Number,
    waveupsp : Number, // 水波上涨速度
    // 圆动画初始参数
    arcStack : [], // 圆栈
    bR : Number,
    soffset : Number, // 圆动画起始位置
    circleLock : true, // 起始动画锁
  },

  /**
   * 组件的方法列表
   */
  methods: {
    onLoad: function () { 
      const ctx = wx.createCanvasContext('canvasArcCir');
      this.wave(ctx, 200);
    },

    dataInit : function(oRang) {

      oW =  150;
      oH =  150;
      // 线宽
      ineWidth = 2;
      // 大半径
      r = (oW / 2);
      cR = r - 10 * lineWidth;
    
      // 水波动画初始参数
      axisLength = 2 * r - 16 * lineWidth;  // Sin 图形长度
      unit = axisLength / 9; // 波浪宽
      range = .4 // 浪幅
      nowrange = range;
      xoffset = 8 * lineWidth; // x 轴偏移量
      
      data = ~~(oRange) / 100;   // 数据量
      
      sp = 0; // 周期偏移量
      nowdata = 0;
      waveupsp = 0.006; // 水波上涨速度
      // 圆动画初始参数
      arcStack = [];  // 圆栈
      bR = r - 8 * lineWidth;
      soffset = -(PI / 2); // 圆动画起始位置
      circleLock = true; // 起始动画锁
    },

    wave : function (ctx, oRange){
      this.dataInit(oRange);

      ctx.beginPath();
      ctx.lineWidth = lineWidth;
      
      // 获取圆动画轨迹点集
      for (var i = soffset; i < soffset + 2 * PI; i += 1 / (8 * PI)) {
        arcStack.push([
          r + bR * Cos(i),
          r + bR * Sin(i)
        ])
      }
      // 圆起始点
      var cStartPoint = arcStack.shift();
      ctx.strokeStyle = "#1c86d1";
      ctx.moveTo(cStartPoint[0], cStartPoint[1]);
      // 开始渲染
      render();
    },

    drawSine : function() {
      ctx.beginPath();
      ctx.save();
      var Stack = []; // 记录起始点和终点坐标
      for (var i = xoffset; i <= xoffset + axisLength; i += 20 / axisLength) {
        var x = sp + (xoffset + i) / unit;
        var y = Sin(x) * nowrange;
        var dx = i;
        var dy = 2 * cR * (1 - nowdata) + (r - cR) - (unit * y);
        ctx.lineTo(dx, dy);
        Stack.push([dx, dy])
      }
      // 获取初始点和结束点
      var startP = Stack[0]
      var endP = Stack[Stack.length - 1]
      ctx.lineTo(xoffset + axisLength, oW);
      ctx.lineTo(xoffset, oW);
      ctx.lineTo(startP[0], startP[1])
      ctx.fillStyle = "#4BEF8B";
  
      ctx.fill();
      ctx.restore();
    },
      
    drawText : function() {
        ctx.globalCompositeOperation = 'source-over';
        var size = 0.4 * cR;
        ctx.font = 'bold ' + size + 'px Microsoft Yahei';
        var number = (nowdata.toFixed(2) * 100).toFixed(0);
        var txt = number+ '%';
        var fonty = r + size / 2;
        var fontx = r - size * 0.8;
        
        if (number >= 50)
        {
          ctx.fillStyle = "#FFFFFF";
        }
        else{
          ctx.fillStyle = "#38D560";
        }
        ctx.textAlign = 'center';
        ctx.fillText(txt, r + 5, r + 20)
      },

      //最外面淡色圈
      drawCircle : function() {
        ctx.beginPath();
        ctx.lineWidth = 15;
        ctx.strokeStyle = '#fff89d';
        ctx.arc(r, r, cR + 7, 0, 2 * Math.PI);
        ctx.stroke();
        ctx.restore();
      },

      //灰色圆圈
      grayCircle : function() {
        ctx.beginPath();
        ctx.lineWidth = 2;
        ctx.strokeStyle = '#7ce99e';
        ctx.arc(r, r, cR - 8, 0, 2 * Math.PI);
        ctx.stroke();
        ctx.restore();
        ctx.beginPath();
      },

      //橘黄色进度圈
      orangeCircle : function() {
        ctx.beginPath();
        ctx.strokeStyle = '#fbdb32';
        //使用这个使圆环两端是圆弧形状
        ctx.lineCap = 'round';
        ctx.arc(r, r, cR - 5, 0 * (Math.PI / 180.0) - (Math.PI / 2), (nowdata * 360) * (Math.PI / 180.0) - (Math.PI / 2));
        ctx.stroke();
        ctx.save()
      },
      //裁剪中间水圈
      clipCircle : function() {
        ctx.beginPath();
        ctx.arc(r, r, cR - 10, 0, 2 * Math.PI, false);
        ctx.clip();
      },
      //渲染canvas
      render : function() {
        abortAnimationFrame(tid);
  
        ctx.clearRect(0, 0, oW, oH);
        //最外面淡黄色圈
        //drawCircle();
        //灰色圆圈  
        grayCircle();
        //橘黄色进度圈
        //orangeCircle();
        //裁剪中间水圈  
        clipCircle();
        // 控制波幅
        //oRange.addEventListener("change", function () {
        //  data = ~~(oRange.value) / 100;
        //  console.log("data=" + data)
        //}, 0);
        if (data >= 0.85) {
          if (nowrange > range / 4) {
            var t = range * 0.01;
            nowrange -= t;
          }
        } else if (data <= 0.1) {
          if (nowrange < range * 1.5) {
            var t = range * 0.01;
            nowrange += t;
          }
        } else {
          if (nowrange <= range) {
            var t = range * 0.01;
            nowrange += t;
          }
          if (nowrange >= range) {
            var t = range * 0.01;
            nowrange -= t;
          }
        }
        if ((data - nowdata) > 0) {
          nowdata += waveupsp;
        }
        if ((data - nowdata) < 0) {
          nowdata -= waveupsp
        }
        sp += 0.07;
        // 开始水波动画
        drawSine();
        // 写字
        drawText();
    
        ctx.draw();
        
        tid = doAnimationFrame(render);
      },
    
      // 模拟 requestAnimationFrame
      doAnimationFrame : function(callback) {
        var currTime = new Date().getTime();
        var timeToCall = Math.max(0, 16 - (currTime - lastFrameTime));
        var id = setTimeout(function () { callback(currTime + timeToCall); }, timeToCall);
        lastFrameTime = currTime + timeToCall;
        return id;
      },

      // 模拟 cancelAnimationFrame
      abortAnimationFrame : function(id) {
        clearTimeout(id)
      }
  }
})
