// pages/xiaofuhaoGuide/xiaofuhaoGuide.js
var api = require("../../Api/api.js")
const util = require("../../utils/util.js");

var valHandle;  //定时器
const ctxTimer = wx.createCanvasContext("bgCanvas")

var timestamp = Date.parse(new Date());  

var xiaofuhao_gameDatas = [];

const xiaofuhao_symbols = ["@","#","%","《","*","(","{","}","》","】"]
const xiaofuhao_number = ["0","1","2","3","4","5","6","7","8","9"]

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
    stepText: '5',  //设置倒计时初始值
    hideResultShadow: true, // 是否隐藏结果

    isShowTimer: true,
    xiaofuhao_currentData : {},
    xiaofuhao_currentData_test : {},

    xfh_time: 0,
    xfh_correct: 0,

    //键盘事件
    num: 0,
    hasDot: false, // 防止用户多次输入小数点

    hideShadowOne: false, // 隐藏透明视图一
    hideShadowTwo: true, //  隐藏透明视图二
    hideShadowThree: true, //  隐藏透明视图三
    hideGuoduye: true, // 隐藏过渡页面
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
    if (this.data.isShowTimer && !this.data.hideGuoduye) {
      this.startCircleTime()
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
      hideResultShadow: true,

      xfh_time: 0,
      xfh_correct: 0,
    })

    timestamp = Date.parse(new Date());
    that.doNext()
  },
  /**
   * 下一题
   */
  doNext: function () {
    var that = this

    if(that.data.selectedIndex == xiaofuhao_gameDatas.length-1) {
      that.lastQuestion()
      return
    }

    that.data.isAnswer = false

    var nextIndex = that.data.selectedIndex + 1
    var time = ''
    var showTimer = false
    if (nextIndex >= 15) {
      showTimer = true
    }
    if (nextIndex == 15) {
      time = 180
    } else if(nextIndex == 35) {
      time = 150
    }
    that.setData({
      selectedIndex: nextIndex,
      stepText: time,
      isShowTimer: showTimer
    })
    
    that.setData({
      count: that.data.count,
      hideResult: true,
    })
    var xfh_temp = xiaofuhao_gameDatas[that.data.selectedIndex]
    var xiaofuhao = {}
    var xiaofuhao_key = []
    for (var key in xfh_temp) {
      xiaofuhao_key.push(key)
    }
    xiaofuhao_key = util.sortArray(xiaofuhao_key)

    xiaofuhao_key.forEach(element => {
      xiaofuhao[element] = ''
    });

    //工作记忆区训练
    that.setData({
      xiaofuhao_currentData: xiaofuhao_gameDatas[that.data.selectedIndex],
      xiaofuhao_currentData_test: xiaofuhao
    })

    if (that.data.selectedIndex == 15) {
      this.timerCircleReady();
      this.startCircleTime();
    }
  },

  /**
   * 判断是否是最后一题
   */
  lastQuestion: function () {
    var that = this

    //工作记忆区训练
    var timesend = Date.parse(new Date());  
    var spandTimer = Math.floor((timesend - timestamp) / 1000);

    var rightCount = that.data.rightCount
    that.setData({
      globalTimer: spandTimer,
      xfh_time: spandTimer,
      xfh_correct: rightCount
    })
    that.showResultTap()
  },

  //倒计时圆环
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
        // that.doNext();
        wx.redirectTo({
          url: '/pages/xiaofuhaoGame/xiaofuhaoGame',
        })
      }
    },100)
  },

  /**
   * 工作记忆区训练游戏
   */
  inputValueAction: function(event) {
    var that = this
    var value = event.detail.value
    console.log(event)
    var inputID= event.target.id

    var xfh_temp = that.data.xiaofuhao_currentData_test
    xfh_temp[inputID] = value

    that.setData({
      xiaofuhao_currentData_test: xfh_temp
    })
    for (var key in xfh_temp) {
      if(xfh_temp[key].length == 0) {
        return;
      }
    }

    var correntAll = true
    for (var key in that.data.xiaofuhao_currentData) {
      if(that.data.xiaofuhao_currentData[key] != that.data.xiaofuhao_currentData_test[key]) {
        correntAll = false
        break
      }
    }

    that.setData({
      hideResult: false,
    })

    if(correntAll) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count,
        result: 1,
      })
    } else {
      that.setData({
        result: 0
      })
    }

    if(that.data.selectedIndex == xiaofuhao_gameDatas.length-1) {
      that.lastQuestion()
      return
    } else {
      // 下一题
      setTimeout(function () {
        that.doNext();
      }, 1000);
    }
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
   * 工作记忆区训练游戏数据
   */
  countWithXFHLevel: function(level) {
    var gameCount = [];
    /**
     第一位：题目数量；
     第二位: 时间要求(毫秒)；
     第三位: 符号数
     */
    switch (level) {
      case 1:
        gameCount = [15,'0',5];
        break;
      case 2:
        gameCount = [30,'180',7];
        break;
      case 3:
        gameCount = [40,'150',12];
          break;
      default:
        break;
    }
    return gameCount;
  },
  getXFHDataWithLevel: function (level) {
    var gameLevelData = [];
    var datas = this.countWithXFHLevel(level);
    var maxCount = datas[0];
    var enumTime = datas[1];
    var symbolCount = datas[2];

    for (let index = 0; index < maxCount; index++) {
      gameLevelData.push(this.getXFHModel(level,enumTime,symbolCount));      
    }
    return gameLevelData;
  },
  getXFHModel: function(level, time, symbolCount) {
    var symbolAll = util.sortArray(xiaofuhao_symbols)
    var numberAll = util.sortArray(xiaofuhao_number)
    var keys = this.randomSubDatas(symbolAll, symbolCount)
    var valules = this.randomSubDatas(numberAll, symbolCount)

    var resultData = {}
    for (let index = 0; index < keys.length; index++) {
      var key = keys[index];
      var value = valules[index]
      resultData[key] = value;
    }
    return resultData;
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
  
    var xiaofuhao_gameDatas1 = this.getXFHDataWithLevel(1);
    var xiaofuhao_gameDatas2 = this.getXFHDataWithLevel(2);
    var xiaofuhao_gameDatas3 = this.getXFHDataWithLevel(3);
    xiaofuhao_gameDatas = xiaofuhao_gameDatas1.concat(xiaofuhao_gameDatas2, xiaofuhao_gameDatas3);
  },
  tapKey: function(e) {
    return;
    
    var that = this

    console.log(e)
    var inputVal = e.currentTarget.dataset.key;

    var xfh_temp = that.data.xiaofuhao_currentData_test
    for (let key in xfh_temp) {
      if (xfh_temp[key].length == 0) {
        xfh_temp[key] = inputVal
        break;
      }
    }

    that.setData({
      xiaofuhao_currentData_test: xfh_temp
    })
    for (var key in xfh_temp) {
      if(xfh_temp[key].length == 0) {
        return;
      }
    }

    var correntAll = true
    for (var key in that.data.xiaofuhao_currentData) {
      if(that.data.xiaofuhao_currentData[key] != that.data.xiaofuhao_currentData_test[key]) {
        correntAll = false
        break
      }
    }

    that.setData({
      hideResult: false,
    })

    if(correntAll) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count,
        result: 1,
      })
    } else {
      that.setData({
        result: 0
      })
    }

    if(that.data.selectedIndex == xiaofuhao_gameDatas.length-1) {
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
   * 开始 - 按钮
   */
  hideShadowOneView: function () {
    var that = this
    that.setData({
      hideShadowOne: true,
      hideShadowThree: true,
      hideShadowTwo: false,
    })
  },

 /**
   * 开始 - 按钮
   */
  hideShadowTwoView: function () {
    var that = this
    that.setData({
      hideShadowOne: true,
      hideShadowTwo: true,
      hideShadowThree: false,
    })
    
  },

  /**
   * 开始 - 按钮
   */
  hideShadowThreeView: function () {
    var that = this
    that.setData({
      hideShadowOne: true,
      hideShadowTwo: true,
      hideShadowThree: true,
      hideGuoduye: false,
    })

    that.countDownTwo()
  },

  countDownTwo: function() {
    wx.setStorageSync('xiaofuhao_guide', true)
    this.setData({
      stepText: 5,
      isShowTimer: true
    })
    this.timerCircleReady();
    this.startCircleTime();
  }
})