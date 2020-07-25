// pages/kuaisujiyi/kuaisujiyi.js
var api = require("../../Api/api.js")
var utils=require('../../utils/util.js');
const util = require("../../utils/util.js");
const ctxWave = wx.createCanvasContext('canvasArcCir')
const ctxGraph = wx.createCanvasContext('canvasgraph')

var tid;
var M = Math;
var Sin = M.sin;
var Cos = M.cos;
var Sqrt = M.sqrt;
var Pow = M.pow;
var PI = M.PI;
var Round = M.round;
var oW =  600.0 / util.getRpx() * 1.0;
var oH =  600.0 / util.getRpx() * 1.0;
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

Page({

  /**
   * 页面的初始数据
   */
  data: {
    answerList: Array(100), // 题目总数
    selectedIndex: -1,
    isRead:false, // 判断是否现实游戏页面
    result: -2, // 结果对错 0-错 1-对
    showIntroduce: false, // 显示简介
    count: 4, // 倒计时
    timer: '',// 出题定时器名字
    hideBottom: true, // 隐藏底部判断视图
    hideResult: true, // 隐藏结果视图

    showColor: "", // 显示当前颜色
    showPositionArr: Array(2), // 记录当前亮灯位置

    previousColor: "", // 记录前一个颜色
    previousPositionArr: Array(2), // 记录前一个亮灯位置

    lights: Array(3),

    globalCount: 0, // 游戏计时器
    globalTimer: '',// 游戏计时器名字
    isSame: false, // 是否相同
    rightCount: 0, // 对的题目数量

    hideTipShadow: true, // 是否隐藏继续作答
    hideResultShadow: true, // 是否隐藏结果
    scrId: 0,
    suspend: false, //是否暂停
    noSelect: false, // 未选择
    gameid: 0,
    share: false, // 分享之后
    hideThreeShadow: true, // 隐藏 请认真答题弹框
    animationData: {}
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
   * 暂停倒计时
   */
  stopTimer: function (){
    var that = this
    clearInterval(that.data.globalTimer)
    clearInterval(that.data.timer)
  },

  /**
   * 开始倒计时
   */
  startTimer: function () {
    var that = this
    var param = { isAnswer: that.data.isAnswer }
    that.data.suspend = true
    clearInterval(that.data.timer)
    that.countDown(param)
  },

  /**
   * 关闭结果弹框
   */
  cancelResultTap: function () {
    var that = this
    that.setData({
      hideResultShadow: true,
    })
    // that.startTimer()
  },

  /**
  * 显示结果弹框
  */
  showResultTap: function () {
    var that = this
    that.setData({
      hideResultShadow: false,
    })
    that.stopTimer()
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
      globalCount: 0,
      rightCount: 0,
      scrId: 0,
      hideThreeShadow: true,
      hideResultShadow: true
    })
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
    that.startTimer()
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
    that.startTimer()
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
    that.stopTimer()
  },

  /**
   * 放弃
   */
  giveUpTap: function () {
    // wx.navigateTo({
    //   url: '/pages/home/home',
    // })

    wx.redirectTo({
      url: '/pages/home/home',
    })
  },

  /**
   * 继续
   */
  goOnTap: function () {
    var that = this
    that.startTimer()
  },

  /**
   * 未选择 直接下一题
   */
  noSelectTap: function () {
    var that = this
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
    
    if (that.data.selectedIndex == that.data.answerList.length-1) {
      if (that.data.selectedIndex>0) {
        clearInterval(that.data.globalTimer)
        clearInterval(that.data.timer)
        that.lastQuestion()
        return
      }
      
    } else {
      // 下一题
      if (that.data.selectedIndex >= 1) {
        clearInterval(that.data.timer)
        clearInterval(that.data.globalTimer)
        that.lastQuestion()
        return
      }
      setTimeout(function () {
        that.data.noSelect = false
        clearInterval(that.data.timer)
        clearInterval(that.data.globalTimer)
        that.doNext();
      }, 1000);
    }
  },

  /**
   * 不相同
   */
  differentTap: function () {
    var that = this
    if (that.data.noSelect == true) {
      return
    }

    that.setData({
      hideResult: false,
      result: that.data.isSame == false ? 1 : 0,
    })

    if(that.data.result == 1) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count
      })
    } else {
      clearInterval(that.data.globalTimer)
      clearInterval(that.data.timer)
      that.lastQuestion()
      return
    }

    if (that.data.selectedIndex == that.data.answerList.length - 1) {
      if (that.data.selectedIndex > 0) {
        clearInterval(that.data.globalTimer)
        clearInterval(that.data.timer)
        that.lastQuestion()
        return
      }
    } else {
      // 下一题
      clearInterval(that.data.timer)
      setTimeout(function () {
        clearInterval(that.data.globalTimer)
        that.doNext();
      }, 1000);
    }
  },

  /**
   * 相同
   */
  identicalTap: function () {
    var that = this
    if (that.data.noSelect == true) {
      return
    }

    that.setData({
      hideResult: false,
      result: that.data.isSame == true ? 1 : 0,
    })

    if (that.data.result == 1) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count
      }) 
    } else {
      clearInterval(that.data.globalTimer)
      clearInterval(that.data.timer)
      that.lastQuestion()
      return
    }

    if (that.data.selectedIndex == that.data.answerList.length - 1) {
      if (that.data.selectedIndex > 0) {
        clearInterval(that.data.globalTimer)
        clearInterval(that.data.timer)
        that.lastQuestion()
        return
      }
    } else {
      // 下一题
      clearInterval(that.data.timer)
      setTimeout(function () {
        clearInterval(that.data.globalTimer)
        that.doNext();
      }, 1000);
    }
  },
  /**
   * 下一题
   */
  doNext: function () {
    var that = this

    clearInterval(that.data.timer)
    that.data.isAnswer = false


    var nextIndex = that.data.selectedIndex + 1
    that.setData({
      selectedIndex: nextIndex,
    })

    that.scrollTap()
    
    if (that.data.selectedIndex == 0) {
      that.setData({
        hideBottom: true,
      })
    } else {
      that.globalCountDown()
      that.setData({
        hideBottom: false,
      })
    }
    var position = 0
    var colorNum = 0
    var color = "#fff"
    var positionArray = Array()

    positionArray = that.randomTwo()
    that.data.previousColor = that.data.showColor
    that.data.previousPositionArr = that.data.showPositionArr

    that.setData({
      count: that.data.count,
      showPositionArr: positionArray,
      showColor: color,
      hideResult: true,
    })

    //算法处理
    var position1 = 0 // 绿灯位置
    var current1 = 0 // 绿灯位置
    for (var i = 0; i < positionArray.length; i++) {
      var obj = positionArray[i]
      if (obj == "#058005") {
        position1 = i
        console.log('position1==' + position1)
        break
      }
    }
    for (var j = 0; j < that.data.previousPositionArr.length; j++) {
      var obj = that.data.previousPositionArr[j]
      if (obj == "#058005") {
        current1 = j
        console.log('current1==' + current1)
        break
      }
    }
    
    if (position1 == current1) {
      that.data.isSame = true
    } else {
      that.data.isSame = false
    }
    var param = { isAnswer: that.data.isAnswer }
    // that.countDown(param)
  },

  /**
   *  随机三个不同的数
   */
  randomTwo: function () {
    var that = this
    var arr = [];
    while (arr.length < 3) {
      var num = Math.floor(Math.random() * 3) 
      if (arr.length === 0) { 
        arr.push(num)
      } else {
        for (var i = 0; i < arr.length; i++) { 
          if (arr.join(',').indexOf(num) < 0) {
          　arr.push(num)
          }
        }
      }
    }

    console.log('function=' + arr)
    var colorArr = []

    if (that.data.selectedIndex >= 0 && that.data.selectedIndex <= 50) {
      for (var i = 0; i < arr.length; i++) {
        var obj = arr[i]
        if (obj == 0) {
          colorArr.push("#fff")
        } else if (obj == 1) {
          colorArr.push("#fff")
        } else {
          colorArr.push("#058005")
        }
      }
      console.log('绿灯colorArr=' + colorArr)

    } else {
      for (var i = 0; i < arr.length; i++) {
        var obj = arr[i]
        if (obj == 0) {
          colorArr.push("#fff")
        } else if (obj == 1) {
          colorArr.push("#FF3838")
        } else {
          colorArr.push("#058005")
        }
      }
      console.log('红绿灯colorArr=' + colorArr)
    }

    return colorArr
  },
/**
   * 出题计时器
   */
  countDown: function (param) {
    
    let that = this;
    let newCount = that.data.count;//获取倒计时初始值
    if (that.data.suspend == true) { // 暂停状态
      that.data.suspend = false
    } else {
      if (that.data.selectedIndex >= 0 && that.data.selectedIndex <= 20) {
        newCount = 4
      } else if (that.data.selectedIndex >= 21 && that.data.selectedIndex <= 40) {
        newCount = 3
      } else if (that.data.selectedIndex >= 41 && that.data.selectedIndex <= 70) {
        newCount = 2
      } else if (that.data.selectedIndex >= 71) {
        newCount = 1
      } 
    }

    var step = 1,//计数动画次数
      num = 0,//计数倒计时秒数（n - num）
      start = 1.5 * Math.PI,// 开始的弧度
      end = -0.5 * Math.PI,// 结束的弧度
      time = null;// 计时器容器

    var animation_interval = 1000,// 每1秒运行一次计时器
      n = newCount; // 当前倒计时为10秒
    // 动画函数
    function animation() {
      if (step <= n) {
        end = end + 2 * Math.PI / n;
        ringMove(start, end);
        step++;
      } else {
        clearInterval(time);
      }
    };
    // 画布绘画函数
    function ringMove(s, e) {
      var context = wx.createCanvasContext('secondCanvas')

      var gradient = context.createLinearGradient(200, 100, 100, 200);
      gradient.addColorStop("0", "#2661DD");
      gradient.addColorStop("0.5", "#40ED94");
      gradient.addColorStop("1.0", "#5956CC");

      // 绘制圆环
      context.setStrokeStyle('#00B461')
      context.beginPath()
      context.setLineWidth(5)
      context.arc(65, 65, 35, s, e, true)
      context.stroke()
      context.closePath()

      // 绘制倒计时文本
      context.beginPath()
      context.setLineWidth(1)
      context.setFontSize(40)
      context.setFillStyle('#333333')
      context.setTextAlign('center')
      context.setTextBaseline('middle')
      context.fillText(n - num + '', 65, 65, 35)
      context.fill()
      context.closePath()

      context.draw()

      // 每完成一次全程绘制就+1
      num++;
    }
    // 倒计时前先绘制整圆的圆环
    ringMove(start, end);
    // 创建倒计时
    // time = setInterval(animation, animation_interval);

    that.setData({
      count: newCount
    })
    that.setData({
      timer: setInterval(function () {
        animation()
        that.setData({
          count: that.data.count-1
        })
        if (that.data.count <= 0) {
          clearInterval(that.data.timer)
          that.data.noSelect = true
          that.noSelectTap()
        }
      }, 1000)
    })  
  },
  /**
   * 判断是否是最后一题
   */
  lastQuestion: function () {
    var that = this
    that.setData({
      globalCount: that.data.globalCount
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
                    times: that.data.globalCount,
                    nickname: res.data.nickName,
                    headUrl: res.data.avatarUrl,
                    city: res.data.city,
                    openid: res.data.openid
                  }
                  api.saveWechatGames({
                    data: params,
                    success: function (response) {
                      console.log(response)
                      that.data.gameid = response.gameid
                      if (result.games.length >= 2) { // 大于两次 - 分享
                        that.showResultTap()
                      } else { // 直接生成报告
                        wx.navigateTo({
                          url: '/pages/analysis/analysis' + "?gameid=" + that.data.gameid + "&isShare=0",
                        })
                      }
                    },
                    fail: function (res) {
                      
                    }
                  })
                } else {
                  if (that.data.rightCount <= 3) {
                    that.setData({
                      hideThreeShadow: false
                    })
                  } else {
                    // wx.navigateTo({
                    //   url: '/pages/information/information' + "?score=" + that.data.rightCount + "&times=" + that.data.globalCount,
                    // })

                    wx.navigateTo({
                      url: '/pages/transition/transition' + "?score=" + that.data.rightCount + "&times=" + that.data.globalCount,
                    })
                  }
                  
                }    
              } else {
                if (that.data.rightCount <= 3) {
                  that.setData({
                    hideThreeShadow: false
                  })
                } else {
                  // wx.navigateTo({
                  //   url: '/pages/information/information' + "?score=" + that.data.rightCount + "&times=" + that.data.globalCount,
                  // })

                  wx.navigateTo({
                    url: '/pages/transition/transition' + "?score=" + that.data.rightCount + "&times=" + that.data.globalCount,
                  })
                }
              }
            },
            fail: function (res) {

            }
          })
        }
      },
      fail: function (res) {
        if (that.data.rightCount <= 3) {
          that.setData({
            hideThreeShadow: false
          })
        } else {

          wx.navigateTo({
            url: '/pages/transition/transition' + "?score=" + that.data.rightCount + "&times=" + that.data.globalCount,
          })
        }
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
    that.stopTimer()
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
    that.startTimer()
  }, 

  /**
  * 计时器
  */
  globalCountDown: function (count) {
    var that = this
    clearInterval(that.data.globalTimer)
    var globalTimer = setInterval(function () {
      that.data.globalCount = that.data.globalCount + 1
    }, 1000);
    that.setData({
      globalTimer: globalTimer
    })
  }, 
  
  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var that = this
    // that.moreTap()
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
  
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    var that = this
    // that.drawProgressbg()
    that.waveCreater();
    if (that.data.share == true) {
      that.shareTap()
    } else {
      that.moreTap()
    }

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
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
    var that = this
    clearInterval(that.data.timer);
    clearInterval(that.data.globalTimer)
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
    var that = this
    clearInterval(that.data.timer);
    clearInterval(that.data.globalTimer)
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
    that.stopTimer()
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
    ctxWave.strokeStyle = "#1c86d1";
    ctxWave.moveTo(cStartPoint[0], cStartPoint[1]);
    // 开始渲染
    this.render();
  },

  drawSine: function() {
    ctxWave.beginPath();
    ctxWave.save();
    var Stack = []; // 记录起始点和终点坐标
    for (var i = xoffset; i <= xoffset + axisLength; i += 20 / axisLength) {
      var x = sp + (xoffset + i) / unit;
      var y = Sin(x) * nowrange;
      var dx = i;
      var dy = 2 * cR * (1 - nowdata) + (r - cR) - (unit * y);
      ctxWave.lineTo(dx, dy);
      Stack.push([dx, dy])
    }
    // 获取初始点和结束点
    var startP = Stack[0]
    var endP = Stack[Stack.length - 1]
    ctxWave.lineTo(xoffset + axisLength, oW);
    ctxWave.lineTo(xoffset, oW);
    ctxWave.lineTo(startP[0], startP[1])
    ctxWave.fillStyle = "#4BEF8B";

    ctxWave.fill();
    ctxWave.restore();
  },
  drawText: function() {
    ctxWave.globalCompositeOperation = 'source-over';
    var size = 18;
    ctxWave.font = 'bold ' + size + 'px Microsoft Yahei';
    var number = (nowdata.toFixed(2) * 100).toFixed(0);
    var txt = "颜色是否与前面相同";
    //number+ '%';
    var fonty = r + size / 2;
    var fontx = r - size * 0.8;
  
    ctxWave.textAlign = 'center';
    ctxWave.textBaseline = 'middle'
    ctxWave.fillText(txt, r , r )
  },
  drawTriangle: function() {
    ctxGraph.beginPath();
    ctxGraph.lineWidth = 15;
    ctxGraph.moveTo(r, (r-cR)/2.0)
    ctxGraph.lineTo(cR,(r-cR)*2.0)
    ctxGraph.lineTo(r+(r-cR), (r-cR)*2.0)
    ctxGraph.fillStyle = '#6495ED';
    ctxGraph.closePath()
    ctxGraph.fill()
    ctxGraph.restore();

    ctxGraph.beginPath();
    ctxGraph.moveTo((r-cR)/2.0, r)
    ctxGraph.lineTo((r-cR)*2.0, r-(r-cR))
    ctxGraph.lineTo((r-cR)*2.0, r+(r-cR))
    ctxGraph.fillStyle = '#6495ED';
    ctxGraph.closePath()
    ctxGraph.fill()
    ctxGraph.restore();

    ctxGraph.beginPath();
    ctxGraph.moveTo((r+cR+(r-cR)/2.0), r)
    ctxGraph.lineTo((r+cR-(r-cR)), r-(r-cR))
    ctxGraph.lineTo((r+cR-(r-cR)), r+(r-cR))
    ctxGraph.fillStyle = '#6495ED';
    ctxGraph.closePath()
    ctxGraph.fill()
    ctxGraph.restore();
  },
  //灰色圆圈
  grayCircle: function() {
    ctxWave.beginPath();
    ctxWave.lineWidth = 2;
    ctxWave.strokeStyle = '#7ce99e';
    ctxWave.arc(r, r, cR-8, 0, 2 * Math.PI);
    ctxWave.stroke();
    ctxWave.restore();
    ctxWave.beginPath();
  },
  //裁剪中间水圈
  clipCircle: function() {
    ctxWave.beginPath();
    ctxWave.arc(r, r, cR - 10, 0, 2 * Math.PI, false);
    ctxWave.clip();
  },
  //渲染canvas
  render: function() {
    ctxWave.clearRect(0, 0, oW, oH);
    ctxGraph.clearRect(0, 0, oW, oH);
    this.clearData();
    //绘制形状图
    this.drawTriangle();
    ctxGraph.draw();

    //灰色圆圈  
    this.grayCircle();
    //裁剪中间水圈  
    this.clipCircle();
    ctxWave.save();
    this.drawWaveFlow();
    ctxWave.draw();

  },

  clearData: function() {
    nowrange = range;
    nowdata = 0;
    lastFrameTime = 0;
    rotateNumber = 0;
  },
  drawWaveFlow: function() {
    this.abortAnimationFrame(tid);
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
    // sp = self.data.countDown / self.data.count
    // 开始水波动画
    this.drawSine();
    // 写字
    this.drawText();
    ctxWave.draw();

    tid = this.doAnimationFrame(this.drawWaveFlow);
  },
  doAnimationFrame: function(callback) {
    var currTime = new Date().getTime();
    var timeToCall = Math.max(0, 16 - (currTime - lastFrameTime));
    var id = setTimeout(function () { callback(currTime + timeToCall); }, timeToCall);
    lastFrameTime = currTime + timeToCall;
    return id;
  },
  // 模拟 cancelAnimationFrame
  abortAnimationFrame: function(id) {
    clearTimeout(id)
  }
})