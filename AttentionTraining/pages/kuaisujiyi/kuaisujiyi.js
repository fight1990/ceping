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
var kMaxTime = 5000; //倒计时时间

var constColors = ["Blue","Purple","Yellow","Green","Red"];
/**
 * 0 -- 圆形
 * 1 -- 三角形
 * 2 -- 正方形
 * 3 -- 五角星
 * 4 -- 六边形
 * 5 -- 八边形
 */
var constShapes = ['0','1','2','3','4','5'];
var gameDatas = [];

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
    timer: '',// 出题定时器名字
    hideBottom: true, // 隐藏底部判断视图
    hideResult: true, // 隐藏结果视图

    globalCount: 0, // 游戏计时器
    rightCount: 0, // 对的题目数量

    hideTipShadow: true, // 是否隐藏继续作答
    hideResultShadow: true, // 是否隐藏结果
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
    that.abortAnimationFrame(tid);

    that.setData({
      hideResult: false,
    })
    var currentData = gameDatas[that.data.selectedIndex];
    var beforeData = gameDatas[that.data.selectedIndex-1];
    if(currentData.color != beforeData.color || currentData.shape == beforeData.shape) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count,
        result: 1
      })
    } else {
      that.setData({
        result: 0
      })
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
    ctxWave.strokeStyle = "black";
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
    ctxWave.fillStyle = "#f6b37f";

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
    ctxWave.lineWidth = 50;
    ctxWave.strokeStyle = '#DADCFD';
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
    console.log("XXXXX: "+ this.data.selectedIndex);
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
    if(gameDatas.length > this.data.selectedIndex) {
      waveupsp = 30.0 / gameDatas[this.data.selectedIndex].time * 0.95;
    } else {
      waveupsp = 30.0 / 4000 * 0.9;
    }
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
    // 开始水波动画
    this.drawSine();
    // 写字
    this.drawText();
    ctxWave.draw();
    
    console.log("HHH: "+lastFrameTime+";gameTime: "+gameDatas[this.data.selectedIndex].time);

    tid = this.doAnimationFrame(this.drawWaveFlow);

    if((lastFrameTime > 0) && (lastFrameTime > gameDatas[this.data.selectedIndex].time - 30)) {
      this.doNext();
      return;
    }
    lastFrameTime += 30;
  },
  
  doAnimationFrame: function(callback) {
    var id = setTimeout(function () { callback(); }, 30);
    return id;
  },
  // 模拟 cancelAnimationFrame
  abortAnimationFrame: function(id) {
    clearTimeout(id)
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
        gameCount = [15,4000,1,6];
        break;
      case 2:
        gameCount = [20,3000,1,6];
        break;
      case 3:
        gameCount = [35,2000,5,6];
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
    for (let index = 0; index < maxCount+1; index++) {
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
  }
})