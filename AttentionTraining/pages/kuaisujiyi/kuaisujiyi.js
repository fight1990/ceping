// pages/kuaisujiyi/kuaisujiyi.js
var api = require("../../Api/api.js")
const util = require("../../utils/util.js");
const ctxWave = wx.createCanvasContext('canvasArcCir')
const ctxGraph = wx.createCanvasContext('canvasgraph')

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

var constColors = ["Blue","Purple","Green","Red"];

var isCurrentTimer = false;
/**
 * 0 -- 圆形
 * 3 -- 三角形
 * 4 -- 正方形
 * 5 -- 五角星
 * 6 -- 六边形
 * 8 -- 八边形
 */
var constShapes = [0,4,5,6,8];
var gameDatas = [];

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

    stepText: 5,  //设置倒计时初始值
    rankPercent: '0.0%',

    result_info_value: "",
    result_info_items:[{
      one: '我是',
      two: "小宇航员士兵",
      three: "",
      color:'green'
    },{
      one: '我的专注力超过',
      two: "20%",
      three: "的人！",
      color:'red'
    },{
      one: '答对',
      two: "40",
      three: "题",
      color:'red'
    },{
      one: '平均答题时长：',
      two: "0.00",
      three: "秒",
      color:'red'
    }],
  },

  /**
   * 分享
   */
  shareTap: function () {
    // var that = this
    // wx.navigateTo({
    //   url: '/pages/analysis/analysis' + "?gameid=" + that.data.gameid + "&isShare=1",
    // })
    // that.data.share = false
  },
  
  /**
   * 关闭结果弹框
   */
  cancelResultTap: function () {
    var that = this
    wx.navigateBack({
      delta: 2,
    })
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
    isCurrentTimer = false;

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
    clearInterval(valHandle)  //销毁定时器
    isCurrentTimer = false;

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
    clearInterval(valHandle)  //销毁定时器
    isCurrentTimer = false;

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
    var spandTimer = Math.floor((timesend - timestamp) / 1000);

    that.setData({
      globalTimer: spandTimer,
    })
    that.senderGameDatas()
  },

  senderGameDatas:function() {
    var that = this;
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
                    openid: res.data.openid,
                    type: 2
                  }
                  api.saveWechatGames({
                    data: params,
                    success: function (response) {
                      that.data.gameid = response.gameid
                      that.setData({
                        result_info_value: response.remark,
                        rankPercent: response.scale,
                        result_info_items:[{
                          one: '我是',
                          two: response.rank,
                          three: "",
                          color:'green'
                        },{
                          one: '我的专注力超过',
                          two: response.scale,
                          three: "的人！",
                          color:'red'
                        },{
                          one: '答对',
                          two: that.data.rightCount,
                          three: "题",
                          color:'red'
                        },{
                          one: '平均答题时长：',
                          two: (that.data.globalTimer/that.data.selectedIndex).toFixed(2),
                          three: "秒",
                          color:'red'
                        }]
                      })

                      that.showResultTap()
                    },
                    fail: function (res) {
                      
                    }
                  })
                }
              } else {
                wx.navigateTo({
                  url: '/pages/transition/transition'
                })
              }
            },
            fail: function (res) {
              wx.navigateTo({
                url: '/pages/transition/transition'
              })
            }
          })
        } else {
          wx.navigateTo({
            url: '/pages/transition/transition'
          })
        }
      },
      fail: function (res) {
        wx.navigateTo({
          url: '/pages/transition/transition'
        })
      }
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
    var that = this

    that.waveCreater();
    that.moreTap()
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    if (this.data.hideResultShadow && valHandle) {
      this.startCircleTime();
    }
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
    var that = this
    clearInterval(valHandle)  //销毁定时器
    isCurrentTimer = false;
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
    var that = this
    clearInterval(valHandle)  //销毁定时器
    isCurrentTimer = false;
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
    return {
      title: '答对'+this.data.rightCount+'题，超过'+this.data.rankPercent+'同龄人，让孩子训练专注力吧！'
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
    var that = this

    if (isCurrentTimer) {
      return;
    }
    isCurrentTimer = true;

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

    valHandle = setInterval(function(){
    
      that.setData({
        stepText: parseInt(step)
      })
      step = (step - 0.1).toFixed(1)

      num += decNum
      drawArc(num*Math.PI)
      if(step<=0){
        clearInterval(valHandle)  //销毁定时器
        isCurrentTimer = false;
        if (that.data.selectedIndex >=1) {
          that.lastQuestion()
        } else {
          that.doNext();
        }
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

  drawText: function() {

    var txt = _tipContent1;
    var level = 1;
    if (gameDatas[this.data.selectedIndex]) {
      level = gameDatas[this.data.selectedIndex].level;
    }
    if (level == 3) {
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

    var hudu1 = Math.floor(Math.random() * 60) * Math.PI / 180;
    var X1 = r + Math.sin(hudu1) * cR ;
    var Y1 = r - Math.cos(hudu1) * cR ;
    this.drawFillPolygon(X1,Y1,(r-cR),gameDatas[this.data.selectedIndex].shape,0);

    var hudu2 = Math.floor(Math.random() * 60 + 120) * Math.PI / 180;
    var X2 = r + Math.sin(hudu2) * cR ;
    var Y2 = r - Math.cos(hudu2) * cR ;
    this.drawFillPolygon(X2,Y2,(r-cR),gameDatas[this.data.selectedIndex].shape,0);

    var hudu3 = Math.floor(Math.random() * 60 + 240) * Math.PI / 180;
    var X3 = r + Math.sin(hudu3) * cR ;
    var Y3 = r - Math.cos(hudu3) * cR ;
    this.drawFillPolygon(X3,Y3,(r-cR),gameDatas[this.data.selectedIndex].shape,0);

    // this.drawFillPolygon(r,(r-cR)*2.2,(r-cR),gameDatas[this.data.selectedIndex].shape,0);
    // this.drawFillPolygon((r-cR)*2.2,r,(r-cR),gameDatas[this.data.selectedIndex].shape,0);
    // this.drawFillPolygon(r+cR-(r-cR)*1.2,r,(r-cR),gameDatas[this.data.selectedIndex].shape,0);
  },
  //灰色圆圈
  grayCircle: function() {
    ctxWave.beginPath();
    ctxWave.lineWidth = 15;
    ctxWave.strokeStyle = '#DADCFD';
    ctxWave.arc(r, r, cR-10, 0, 2 * Math.PI);
    ctxWave.stroke();
    ctxWave.restore();
    ctxWave.save();
    ctxWave.beginPath();
  },

  //渲染canvas
  render: function() {
    ctxWave.clearRect(0, 0, oW, oH);
    ctxGraph.clearRect(0, 0, oW, oH);

    this.clearData();

    // 写字
    this.drawText();
     //绘制形状图
    this.drawTriangle();
    ctxGraph.draw()
    
    //灰色圆圈  
    this.grayCircle();
    ctxWave.draw();

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
        gameCount = [15,4,1,5];
        break;
      case 2:
        gameCount = [30,3,1,5];
        break;
      case 3:
        gameCount = [45,2,4,5];
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

  /**
   * 显示简介
   */
  showIntroduceTap: function () {
    var that = this
    that.setData({
      showIntroduce: true,
    })
    clearInterval(valHandle)
    isCurrentTimer = false;
  },

  /**
   * 关闭简介
   */
  closeIntroduceTap: function () {
    var that = this
    that.setData({
      showIntroduce: false,
    })
    that.startCircleTime()
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