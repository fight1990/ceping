// pages/siterupuGuide/siterupuGuide.js
var api = require("../../Api/api.js")
const util = require("../../utils/util.js");

//斯特如普训练
const siterupu_ctxtext = wx.createCanvasContext('siterupu_canvas_text')

var valHandle;  //定时器
const ctxTimer = wx.createCanvasContext("bgCanvas")
const ctxTimer_two = wx.createCanvasContext("bgCanvas_two")

var timestamp = Date.parse(new Date());  

var siterupu_gameDatas = [];

const siterupu_colors = ['red','yellow','green','blue','purple']
const siterupu_words = ['纡','红','璜','黄','录','绿','监','蓝','橴','紫']
const siterupu_wordForColor = {'red':'红','yellow':'黄','green':'绿','blue':'蓝','purple':'紫'}

var oW =  650.0 / util.getRpx() * 1.0;
var oH =  650.0 / util.getRpx() * 1.0;
// 线宽
var lineWidth = 2;
// 大半径
var r = (oW / 2);
var cR = r - 10 * lineWidth;

Page({

  /**
   * 页面的初始数据
   */
  data: {
    selectedIndex: 0,
    result: 0, // 结果对错 0-错 1-对
    hideBottom: true, // 隐藏底部判断视图
    hideResult: true, // 隐藏结果视图
    rightCount: 0, // 对的题目数量
    globalTimer: 0, //游戏计时器
    stepText: '',  //设置倒计时初始值
    hideResultShadow: true, // 是否隐藏结果

    isShowTimer: true,

    strp_time: 0,
    strp_correct: 0,

    hideGuoduye: true,
    hideShadowOne: false
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
    that.moreTap()
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    if (!this.data.hideGuoduye && this.data.isShowTimer && valHandle) {
      this.startCircleTime(ctxTimer_two)
    }
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
    clearInterval(valHandle)  //销毁定时器
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {

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
  onShareAppMessage: function () {

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
    return;
    var that = this
    that.setData({
      hideResultShadow: false,
    })
  },

  /**
   * 不相同
   */
  differentTap: function () {
    return;
    var that = this
    clearInterval(valHandle)  //销毁定时器

    that.setData({
      hideResult: false,
    })
    
    //斯特如普训练
    var currentData = siterupu_gameDatas[that.data.selectedIndex];
    var color = currentData.color;
    if(siterupu_wordForColor[color] != currentData.text) {
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
    if(that.data.selectedIndex == siterupu_gameDatas.length-1) {
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
    return;
    var that = this
    clearInterval(valHandle)  //销毁定时器

    that.setData({
      hideResult: false,
    })

   //斯特如普训练
    var currentData = siterupu_gameDatas[that.data.selectedIndex];
    var color = currentData.color;
    if(siterupu_wordForColor[color] == currentData.text) {
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
    if(that.data.selectedIndex == siterupu_gameDatas.length-1) {
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
      hideResultShadow: true,

      strp_time: 0,
      strp_correct: 0
    })

    timestamp = Date.parse(new Date());
    that.doNext()
  },
  /**
   * 下一题
   */
  doNext: function () {
    var that = this

    //斯特如普训练
    if(that.data.selectedIndex == siterupu_gameDatas.length-1) {
      that.lastQuestion()
      return
    }

    that.data.isAnswer = false

    var nextIndex = that.data.selectedIndex + 1
    var time = '';
    if (siterupu_gameDatas[nextIndex]) {
      time = siterupu_gameDatas[nextIndex].time;
    }
    console.log('time = '+time)

    that.setData({
      selectedIndex: nextIndex,
      stepText: time
    })
    
    that.setData({
      hideBottom: false,
    })
    
    that.setData({
      count: that.data.count,
      hideResult: true,
    })

    that.siterupu_createGame()
  },

  /**
   * 判断是否是最后一题
   */
  lastQuestion: function () {
    var that = this

    //斯特如普训练
    var timesend = Date.parse(new Date());  
    var spandTimer = Math.floor((timesend - timestamp) / 1000);

    var rightCount = that.data.rightCount
    that.setData({
      globalTimer: spandTimer,
      strp_time: spandTimer,
      strp_correct: rightCount
    })
    that.showResultTap()
  },

  //倒计时圆环
  timerCircleReady: function(ctx) {
    ctx.setLineWidth(15)
    ctx.arc(util.getScrienWidth()/2.0, 40, 30, 0, 2 * Math.PI)
    ctx.setStrokeStyle('white')
    ctx.stroke()

    ctx.beginPath()
    ctx.setLineCap('round')
    ctx.setLineWidth(8)
    ctx.arc(util.getScrienWidth()/2.0, 40, 30, 1.5 * Math.PI, -0.5*Math.PI, true)
    ctx.setStrokeStyle('green')
    ctx.stroke()
    ctx.draw()
  },
  startCircleTime: function(ctx) {    
    console.log("倒计时动画开始")
    var that = this

    var step = that.data.stepText ;  //定义倒计时
    var num = -0.5;
    var decNum = 2/step/10
    clearInterval(valHandle)

    function drawArc(endAngle) {
      ctx.setLineWidth(15)
      ctx.arc(util.getScrienWidth()/2.0, 40, 30, 0, 2 * Math.PI)
      ctx.setStrokeStyle('lightgray')
      ctx.stroke()

      ctx.beginPath()
      ctx.setLineCap('round')
      ctx.setLineWidth(8)
      ctx.arc(util.getScrienWidth()/2.0, 40, 30, 1.5 * Math.PI, endAngle, true)
      ctx.setStrokeStyle('green')
      ctx.stroke()
      ctx.draw()
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
        // that.doNext();
        wx.redirectTo({
          url: '/pages/siterupuGame/siterupuGame',
        })
      }
    },100)
  },

  clearData: function() {
    this.setData({
      selectedIndex: -1,
      result: 0, // 结果对错 0-错 1-对
      hideBottom: true, // 隐藏底部判断视图
      hideResult: true, // 隐藏结果视图
      rightCount: 0, // 对的题目数量
      globalTimer: 0, //游戏计时器
      stepText: '',  //设置倒计时初始值
      hideResultShadow: true, // 是否隐藏结果
    })
  },

   /**
   * 斯特如普训练游戏
   */
  siterupu_createGame: function() {
    siterupu_ctxtext.clearRect(0, 0, oW, oH)

    siterupu_ctxtext.globalCompositeOperation = 'source-over'
    siterupu_ctxtext.font = 'bold 60rpx Microsoft Yahei'
    var txt = siterupu_gameDatas[this.data.selectedIndex].text
    var color = siterupu_gameDatas[this.data.selectedIndex].color

    siterupu_ctxtext.fillStyle = color
    siterupu_ctxtext.textAlign = 'center'
    siterupu_ctxtext.fillText(txt, r, 75)

    siterupu_ctxtext.draw()

    this.timerCircleReady(ctxTimer);
    // this.startCircleTime(ctxTimer);
  },
 
  /**
   * 斯特如普训练游戏数据
   */
  countWithSTRPLevel: function(level) {
    var gameCount = [];
    /**
     第一位：题目数量；
     第二位: 时间要求(毫秒)；
     第三位: 符号数
     */
    switch (level) {
      case 1:
        gameCount = [20,'4'];
        break;
      case 2:
        gameCount = [30,'3'];
        break;
      case 3:
        gameCount = [35,'2'];
          break;
      default:
        break;
    }
    return gameCount;
  },

  getSTRPDataWithLevel: function (level) {
    var gameLevelData = [];
    var datas = this.countWithSTRPLevel(level);
    var maxCount = datas[0];
    var enumTime = datas[1];
    for (let index = 0; index < maxCount; index++) {
      gameLevelData.push(this.getSTRPModel(level,enumTime));      
    }
    return gameLevelData;
  },

  getSTRPModel: function(level, time) {
    var i = Math.floor(Math.random()*(siterupu_words.length));
    var j = Math.floor(Math.random()*(siterupu_colors.length));
    var tmpWord = siterupu_words[i];
    var tmpColor = siterupu_colors[j];
    return {'color': tmpColor,
            'text': tmpWord,
            'level': level,
            'time': time
          };
  },

   /**
   * 
   * @param {*} datas 数据源-数组
   * @param {*} count 随机获取子数目
   */
  randomSubDatas: function(datas, count) {
    return util.getArrayItems(datas, count);
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
  
    var siterupu_gameDatas1 = this.getSTRPDataWithLevel(1);
    var siterupu_gameDatas2 = this.getSTRPDataWithLevel(2);
    var siterupu_gameDatas3 = this.getSTRPDataWithLevel(3);
    siterupu_gameDatas = siterupu_gameDatas1.concat(siterupu_gameDatas2, siterupu_gameDatas3);

  },
  
  /**
   * 我知道了 - 按钮
   */
  hideShadowView: function () {
    var that = this
    that.setData({
      hideGuoduye: false,
      hideShadowOne: true
    })
    ctxTimer.clearRect(0,0,oW,oH)
    that.countDownTwo()
  },

  countDownTwo: function() {
    wx.setStorageSync('siterupu_guide', true)
    this.setData({
      stepText: 5,
      isShowTimer: true
    })
    this.timerCircleReady(ctxTimer_two);
    this.startCircleTime(ctxTimer_two);
  }

})