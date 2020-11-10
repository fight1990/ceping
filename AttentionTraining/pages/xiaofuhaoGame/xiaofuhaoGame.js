// pages/xiaofuhaoGame/xiaofuhaoGame.js
// pages/siterupuGame/siterupuGame.js
var api = require("../../Api/api.js")
const util = require("../../utils/util.js");

var valHandle;  //定时器
const ctxTimer = wx.createCanvasContext("bgCanvas")

var timestamp = Date.parse(new Date());  

var xiaofuhao_gameDatas = [];

const xiaofuhao_symbols = ["@","#","%","《","*","(","{","}","》","】"]
const xiaofuhao_number = ["0","1","2","3","4","5","6","7","8","9"]

var isLoadingGame = false;

var isCurrentTimer = false;

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
    xiaofuhao_currentData : {},
    xiaofuhao_currentData_test : {},

    showIntroduce: false, // 显示简介
    rankPercent: '0.0%',

    xfh_time: 0,
    xfh_correct: 0,

    //键盘事件
    num: 0,
    hasDot: false, // 防止用户多次输入小数点

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
      two: "2.12",
      three: "秒",
      color:'red'
    }],
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
    if (this.data.isShowTimer && this.data.hideResultShadow && valHandle) {
      this.startCircleTime();
    }
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
    clearInterval(valHandle)  //销毁定时器
    isCurrentTimer = false;

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
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
  onShareAppMessage: function () {
    return {
      title: '答对'+this.data.rightCount+'题，超过'+this.data.rankPercent+'同龄人，让孩子训练专注力吧！'
    }
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
    var time = that.data.stepText
    var showTimer = false
    if (nextIndex >= 3) {
      showTimer = true
    }
    if (nextIndex == 3) {
      time = 180
      // if (xiaofuhao_gameDatas[that.data.selectedIndex]) {
      //   time = xiaofuhao_gameDatas[that.data.selectedIndex].time
      // }
    } else if(nextIndex == 8) {
      time = 150
      // if (xiaofuhao_gameDatas[that.data.selectedIndex]) {
      //   time = xiaofuhao_gameDatas[that.data.selectedIndex].time
      // }
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

    //小符号
    that.setData({
      xiaofuhao_currentData: xiaofuhao_gameDatas[that.data.selectedIndex],
      xiaofuhao_currentData_test: xiaofuhao
    })

    if (that.data.selectedIndex == 3) {
      this.timerCircleReady();
      this.startCircleTime();
    } else if (that.data.selectedIndex == 7) {
      this.timerCircleReady();
      this.startCircleTime();
    }
  },

  /**
   * 判断是否是最后一题
   */
  lastQuestion: function () {
    var that = this

    //小符号
    var timesend = Date.parse(new Date());  
    var spandTimer = Math.floor((timesend - timestamp) / 1000);

    var rightCount = that.data.rightCount
    that.setData({
      globalTimer: spandTimer,
      xfh_time: spandTimer,
      xfh_correct: rightCount
    })
    that.senderGameDatas();
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
                    score: that.data.xfh_correct,
                    times: that.data.globalTimer,
                    nickname: res.data.nickName,
                    headUrl: res.data.avatarUrl,
                    city: res.data.city,
                    openid: res.data.openid,
                    type: 1
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
                          two: that.data.globalTimer,
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

        // if(that.data.selectedIndex < 7) {
        //   that.setData({
        //     selectedIndex: 6
        //   })
        //   that.doNext();
        // } else {
          that.lastQuestion()
        // }
      }
    },100)
  },

  /**
   * 小符号游戏
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
      //错误就停止游戏
      that.lastQuestion();
      return;
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

  /**
   * 小符号游戏数据
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
        gameCount = [3,'0',5];
        break;
      case 2:
        gameCount = [5,'180',7];
        break;
      case 3:
        gameCount = [5,'150',10];
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
    var that = this

    console.log(e)
    var inputVal = e.currentTarget.dataset.key;

    var xfh_temp = that.data.xiaofuhao_currentData_test
    var temp_key = ''
    for (let key in xfh_temp) {
      if (xfh_temp[key].length == 0) {
        xfh_temp[key] = inputVal
        temp_key = key
        break;
      }
    }

    that.setData({
      xiaofuhao_currentData_test: xfh_temp
    })

    /*
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
  */

    that.setData({
      hideResult: false,
    })

    // if(correntAll) {
    if(that.data.xiaofuhao_currentData[temp_key] == inputVal) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count,
        result: 1,
      })
    } else {
      that.setData({
        result: 0
      })
      // 错误就结束
      that.lastQuestion()
      return
    }

    for (var key in xfh_temp) {
      if(xfh_temp[key].length == 0) {
        return;
      }
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
  }
})