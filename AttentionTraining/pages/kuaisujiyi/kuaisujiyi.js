// pages/kuaisujiyi/kuaisujiyi.js
var api = require("../../Api/api.js")
const util = require("../../utils/util.js");
const ctxWave = wx.createCanvasContext('canvasArcCir')
const ctxGraph = wx.createCanvasContext('canvasgraph')
const ctxFlow = wx.createCanvasContext('canvasflow')

var valHandle;  //定时器
const ctxTimer = wx.createCanvasContext("bgCanvas")

var tid;
var M = Math;
var Sin = M.sin;
var Cos = M.cos;
var Sqrt = M.sqrt;
var Pow = M.pow;
var PI = M.PI;
var Round = M.round;
var oW =  650.0 / util.getRpx() * 1.0;
var oH =  650.0 / util.getRpx() * 1.0;
// 线宽
var lineWidth = 2;
// 大半径
var r = (oW / 2);
var cR = r - 10 * lineWidth;
ctxWave.beginPath();
ctxWave.lineWidth = lineWidth;
// 水波动画初始参数
var axisLength = 2 * r - 16 * lineWidth;  // Sin 图形长度
var unit = axisLength / 9; // 波浪宽
var range = .4 // 浪幅
var nowrange = range;
var xoffset = 8 * lineWidth; // x 轴偏移量

var data = ~~(100) / 100;   // 数据量

var sp = 0; // 周期偏移量
var nowdata = 0;
var waveupsp = 0.006; // 水波上涨速度
// 圆动画初始参数
var arcStack = [];  // 圆栈
var bR = r - 8 * lineWidth;
var soffset = -(PI / 2); // 圆动画起始位置
var circleLock = true; // 起始动画锁
var lastFrameTime = 0;
var rotateNumber = 0;//旋转度数
var kMaxTime = 5000; //倒计时时间
var timestamp = Date.parse(new Date());  

var constColors = ["Blue","Purple","Yellow","Green","Red"];
/**
 * 0 -- 圆形
 * 3 -- 三角形
 * 4 -- 正方形
 * 5 -- 五角星
 * 6 -- 六边形
 * 8 -- 八边形
 */
var constShapes = [0,3,4,5,6,8];
var gameDatas = [];

var _animation; // 动画实体
var _animationIndex = 0; // 动画执行次数index（当前执行了多少次）
var _animationIntervalId = -1; // 动画定时任务id，通过setInterval来达到无限旋转，记录id，用于结束定时任务
const _ANIMATION_TIME = 5000; // 动画播放一次的时长ms

const _tipContent1 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;形状\n是否与前面相同"
const _tipContent2 = "&nbsp;&nbsp;&nbsp;形状和颜色\n是否与前面相同"




Page({

  /**
   * 页面的初始数据
   */
  data: {
    answerList: Array(65), // 题目总数
    selectedIndex: 0,
    isRead:false, // 判断是否现实游戏页面
    result: 0, // 结果对错 0-错 1-对
    showIntroduce: false, // 显示简介
    count: 4, // 倒计时
    hideBottom: true, // 隐藏底部判断视图
    hideResult: true, // 隐藏结果视图

    rightCount: 0, // 对的题目数量
    globalTimer: 0, //游戏计时器

    canvasContent: _tipContent1,

    hideTipShadow: true, // 是否隐藏继续作答
    hideResultShadow: true, // 是否隐藏结果
    share: false, // 分享之后
    hideThreeShadow: true, // 隐藏 请认真答题弹框
    animationData: {},
    animationRotate: '',

    stepText: 5,  //设置倒计时初始值

    cylinderNumber: 0

  },

  /**
   * 分享
   */
  shareTap: function () {
    var that = this
    wx.navigateTo({
      url: '/pages/analysis/analysis' + "?gameid=" + that.data.gameid + "&isShare=1",
    })
    that.data.share = false
  },
  
  /**
   * 关闭结果弹框
   */
  cancelResultTap: function () {
    var that = this
    that.setData({
      hideResultShadow: true,
    })

  },

  /**
  * 显示结果弹框
  */
  showResultTap: function () {
    var that = this
    that.setData({
      hideResultShadow: false,
    })

  },

  /**
   * 再来一次
   */
  moreTap: function () {
    var that = this

    that.setData({
      selectedIndex: -1,
      result: 0, 
      count: 4,
      globalTimer: 0,
      rightCount: 0,
      scrId: 0,
      hideThreeShadow: true,
      hideResultShadow: true
    })
    timestamp = Date.parse(new Date());
    that.doNext()
  },

  /**
   * 滑动
   */
  scrollTap: function (e) {
    var that = this
    that.data.scrId = that.data.scrId + 1
    that.setData({
      scrId: that.data.scrId,
    })
  },

  cancelThreeTipTap: function () {
    var that = this
    that.setData({
      hideThreeShadow: true,
    })

  },

  /**
  * 关闭提示弹框
  */
  cancelTipTap: function () {
    var that = this
    that.setData({
      hideTipShadow: true,
      hideThreeShadow: true,
    })

  },

  /**
   * 显示提示弹框
   */
  showTipTap: function () {
    var that = this
    that.setData({
      hideTipShadow: false,
      suspend: true
    })

  },

  /**
   * 放弃
   */
  giveUpTap: function () {
    wx.redirectTo({
      url: '/pages/home/home',
    })
  },

  /**
   * 继续
   */
  goOnTap: function () {
    var that = this

  },

  /**
   * 未选择 直接下一题
   */
  noSelectTap: function () {
    var that = this
    clearInterval(valHandle)  //销毁定时器

    if (that.data.selectedIndex == 0) {
      that.setData({
        hideResult: true,
        result: 0,
      })
    } else {
      that.setData({
        hideResult: false,
        result: 0,
      })
    }
    console.log("XXXXXX-index= "+this.data.selectedIndex+";count="+gameDatas.length);

    if (that.data.selectedIndex == gameDatas.length-1) {
      that.lastQuestion()
      return      
    } else {
      setTimeout(function () {
        that.data.noSelect = false
        that.doNext();
      }, 1000);
    }
  },

  /**
   * 不相同
   */
  differentTap: function () {
    var that = this
    that.abortAnimationFrame(tid);
    clearInterval(valHandle)  //销毁定时器

    that.setData({
      hideResult: false,
    })
    var currentData = gameDatas[that.data.selectedIndex];
    var beforeData = gameDatas[that.data.selectedIndex-1];
    if(currentData.color != beforeData.color || currentData.shape != beforeData.shape) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count,
        result: 1
      })
    } else {
      that.setData({
        result: 0
      })

      //错误就停止游戏
      that.lastQuestion();
      return
    }
    if(that.data.selectedIndex == gameDatas.length-1) {
      that.lastQuestion()
      return
    } else {
      // 下一题
      setTimeout(function () {
        that.doNext();
      }, 1000);
    }
  },

  /**
   * 相同
   */
  identicalTap: function () {
    var that = this
    that.abortAnimationFrame(tid);
    clearInterval(valHandle)  //销毁定时器

    that.setData({
      hideResult: false,
    })

    var currentData = gameDatas[that.data.selectedIndex];
    var beforeData = gameDatas[that.data.selectedIndex-1];
    if(currentData.color == beforeData.color && currentData.shape == beforeData.shape) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count,
        result: 1
      })
    }  else {
      that.setData({
        result: 0
      })

      //错误就停止游戏
      that.lastQuestion();
      return
    }
    if(that.data.selectedIndex == gameDatas.length-1) {
      that.lastQuestion()
      return
    } else {
      // 下一题
      setTimeout(function () {
        that.doNext();
      }, 1000);
    }
    
  },
  /**
   * 下一题
   */
  doNext: function () {
    var that = this

    console.log("XXXXXX --- index : " + that.data.selectedIndex + "; gameCount: " + gameDatas.length)
    
    if(that.data.selectedIndex == gameDatas.length-1) {
      that.lastQuestion()
      return
    }

    that.data.isAnswer = false

    var nextIndex = that.data.selectedIndex + 1
    var time = 0;
    if (gameDatas[nextIndex]) {
      time = gameDatas[nextIndex].time;
    }
    that.setData({
      selectedIndex: nextIndex,
      stepText: time
    })

    that.scrollTap()
    
    if (that.data.selectedIndex == 0) {
      that.setData({
        hideBottom: true,
      })
    } else {
      that.setData({
        hideBottom: false,
      })
    }
    
    that.setData({
      count: that.data.count,
      hideResult: true,
    })
    that.waveCreater();
  },

  /**
   * 判断是否是最后一题
   */
  lastQuestion: function () {
    var that = this
    var timesend = Date.parse(new Date());  
    var spandTimer = Math.floor((timesend - timestamp) / 1000) - gameDatas.length - gameDatas[0].time;

    that.setData({
      globalTimer: spandTimer
    })
    // 判断是否已经注册信息
    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          api.goToWeChat({
            data: { openid: res.data.openid },
            success: function (result) {
              if (result.user) { 
                if (result.user.state == 1) { // 已注册
                  var params = {
                    userid: result.user.id,
                    score: that.data.rightCount,
                    times: that.data.globalTimer,
                    nickname: res.data.nickName,
                    headUrl: res.data.avatarUrl,
                    city: res.data.city,
                    openid: res.data.openid
                  }
                  api.saveGamesData({
                    data: params,
                    success: function (response) {
                      console.log(response)
                      that.showResultTap()
                      // that.data.gameid = response.gameid
                      // if (result.games.length >= 2) { // 大于两次 - 分享
                      //   that.showResultTap()
                      // } else { // 直接生成报告
                      //   wx.navigateTo({
                      //     url: '/pages/analysis/analysis' + "?gameid=" + that.data.gameid + "&isShare=0",
                      //   })
                      // }
                    },
                    fail: function (res) {
                      
                    }
                  })
                } else {
                  that.showResultTap()
                  // if (that.data.rightCount <= 3) {
                  //   that.setData({
                  //     hideThreeShadow: false
                  //   })
                  // } else {
                  //   wx.navigateTo({
                  //     url: '/pages/transition/transition' + "?score=" + that.data.rightCount + "&times=" + that.data.globalTimer,
                  //   })
                  // }
                  
                }    
              } else {
                that.showResultTap()
                // if (that.data.rightCount <= 3) {
                //   that.setData({
                //     hideThreeShadow: false
                //   })
                // } else {
                //   wx.navigateTo({
                //     url: '/pages/transition/transition' + "?score=" + that.data.rightCount + "&times=" + that.data.globalTimer,
                //   })
                // }
              }
            },
            fail: function (res) {

            }
          })
        }
      },
      fail: function (res) {
        // if (that.data.rightCount <= 3) {
        //   that.setData({
        //     hideThreeShadow: false
        //   })
        // } else {

        //   wx.navigateTo({
        //     url: '/pages/transition/transition' + "?score=" + that.data.rightCount + "&times=" + that.data.globalTimer,
        //   })
        // }
      }
    })
  },
  
  /**
   * 显示简介
   */
  showIntroduceTap: function () {
    var that = this
    that.setData({
      showIntroduce: true,
    })

  },

  /**
   * 简介下一步
   */
  nextIntroductTap: function() {

  },

  /**
   * 关闭简介
   */
  closeIntroduceTap: function () {
    var that = this
    that.setData({
      showIntroduce: false,
    })

  }, 
  
  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.makeGameDatas();
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    _animationIndex = 0;
    _animationIntervalId = -1;
    this.data.animationRotate = ''; 
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    var that = this

    _animation = wx.createAnimation({
      duration: _ANIMATION_TIME,
      timingFunction: 'linear', // "linear","ease","ease-in","ease-in-out","ease-out","step-start","step-end"
      delay: 0,
      transformOrigin: '50% 50% 0'
    })

    // that.rotateFun()

    that.waveCreater();
    if (that.data.share == true) {
      that.shareTap()
    } else {
      that.moreTap()
    }

    /*
    //缩放动画
    var animation = wx.createAnimation({
      duration: 500,
      timingFunction: 'linear',
    })
    this.animation = animation
    var next = true;
    //连续动画关键步骤
    setInterval(function () {
      if (next) {
        this.animation.scale(0.95).step() 
        next = !next;
      } else {
        this.animation.scale(1).step()
        next = !next;
      }

      this.setData({
        animationData: animation.export()
      })
    }.bind(this), 500)
    */
  },
   /**
   * 实现image旋转动画，每次旋转 120*n度
   */
  rotateAni: function (n) {
    _animation.rotate(120 * (n)).step();
    this.setData({
      animationRotate: _animation.export()
    })
  },

  rotateFun:function() {
    var that = this
    var swingAnimation  = null
    swingAnimation = wx.createAnimation({
      duration: 100,
      timingFunction: 'linear',
      delay: 0,
      transformOrigin: '50% 50% 0'
    })
    that.swingAnimation = swingAnimation

    that.setData({
      swingAnimation: that.swingAnimation.export()
    })
    var n = 0
    that.data.timehandle = setInterval(function() {

    n=n+1;
    that.swingAnimation.rotate(10*n).step()
    that.setData({
      swingAnimation: that.swingAnimation.export()
    })

  }.bind(that), 100)
},

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
    var that = this
    this.abortAnimationFrame(tid);
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
    var that = this
  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {

  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {

  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function (res) {
    var that = this
    that.data.share = true
    that.cancelResultTap()
    if (res.from == "button") {
      var title = "我的孩子已闯过" + this.data.rightCount + "题，让你的孩子也试试吧！"
      return {
        title: title,
        path: "/pages/home/home",
        imageUrl: "../../style/images/tupian.png",
        success: (res) => {
          console.log("转发成功", res);
        },
        fail: (res) => {
          console.log("转发失败", res);
        }
      }
    }
  },
  timerCircleReady: function() {
    ctxTimer.setLineWidth(15)
    ctxTimer.arc(util.getScrienWidth()/2.0, 40, 30, 0, 2 * Math.PI)
    ctxTimer.setStrokeStyle('white')
    ctxTimer.stroke()

    ctxTimer.beginPath()
    ctxTimer.setLineCap('round')
    ctxTimer.setLineWidth(8)
    ctxTimer.arc(util.getScrienWidth()/2.0, 40, 30, 1.5 * Math.PI, -0.5*Math.PI, true)
    ctxTimer.setStrokeStyle('green')
    ctxTimer.stroke()
    ctxTimer.draw()
  },
  startCircleTime: function() {    
    console.log("倒计时动画开始")
    var that = this
    that.data.stepText = gameDatas[this.data.selectedIndex].time //重新设置一遍初始值，防止初始值被改变
    var step = that.data.stepText ;  //定义倒计时
    var num = -0.5;
    var decNum = 2/step/10
    clearInterval(valHandle)

    function drawArc(endAngle) {
      ctxTimer.setLineWidth(15)
      ctxTimer.arc(util.getScrienWidth()/2.0, 40, 30, 0, 2 * Math.PI)
      ctxTimer.setStrokeStyle('lightgray')
      ctxTimer.stroke()

      ctxTimer.beginPath()
      ctxTimer.setLineCap('round')
      ctxTimer.setLineWidth(8)
      ctxTimer.arc(util.getScrienWidth()/2.0, 40, 30, 1.5 * Math.PI, endAngle, true)
      ctxTimer.setStrokeStyle('green')
      ctxTimer.stroke()
      ctxTimer.draw()
    }


    var swingAnimation  = null
    swingAnimation = wx.createAnimation({
      duration: 100,
      timingFunction: 'linear',
      delay: 0,
      transformOrigin: '50% 50% 0'
    })

    that.swingAnimation = swingAnimation

    that.setData({
      swingAnimation: that.swingAnimation.export()
    })

    var n = 0
    valHandle = setInterval(function(){
      // that.rotateAni(++_animationIndex);



      console.log(that.data.cylinderNumber)

      // that.swingAnimation.rotate(20*that.data.cylinderNumber).step()

      that.swingAnimation.rotate(20*n).step()


      that.setData({
        swingAnimation: that.swingAnimation.export()
      })
  
      that.setData({
        stepText: parseInt(step)
      })
      step = (step - 0.1).toFixed(1)

      num += decNum
      drawArc(num*Math.PI)
      if(step<=0){
        that.data.cylinderNumber = 0
        clearInterval(valHandle)  //销毁定时器
        that.doNext();
      } else {
        that.data.cylinderNumber = that.data.cylinderNumber+1 
         n = n + 1

      }


    },100)
  },

  //绘制圆圈进度
  waveCreater: function() {
    // 获取圆动画轨迹点集
    for (var i = soffset; i < soffset + 2 * PI; i += 1 / (8 * PI)) {
      arcStack.push([
        r + bR * Cos(i),
        r + bR * Sin(i)
      ])
    }
    // 圆起始点
    var cStartPoint = arcStack.shift();
    ctxWave.strokeStyle = "black";
    ctxWave.moveTo(cStartPoint[0], cStartPoint[1]);
    // 开始渲染
    this.render();
  },

  drawSine: function() {
    // ctxFlow.save();
    ctxFlow.beginPath();

    var Stack = []; // 记录起始点和终点坐标
    for (var i = xoffset; i <= xoffset + axisLength; i += 20 / axisLength) {
      var x = sp + (xoffset + i) / unit;
      var y = Sin(x) * nowrange;
      var dx = i;
      var dy = 2 * cR * (1 - nowdata) + (r - cR) - (unit * y);
      ctxFlow.lineTo(dx, dy);
      Stack.push([dx, dy])
    }

    // 获取初始点和结束点
    var startP = Stack[0]
    var endP = Stack[Stack.length - 1]
    ctxFlow.fillStyle = "#f6b37f";

    ctxFlow.lineTo(xoffset + axisLength, oW);
    ctxFlow.lineTo(xoffset, oW);
    ctxFlow.lineTo(startP[0], startP[1])
    ctxFlow.fill();

    ctxFlow.restore();
  },
  drawText: function() {

    var txt = _tipContent1;
    if (this.data.selectedIndex > 35) {
      txt = _tipContent2;
    }
    this.setData({
      canvasContent:txt
    })
    /*
    ctxWave.beginPath()
    ctxWave.globalCompositeOperation = 'source-over';
    var size = 16;
    ctxWave.font = 'bold ' + size + 'rpx Microsoft Yahei';
    var number = (nowdata.toFixed(2) * 100).toFixed(0);
    var txt = _tipContent1;
    if (this.data.selectedIndex > 5) {
      txt = _tipContent2;
    }
    //number+ '%';
    var fonty = r + size / 2;
    var fontx = r - size * 0.8;
  
    ctxWave.textAlign = 'center';
    ctxWave.textBaseline = 'middle'
    ctxWave.fillText(txt, r , r )
    */
  },
  drawTriangle: function() {
    if (gameDatas[this.data.selectedIndex] == undefined) {
      return;
    }
    this.drawFillPolygon(r,(r-cR)*2.2,(r-cR),gameDatas[this.data.selectedIndex].shape,0);
    this.drawFillPolygon((r-cR)*2.2,r,(r-cR),gameDatas[this.data.selectedIndex].shape,0);
    this.drawFillPolygon(r+cR-(r-cR)*1.2,r,(r-cR),gameDatas[this.data.selectedIndex].shape,0);
  },
  //灰色圆圈
  grayCircle: function() {
    ctxWave.beginPath();
    ctxWave.lineWidth = 25;
    ctxWave.strokeStyle = '#DADCFD';
    ctxWave.arc(r, r, cR-10, 0, 2 * Math.PI);
    ctxWave.stroke();
    ctxWave.restore();
    ctxWave.save();
    ctxWave.beginPath();
  },
  //裁剪中间水圈
  clipCircle: function() {
    ctxFlow.beginPath();
    ctxFlow.arc(r, r, cR - 25, 0, 2 * Math.PI, false);
    ctxFlow.clip();
  },
  //渲染canvas
  render: function() {
    ctxWave.clearRect(0, 0, oW, oH);
    ctxGraph.clearRect(0, 0, oW, oH);
    ctxFlow.clearRect(0, 0, oW, oH);
    this.rotateAni(0);

    this.clearData();

    // 写字
    this.drawText();
     //绘制形状图
    this.drawTriangle();
    ctxGraph.draw()
    
    //灰色圆圈  
    this.grayCircle();
    ctxWave.draw();

    //裁剪中间水圈  
    this.clipCircle();
    // ctxFlow.save()
    //水纹路
    // this.drawWaveFlow();
    // ctxFlow.draw();

    this.timerCircleReady();
    this.startCircleTime();
  },

  clearData: function() {
    nowrange = range;
    nowdata = 0;
    lastFrameTime = 0;
    rotateNumber = 0;
    sp = 0;
    if(gameDatas.length > this.data.selectedIndex) {
      waveupsp = 30.0 / gameDatas[this.data.selectedIndex].time * 0.95;
    } else {
      waveupsp = 30.0 / 4000 * 0.9;
    }

    _animationIndex = 0;
    _animationIntervalId = -1;
    this.data.animationRotate = ''; 
  },
  drawWaveFlow: function() {
    this.abortAnimationFrame(tid);
    this.rotateAni(++_animationIndex);
    /*
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
    this.drawSine();
    // this.clearArcFun(r,r,cR,ctxFlow);
    ctxFlow.draw();
    */
    tid = this.doAnimationFrame(this.drawWaveFlow);
    /*
    if((lastFrameTime > 0) && (lastFrameTime > gameDatas[this.data.selectedIndex].time - 30)) {
      this.doNext();
      return;
    }
    lastFrameTime += 30;
    */
  },
  
  doAnimationFrame: function(callback) {
    var id = setTimeout(function () { callback(); }, _ANIMATION_TIME);
    return id;
  },
  // 模拟 cancelAnimationFrame
  abortAnimationFrame: function(id) {
    clearTimeout(id)
  },
  /**
 * canvas绘图相关
 * (x,y)为要清除的圆的圆心，r为外径，cR为内径，cxt为context
 *  用clearRect方法清除canvas上不能用clip剪切的圆形
 */
  clearArcFun: function(x, y, r, cxt) {
    var stepClear = 0.1;//这是定义精度 
    clearArc(x, y, r);
    function clearArc(x, y, radius) {
      var calcWidth = radius - stepClear;
      var calcHeight = Math.sqrt(radius * radius - calcWidth * calcWidth);

      var posX = x - calcWidth;
      var posY = y - calcHeight;

      var widthX = 2 * calcWidth;
      var heightY = 2 * calcHeight;

      if (stepClear <= radius) {
        cxt.clearRect(posX, posY, widthX, heightY);
        stepClear += 0.1;
        clearArc(x, y, radius);
      }
    }
  },
  countWithLevel: function(level) {
    var gameCount = [];
    /**
     第一位：题目数量；
     第二位: 时间要求(毫秒)；
     第三位：颜色数量；
     第四位：图形数量;
     */
    switch (level) {
      case 1:
        gameCount = [15,4,1,6];
        break;
      case 2:
        gameCount = [20,3,1,6];
        break;
      case 3:
        gameCount = [35,2,5,6];
          break;
      default:
        break;
    }
    return gameCount;
  },
  getMemoryDataWithLevel: function (level) {
    var gameLevelData = [];
    var datas = this.countWithLevel(level);
    var maxCount = datas[0];
    var enumTime = datas[1];
    var colorCount = datas[2];
    var enumCount = datas[3];
    var enumColors = this.randlist(constColors, colorCount);
    var enumsShape = this.randlist(constShapes, enumCount);
    for (let index = 0; index < maxCount; index++) {
      gameLevelData.push(this.getQuickMemoryLevelModel(level,enumsShape,enumColors,enumTime));      
    }
    return gameLevelData;
  },
  getQuickMemoryLevelModel: function(level, shapes,colors,time) {
    var i = Math.floor(Math.random()*(colors.length));
    var j = Math.floor(Math.random()*(shapes.length));
    var tmpColor = colors[i];
    var tmpShape = shapes[j];

    return {'color': tmpColor,
            'shape': tmpShape,
            'level': level,
            'time': time
          };
  },
  randlist: function (lists, count) {
    var tempArray = [].concat(lists);
    var results = [];
    for (let index = 0; index < count; index++) {
      var i = Math.floor(Math.random()*(tempArray.length));
      var element = tempArray[i];
      results.push(element);
      tempArray.splice(i,1);
    }
    return results;
  },
  makeGameDatas: function() {
    var level_1 = this.getMemoryDataWithLevel(1);
    var level_2 = this.getMemoryDataWithLevel(2);
    var level_3 = this.getMemoryDataWithLevel(3);

    gameDatas = level_1.concat(level_2, level_3);
    this.setData({
      answerList: gameDatas
    });
  },
  /**
   * @param {Canvas} ctx
   * @param {Number} xCenter 中心坐标x点
   * @param {Number} yCenter 中心坐标y点
   * @param {Number} radius  外圆半径
   * @param {Number} sides   多边形边数
   * @param {Number} alpha   旋转角度 默认270度
   * @param {Boolean} arc    是否显示外圈
   */
  //绘制充填的多边形
  drawFillPolygon: function(xCenter, yCenter,radius,sides,alpha) {
    ctxGraph.beginPath();
    ctxGraph.fillStyle = gameDatas[this.data.selectedIndex].color;
    if(sides == 0) {
      ctxGraph.beginPath();
      ctxGraph.arc(xCenter, yCenter, radius, 0, 2 * Math.PI, true);
    } else {
      var radAngle = Math.PI * 2 / sides;
      var radAlpha = alpha ? alpha * Math.PI / 180 : -Math.PI / 2;
      var xPos = xCenter + Math.cos(radAlpha) * radius;
      var yPos = yCenter + Math.sin(radAlpha) * radius;
      ctxGraph.moveTo(xPos, yPos);
      for (var i = 1; i < sides; i++) {
        var rad_tmp = radAngle * i + radAlpha;
        var xPos_tmp = xCenter + Math.cos(rad_tmp) * radius;
        var yPos_tmp = yCenter + Math.sin(rad_tmp) * radius;
        ctxGraph.lineTo(xPos_tmp, yPos_tmp);
      }
      ctxGraph.closePath();
    }
    ctxGraph.fill();
    ctxGraph.restore();
  },
})