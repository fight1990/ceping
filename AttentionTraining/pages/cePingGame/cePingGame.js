// pages/cePingGame/cePingGame.js

var api = require("../../Api/api.js")
const util = require("../../utils/util.js");

//交通灯
const trafficlight_canvasgraph = wx.createCanvasContext('trafficlight_canvasgraph')

// 快速记忆
const ksjy_ctxWave = wx.createCanvasContext('ksjy_canvasArcCir')
const ksjy_ctxGraph = wx.createCanvasContext('ksjy_canvasgraph')

//斯特如普
const siterupu_ctxtext = wx.createCanvasContext('siterupu_canvas_text')
const siterupu_ctxtext_Graph = wx.createCanvasContext('siterupu_canvas_graph')

var valHandle;  //定时器
const ctxTimer = wx.createCanvasContext("bgCanvas")
const ctxTimer_two = wx.createCanvasContext("bgCanvas_two")

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
var soffset = -(PI / 2); // 圆动画起始位置

// 水波动画初始参数
var axisLength = 2 * r - 16 * lineWidth;  // Sin 图形长度
var unit = axisLength / 9; // 波浪宽
var range = .4 // 浪幅
var nowrange = range;
var xoffset = 8 * lineWidth; // x 轴偏移量

// 圆动画初始参数
var arcStack = [];  // 圆栈
var bR = r - 8 * lineWidth;

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
const _tipContent1 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;形状\n是否与前面相同"
const _tipContent2 = "&nbsp;&nbsp;&nbsp;形状和颜色\n是否与前面相同"

var timestamp = Date.parse(new Date());  

var trafficlight_gameDatas = [];

var ksjy_gameDatas = [];

var xiaofuhao_gameDatas = [];
var siterupu_gameDatas = [];

const xiaofuhao_symbols = ["@","#","%","《","*","(","{","}","》","】"]
const xiaofuhao_number = ["0","1","2","3","4","5","6","7","8","9"]

const siterupu_colors = ['red','yellow','green','blue','purple']
const siterupu_words = ['纡','红','璜','黄','录','绿','监','蓝','橴','紫']
const siterupu_words_simple = ['红','黄','绿','蓝','紫']

const siterupu_wordForColor = {'red':'红','yellow':'黄','green':'绿','blue':'蓝','purple':'紫'}

 var jtd_list = []
 var xfh_list = []
 var ksjy_list = []
 var strp_list = []

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
    stepText: 5,  //设置倒计时初始值
    hideResultShadow: true, // 是否隐藏结果
    ksjy_canvasContent: _tipContent1,

    hiddenSTRPGraph: true,
    strp_content_title : "文字颜色与其表达的意思是否相同？",
    siterupu_color_word: "",
    /**
     * 游戏模式 0-交通灯；1-小符号；2-快速记忆；3-斯特如普
     */
    currentGameType: 0,

    isShowTimer: true,
    xiaofuhao_currentData : {},
    xiaofuhao_currentData_test : {},

    jtd_time: 0,
    jtd_correct: 0,
    xfh_time: 0,
    xfh_correct: 0,
    ksjy_time: 0,
    ksjy_correct: 0,
    strp_time: 0,
    strp_correct: 0,

    // 过渡页、引导页参数
    hideGuoduye: true,
    guoduyeTitle: "即将进入小符号游戏",
    hiddenYinDaoTu: false,
    yindaotuIndex: 0,
    age: -1, // 年纪
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.makeGameDatas();
    
    // 计算年龄
    let age = util.getAge(wx.getStorageSync('age_player'))
    this.data.age = parseInt(age)
    console.log(age)
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
    var totalCorrect = that.data.jtd_correct + that.data.xfh_time + that.data.ksjy_correct + that.data.strp_correct;
    var totalTime = that.data.jtd_time + that.data.xfh_time + that.data.ksjy_time + that.data.strp_time;
    that.setData({
      hideResultShadow: false,
      rightCount: totalCorrect,
      globalTimer: totalTime,
    })
  },

  /**
   * 不相同
   */
  differentTap: function () {
    var that = this
    clearInterval(valHandle)  //销毁定时器

    that.setData({
      hideResult: false,
    })

    if (this.data.currentGameType == 0) {
      //交通灯
      var currentData = trafficlight_gameDatas[that.data.selectedIndex];
      var beforeData = trafficlight_gameDatas[that.data.selectedIndex-1];
      if(currentData.position != beforeData.position) {
        var count = that.data.rightCount + 1
        that.setData({
          rightCount: count,
          result: 1
        })
        jtd_list.push(1)
      } else {
        that.setData({
          result: 0
        })
        jtd_list.push[0]
      }
      if(that.data.selectedIndex == trafficlight_gameDatas.length-1) {
        that.lastQuestion()
        return
      } else {
        // 下一题
        setTimeout(function () {
          that.doNext();
        }, 1000);
      }
    } else if (this.data.currentGameType == 1) {
      //小符号
      
    } else if (this.data.currentGameType == 2) {
      //快速记忆
      var currentData = ksjy_gameDatas[that.data.selectedIndex];
      var beforeData = ksjy_gameDatas[that.data.selectedIndex-1];
      if(currentData.color != beforeData.color || currentData.shape != beforeData.shape) {
        var count = that.data.rightCount + 1
        that.setData({
          rightCount: count,
          result: 1
        })
        ksjy_list.push[1]
      } else {
        that.setData({
          result: 0
        })
        ksjy_list.push[0]
      }
      if(that.data.selectedIndex == ksjy_gameDatas.length-1) {
        that.lastQuestion()
        return
      } else {
        // 下一题
        setTimeout(function () {
          that.doNext();
        }, 1000);
      }
    }  else if (this.data.currentGameType == 3) {
      //斯特如普
      var currentData = siterupu_gameDatas[that.data.selectedIndex];
      var color = currentData.color;
      if(siterupu_wordForColor[color] != currentData.text) {
        var count = that.data.rightCount + 1
        that.setData({
          rightCount: count,
          result: 1
        })
        strp_list.push[1]
      } else {
        that.setData({
          result: 0
        })
        strp_list.push(0)
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
    } 
  },

  /**
   * 相同
   */
  identicalTap: function () {
    var that = this
    clearInterval(valHandle)  //销毁定时器

    that.setData({
      hideResult: false,
    })

    if (this.data.currentGameType == 0) {
      //交通灯
      var currentData = trafficlight_gameDatas[that.data.selectedIndex];
      var beforeData = trafficlight_gameDatas[that.data.selectedIndex-1];
      if(currentData.position == beforeData.position) {
        var count = that.data.rightCount + 1
        that.setData({
          rightCount: count,
          result: 1
        })
        jtd_list.push(1)
      }  else {
        that.setData({
          result: 0
        })
        jtd_list.push(0)
      }
      if(that.data.selectedIndex == trafficlight_gameDatas.length-1) {
        that.lastQuestion()
        return
      } else {
        // 下一题
        setTimeout(function () {
          that.doNext();
        }, 1000);
      }
    } else if (this.data.currentGameType == 1) {
      //小符号

    } else if (this.data.currentGameType == 2) {
      //快速记忆
      var currentData = ksjy_gameDatas[that.data.selectedIndex];
      var beforeData = ksjy_gameDatas[that.data.selectedIndex-1];
      if(currentData.color == beforeData.color && currentData.shape == beforeData.shape) {
        var count = that.data.rightCount + 1
        that.setData({
          rightCount: count,
          result: 1
        })
        ksjy_list.push(1)
      }  else {
        that.setData({
          result: 0
        })
        ksjy_list.push(0)
      }
      if(that.data.selectedIndex == ksjy_gameDatas.length-1) {
        that.lastQuestion()
        return
      } else {
        // 下一题
        setTimeout(function () {
          that.doNext();
        }, 1000);
      }
    }  else if (this.data.currentGameType == 3) {
      //斯特如普
      var currentData = siterupu_gameDatas[that.data.selectedIndex];
      var color = currentData.color;
      if(siterupu_wordForColor[color] == currentData.text) {
        var count = that.data.rightCount + 1
        that.setData({
          rightCount: count,
          result: 1
        })
        strp_list.push(1)
      }  else {
        that.setData({
          result: 0
        })
        strp_list.push(0)
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

      currentGameType: 0,

      jtd_time: 0,
      jtd_correct: 0,
      xfh_time: 0,
      xfh_correct: 0,
      ksjy_time: 0,
      ksjy_correct: 0,
      strp_time: 0,
      strp_correct: 0,

      // 过渡页、引导页参数
      hideGuoduye: true,
      guoduyeTitle: "即将进入小符号游戏",

      hiddenYinDaoTu: false,
      yindaotuIndex: 0
    })

    jtd_list = [],
    xfh_list = [],
    ksjy_list = [],
    strp_list = []
  },
  
  startingGame: function() {
    timestamp = Date.parse(new Date());
    this.doNext()
  },
  /**
   * 下一题
   */
  doNext: function () {
    var that = this

    if (this.data.currentGameType == 0) {
      if(that.data.selectedIndex == trafficlight_gameDatas.length-1) {
        that.lastQuestion()
        return
      }
  
      that.data.isAnswer = false
  
      var nextIndex = that.data.selectedIndex + 1
      var time = 5;
      if (trafficlight_gameDatas[nextIndex]) {
        time = parseInt(trafficlight_gameDatas[nextIndex].time);
      }
      that.setData({
        selectedIndex: nextIndex,
        stepText: time
      })
      
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

      //交通灯
      that.trafficlight_gameCreater();
    } else if (this.data.currentGameType == 1) {
      if(that.data.selectedIndex == xiaofuhao_gameDatas.length-1) {
        that.lastQuestion()
        return
      }
  
      that.data.isAnswer = false
  
      var nextIndex = that.data.selectedIndex + 1
      var time = that.data.stepText
      var showTimer = false
      if (nextIndex >= 15) {
        showTimer = true
      }
      if (nextIndex == 15) {
        time = 180
      } else if(nextIndex == 45) {
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

      //小符号
      that.setData({
        xiaofuhao_currentData: xiaofuhao_gameDatas[that.data.selectedIndex],
        xiaofuhao_currentData_test: xiaofuhao
      })

      if (that.data.selectedIndex == 15) {
        this.timerCircleReady(ctxTimer);
        this.startCircleTime(ctxTimer);
      } else if (that.data.selectedIndex == 45) {
        this.timerCircleReady(ctxTimer);
        this.startCircleTime(ctxTimer);
      }
    } else if (this.data.currentGameType == 2) {
      
      if(that.data.selectedIndex == ksjy_gameDatas.length-1) {
        that.lastQuestion()
        return
      }
  
      that.data.isAnswer = false
  
      var nextIndex = that.data.selectedIndex + 1
      var time = 5;
      if (ksjy_gameDatas[nextIndex]) {
        time = parseInt(ksjy_gameDatas[nextIndex].time);
      }
      that.setData({
        selectedIndex: nextIndex,
        stepText: time
      })
      
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

      //快速记忆
      that.ksjy_CircleCreater();
      
    }  else if (this.data.currentGameType == 3) {

      //斯特如普
      if(that.data.selectedIndex == siterupu_gameDatas.length-1) {
        that.lastQuestion()
        return
      }
  
      that.data.isAnswer = false
  
      var nextIndex = that.data.selectedIndex + 1
      var time = 5;
      var siterupu_color_word = that.data.siterupu_color_word
      if (siterupu_gameDatas[nextIndex]) {
        time = parseInt(siterupu_gameDatas[nextIndex].time);
        siterupu_color_word = siterupu_gameDatas[nextIndex].text
      }
      var hiddenSTRPGraph = true
      var strp_content_title = "文字颜色与其表达的意思是否相同？";
      if (nextIndex < 20) {
        hiddenSTRPGraph = false;
        strp_content_title = "文字表达颜色与色块颜色是否一致？"
      } 

      that.setData({
        selectedIndex: nextIndex,
        stepText: time,
        hiddenSTRPGraph: hiddenSTRPGraph,
        strp_content_title: strp_content_title,
        siterupu_color_word: siterupu_color_word
      })
      
      that.setData({
        hideBottom: false,
      })
      
      that.setData({
        count: that.data.count,
        hideResult: true,
      })

      that.siterupu_createGame()
    } 
  },

  /**
   * 判断是否是最后一题
   */
  lastQuestion: function () {
    var that = this

    if (this.data.currentGameType == 0) {
      //交通灯
      var timesend = Date.parse(new Date());  
      var spandTimer = Math.floor((timesend - timestamp) / 1000) - trafficlight_gameDatas.length - trafficlight_gameDatas[0].time;

      var rightCount = that.data.rightCount
      that.setData({
        globalTimer: spandTimer,
        jtd_time: spandTimer,
        jtd_correct: rightCount
      })
      that.gotoGuoDuPage()

    } else if (this.data.currentGameType == 1) {
      //小符号
      var timesend = Date.parse(new Date());  
      var spandTimer = Math.floor((timesend - timestamp) / 1000);

      var rightCount = that.data.rightCount
      that.setData({
        globalTimer: spandTimer,
        xfh_time: spandTimer,
        xfh_correct: rightCount
      })
      that.gotoGuoDuPage()

    } else if (this.data.currentGameType == 2) {
      //快速记忆
      var timesend = Date.parse(new Date());  
      var spandTimer = Math.floor((timesend - timestamp) / 1000) - ksjy_gameDatas.length - ksjy_gameDatas[0].time;

      var rightCount = that.data.rightCount
      that.setData({
        globalTimer: spandTimer,
        ksjy_time: spandTimer,
        ksjy_correct: rightCount
      })
      that.gotoGuoDuPage()

    }  else if (this.data.currentGameType == 3) {
      //斯特如普
      var timesend = Date.parse(new Date());  
      var spandTimer = Math.floor((timesend - timestamp) / 1000);

      var rightCount = that.data.rightCount
      that.setData({
        globalTimer: spandTimer,
        strp_time: spandTimer,
        strp_correct: rightCount
      })
      that.showResultTap()
    } 
  },

  sendGameDatasToSever:function () {
    var that = this
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
                    openid: res.data.openid,
                    userid: result.user.id,
                    nickname: res.data.nickName,
                    headUrl: res.data.avatarUrl,
                    data: [{
                      type: 0,
                      time: that.data.jtd_time,
                      correctNumber: that.data.jtd_correct,
                      accuracy: trafficlight_gameDatas.length,
                      score: that.data.jtd_correct/trafficlight_gameDatas.length*1.0,
                      list: jtd_list
                    },{
                      type: 1,
                      time:that.data.xfh_time,
                      correctNumber: that.data.xfh_correct,
                      accuracy: xiaofuhao_gameDatas.length,
                      score: that.data.xfh_correct/xiaofuhao_gameDatas.length*1.0,
                      list: xfh_list
                    },{
                      type: 2,
                      time:that.data.ksjy_time,
                      correctNumber: that.data.ksjy_correct,
                      accuracy: ksjy_gameDatas.length,
                      score: that.data.ksjy_correct/ksjy_gameDatas.length*1.0,
                      list: ksjy_list
                    },{
                      type: 3,
                      time:that.data.strp_time,
                      correctNumber: that.data.strp_correct,
                      accuracy: siterupu_gameDatas.length,
                      score: that.data.strp_correct/siterupu_gameDatas.length*1.0,
                      list: strp_list
                    }],
                  }
                  api.saveGamesData({
                    data: params,
                    success: function (response) {
                      console.log(response)
                      wx.redirectTo({
                        url: '/pages/zongheceping/zongheceping',
                      })
                    },
                    fail: function (res) {
                      
                    }
                  })
                } else {
                  
                }    
              } else {

              }
            },
            fail: function (res) {

            }
          })
        }
      },
      fail: function (res) {

      }
    })
  },

  moreNextTap: function() {
    timestamp = Date.parse(new Date());  

    var currentType = this.data.currentGameType + 1;
    this.setData({
      currentGameType: currentType,
      // 过渡页、引导页参数
      hideGuoduye: true,
    })
    if (this.data.currentGameType == 1) {
      this.setData({
        hideBottom: true,
        isShowTimer: false,
      })
    } else {
      this.setData({
        isShowTimer: true
      })
    }
    this.clearData()
    this.doNext();
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

    if (this.data.hideGuoduye == true) {
      if (this.data.currentGameType == 0) {
        //交通灯
        that.setData({
          stepText : parseInt(trafficlight_gameDatas[this.data.selectedIndex].time) //重新设置一遍初始值，防止初始值被改变
        })
      } else if (this.data.currentGameType == 1) {
        //小符号
        
      } else if (this.data.currentGameType == 2) {
        //快速记忆
        that.setData({
          stepText : parseInt(ksjy_gameDatas[this.data.selectedIndex].time) //重新设置一遍初始值，防止初始值被改变
        })

      }  else if (this.data.currentGameType == 3) {
        //斯特如普
        that.setData({
          stepText : parseInt(siterupu_gameDatas[this.data.selectedIndex].time) //重新设置一遍初始值，防止初始值被改变
        })
      } 
    }
    
    var step = that.data.stepText ;  //定义倒计时

    console.log("XXXXXXX - TIME: "+step);
    

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
      // that.rotateAni(++_animationIndex);

      that.setData({
        stepText: parseInt(step)
      })
      step = (step - 0.1).toFixed(1)

      num += decNum
      drawArc(num*Math.PI)
      if(step<=0){
        clearInterval(valHandle)  //销毁定时器
        if (that.data.hideGuoduye == false) {
          that.showYinDaoTu()
        } /*else if(that.data.hiddenYinDaoTu == false) {
          that.showGuideView();
        } */else {
          if(that.data.currentGameType == 1) {
            if(that.data.selectedIndex < 45) {
              that.setData({
                selectedIndex: 44
              })
              that.doNext();
            } else {
              that.lastQuestion()
            }
          } else {
            that.doNext()
          }
        }
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
      xfh_list.push(1)
    } else {
      that.setData({
        result: 0
      })
      xfh_list.push(0)
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
      xfh_list.push(1)
    } else {
      that.setData({
        result: 0
      })
      xfh_list.push(0)
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
  },

  /**
   * 交通灯游戏
   */
  trafficlight_gameCreater: function() {
    trafficlight_canvasgraph.clearRect(0, 0, oW, oH);
    var currentData = trafficlight_gameDatas[this.data.selectedIndex];
    var index = currentData.position;
    
    if (index == 0) {
      this.drawFillPolygon(r,50,30,0,0,"Green",trafficlight_canvasgraph);
      this.drawFillPolygon(r,r,30,0,0,"White",trafficlight_canvasgraph);
      this.drawFillPolygon(r,2*r-50,30,0,0,"White",trafficlight_canvasgraph);
    } else if (index == 1) {
      this.drawFillPolygon(r,50,30,0,0,"White",trafficlight_canvasgraph);
      this.drawFillPolygon(r,r,30,0,0,"Green",trafficlight_canvasgraph);
      this.drawFillPolygon(r,2*r-50,30,0,0,"White",trafficlight_canvasgraph);
    } else {
      this.drawFillPolygon(r,50,30,0,0,"White",trafficlight_canvasgraph);
      this.drawFillPolygon(r,r,30,0,0,"White",trafficlight_canvasgraph);
      this.drawFillPolygon(r,2*r-50,30,0,0,"Green",trafficlight_canvasgraph);
    }

    trafficlight_canvasgraph.draw();

    this.timerCircleReady(ctxTimer);
    this.startCircleTime(ctxTimer);
  },

  /**
   * 快速记忆图形绘制
   */
  //绘制圆圈进度
  ksjy_CircleCreater: function() {
    // 获取圆动画轨迹点集
    for (var i = soffset; i < soffset + 2 * PI; i += 1 / (8 * PI)) {
      arcStack.push([
        r + bR * Cos(i),
        r + bR * Sin(i)
      ])
    }
    // 圆起始点
    var cStartPoint = arcStack.shift();
    ksjy_ctxWave.strokeStyle = "black";
    ksjy_ctxWave.moveTo(cStartPoint[0], cStartPoint[1]);
    // 开始渲染
    this.ksjy_render();
  },

  ksjy_drawText: function() {
    var txt = _tipContent1;
    if (this.data.selectedIndex > 35) {
      txt = _tipContent2;
    }
    this.setData({
      ksjy_canvasContent:txt
    })
  },
  ksjy_drawTriangle: function() {
    if (ksjy_gameDatas[this.data.selectedIndex] == undefined) {
      return;
    }

    var hudu1 = Math.floor(Math.random() * 60) * Math.PI / 180;
    var X1 = r + Math.sin(hudu1) * cR ;
    var Y1 = r - Math.cos(hudu1) * cR ;
    this.drawFillPolygon(X1,Y1,(r-cR),ksjy_gameDatas[this.data.selectedIndex].shape,0,ksjy_gameDatas[this.data.selectedIndex].color,ksjy_ctxGraph);

    var hudu2 = Math.floor(Math.random() * 60 + 120) * Math.PI / 180;
    var X2 = r + Math.sin(hudu2) * cR ;
    var Y2 = r - Math.cos(hudu2) * cR ;
    this.drawFillPolygon(X2,Y2,(r-cR),ksjy_gameDatas[this.data.selectedIndex].shape,0,ksjy_gameDatas[this.data.selectedIndex].color,ksjy_ctxGraph);

    var hudu3 = Math.floor(Math.random() * 60 + 240) * Math.PI / 180;
    var X3 = r + Math.sin(hudu3) * cR ;
    var Y3 = r - Math.cos(hudu3) * cR ;
    this.drawFillPolygon(X3,Y3,(r-cR),ksjy_gameDatas[this.data.selectedIndex].shape,0,ksjy_gameDatas[this.data.selectedIndex].color,ksjy_ctxGraph);

    // this.drawFillPolygon(r,(r-cR)*2.2,(r-cR),ksjy_gameDatas[this.data.selectedIndex].shape,0,ksjy_gameDatas[this.data.selectedIndex].color,ksjy_ctxGraph);
    // this.drawFillPolygon((r-cR)*2.2,r,(r-cR),ksjy_gameDatas[this.data.selectedIndex].shape,0,ksjy_gameDatas[this.data.selectedIndex].color,ksjy_ctxGraph);
    // this.drawFillPolygon(r+cR-(r-cR)*1.2,r,(r-cR),ksjy_gameDatas[this.data.selectedIndex].shape,0,ksjy_gameDatas[this.data.selectedIndex].color,ksjy_ctxGraph);
  },
  //灰色圆圈
  ksjy_grayCircle: function() {
    ksjy_ctxWave.beginPath();
    ksjy_ctxWave.lineWidth = 15;
    ksjy_ctxWave.strokeStyle = '#DADCFD';
    ksjy_ctxWave.arc(r, r, cR-10, 0, 2 * Math.PI);
    ksjy_ctxWave.stroke();
    ksjy_ctxWave.restore();
    ksjy_ctxWave.save();
    ksjy_ctxWave.beginPath();
  },
 
  //渲染canvas
  ksjy_render: function() {
    ksjy_ctxWave.clearRect(0, 0, oW, oH);
    ksjy_ctxGraph.clearRect(0, 0, oW, oH);

    // 写字
    this.ksjy_drawText();
     //绘制形状图
    this.ksjy_drawTriangle();
    ksjy_ctxGraph.draw()
    
    //灰色圆圈  
    this.ksjy_grayCircle();
    ksjy_ctxWave.draw();

    this.timerCircleReady(ctxTimer);
    this.startCircleTime(ctxTimer);
  },

  clearData: function() {
    this.setData({
      selectedIndex: -1,
      result: 0, // 结果对错 0-错 1-对
      hideBottom: true, // 隐藏底部判断视图
      hideResult: true, // 隐藏结果视图
      rightCount: 0, // 对的题目数量
      globalTimer: 0, //游戏计时器
      stepText: 5,  //设置倒计时初始值
      hideResultShadow: true, // 是否隐藏结果
    })
  },

   /**
   * 斯特如普游戏
   */
  siterupu_createGame: function() {
    var txt = siterupu_gameDatas[this.data.selectedIndex].text
    var color = siterupu_gameDatas[this.data.selectedIndex].color

    //图形
    siterupu_ctxtext_Graph.clearRect(0, 0, oW, oH)
    siterupu_ctxtext_Graph.beginPath();
    siterupu_ctxtext_Graph.rect(0,0,600,200);
    siterupu_ctxtext_Graph.setFillStyle(color)
    siterupu_ctxtext_Graph.fill()
    siterupu_ctxtext_Graph.draw()

    //文字
    siterupu_ctxtext.clearRect(0, 0, oW, oH)
    siterupu_ctxtext.globalCompositeOperation = 'source-over'
    siterupu_ctxtext.font = 'bold 60rpx Microsoft Yahei'

    siterupu_ctxtext.fillStyle = color
    siterupu_ctxtext.textAlign = 'center'
    siterupu_ctxtext.fillText(txt, r, 75)

    siterupu_ctxtext.draw()

    this.timerCircleReady(ctxTimer);
    this.startCircleTime(ctxTimer);
  },
  
  /**
   * 快速记忆游戏数据
   * @param {*} level 
   */
  countWithMemoryLevel: function(level) {
    var gameCount = [];
    /**
     第一位：题目数量；
     第二位: 时间要求(毫秒)；
     第三位：颜色数量；
     第四位：图形数量;
     */

    let countOne = ""
    let countTwo = ""
    let countThree = ""

    if (this.data.age < 8) {
      countOne = "4"
      countTwo = "3"
      countThree = "2"
    } else {
      countOne = "3"
      countTwo = "2"
      countThree = "2.5"
    }

    switch (level) {
      case 1:
        gameCount = [20,countOne,1,6];
        break;
      case 2:
        gameCount = [30,countTwo,1,6];
        break;
      case 3:
        gameCount = [35,countThree,5,6];
          break;
      default:
        break;
    }
    return gameCount;
  },
  getMemoryDataWithLevel: function (level) {
    var gameLevelData = [];
    var datas = this.countWithMemoryLevel(level);
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

  /**
   * 交通灯游戏数据
   */
  countWithTraffixLightLevel: function(level) {
    var gameCount = [];
    /**
     第一位：题目数量；
     第二位: 时间要求(毫秒)；
     第三位: 符号数
     */

    let countOne = ""
    let countTwo = ""
    let countThree = ""

    if (this.data.age < 8) {
      countOne = "4"
      countTwo = "3"
      countThree = "2"
    } else {
      countOne = "3"
      countTwo = "2"
      countThree = "1.5"
    }

    switch (level) {
      case 1:
        gameCount = [15,countOne];
        break;
      case 2:
        gameCount = [30,countTwo];
        break;
      case 3:
        gameCount = [40,countThree];
          break;
      default:
        break;
    }
    return gameCount;
  },

  getTraffixLightDataWithLevel: function (level) {
    var gameLevelData = [];
    var datas = this.countWithTraffixLightLevel(level);
    var maxCount = datas[0];
    var enumTime = datas[1];
    for (let index = 0; index < maxCount; index++) {
      gameLevelData.push(this.getTraffixLightModel(level,enumTime));      
    }
    return gameLevelData;
  },

  getTraffixLightModel: function(level, etime) {
    var position = Math.floor(Math.random()*(3));
    return {'color': 'Green',
            'position': position,
            'level': level,
            'time': etime
          };
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

    let countOne = ""
    let countTwo = ""
    let countThree = ""

    if (this.data.age > 7) {
      countOne = "0"
      countTwo = "120"
      countThree = "100"
    } else {
      countOne = "0"
      countTwo = "180"
      countThree = "150"
    }

    switch (level) {
      case 1:
        gameCount = [3,countOne,5];
        break;
      case 2:
        gameCount = [4,countTwo,7];
        break;
      case 3:
        gameCount = [4,countThree,10];
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
  getXFHModel: function(level, etime, symbolCount) {
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
   * 斯特如普游戏数据
   */
  countWithSTRPLevel: function(level) {
    var gameCount = [];
    /**
     第一位：题目数量；
     第二位: 时间要求(毫秒)；
     第三位: 符号数
     */

    let countOne = ""
    let countTwo = ""
    let countThree = ""

    if (this.data.age > 7) {
      countOne = "4"
      countTwo = "3"
      countThree = "2"
    } else {
      countOne = "5"
      countTwo = "4"
      countThree = "3"
    }

    switch (level) {
      case 1:
        gameCount = [20,countOne];
        break;
      case 2:
        gameCount = [30,countTwo];
        break;
      case 3:
        gameCount = [35,countThree];
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

  getSTRPModel: function(level, etime) {
    var i = Math.floor(Math.random()*(siterupu_words.length));
    var j = Math.floor(Math.random()*(siterupu_colors.length));
    var tmpWord = siterupu_words[i];
    var tmpColor = siterupu_colors[j];
    if (level == 1 || level == 2) {
      i = Math.floor(Math.random()*(siterupu_words_simple.length));
      var tmpWord = siterupu_words_simple[i];
    }
    return {'color': tmpColor,
            'text': tmpWord,
            'level': level,
            'time': etime
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
    var trafficlight_gameDatas1 = this.getTraffixLightDataWithLevel(1);
    var trafficlight_gameDatas2 = this.getTraffixLightDataWithLevel(2);
    var trafficlight_gameDatas3 = this.getTraffixLightDataWithLevel(3);
    trafficlight_gameDatas = trafficlight_gameDatas1.concat(trafficlight_gameDatas2,trafficlight_gameDatas3)

    var xiaofuhao_gameDatas1 = this.getXFHDataWithLevel(1);
    var xiaofuhao_gameDatas2 = this.getXFHDataWithLevel(2);
    var xiaofuhao_gameDatas3 = this.getXFHDataWithLevel(3);
    xiaofuhao_gameDatas = xiaofuhao_gameDatas1.concat(xiaofuhao_gameDatas2, xiaofuhao_gameDatas3);

    var ksjy_gameDatas1 = this.getMemoryDataWithLevel(1);
    var ksjy_gameDatas2 = this.getMemoryDataWithLevel(2);
    var ksjy_gameDatas3 = this.getMemoryDataWithLevel(3);
    ksjy_gameDatas = ksjy_gameDatas1.concat(ksjy_gameDatas2, ksjy_gameDatas3);

    var siterupu_gameDatas1 = this.getSTRPDataWithLevel(1);
    var siterupu_gameDatas2 = this.getSTRPDataWithLevel(2);
    var siterupu_gameDatas3 = this.getSTRPDataWithLevel(3);
    siterupu_gameDatas = siterupu_gameDatas1.concat(siterupu_gameDatas2, siterupu_gameDatas3);

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
  drawFillPolygon: function(xCenter, yCenter,radius,sides,alpha,color,ctxGraph) {
    ctxGraph.beginPath();
    ctxGraph.fillStyle = color;
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
  
  // 游戏过度
  gotoGuoDuPage: function() {
    var guoduTitle = "即将进入交通灯测评";
    if (this.data.currentGameType == 0) {
      guoduTitle = "交通灯答题结束\n即将进入小符号测验";
    } else if (this.data.currentGameType == 1) {
      guoduTitle = "小符号答题结束\n即将进入快速记忆测验";
    } else if (this.data.currentGameType == 2) {
      guoduTitle = "快速记忆答题结束\n即将进入斯特如普测验";
    }
    this.setData({
      hideGuoduye: false,
      stepText: 5,
      isShowTimer: true,
      guoduyeTitle: guoduTitle,
    })

    this.timerCircleReady(ctxTimer_two);
    this.startCircleTime(ctxTimer_two);
  },

  showYinDaoTu: function () {
    console.log("引导图显示： "+this.data.yindaotuIndex);
    
    this.setData({
      hideGuoduye: true,
      hiddenYinDaoTu: false,
    })
  },

  _readyJiaoTongDengGame (){
    console.log("开始交通灯游戏");
    
    var that = this
    this.setData({
      hiddenYinDaoTu: true,
      yindaotuIndex: 1
    })
    that.startingGame()
  },
  _readyXiaoFuHaoGame () {
    console.log("开始小符号游戏");
    
    var that = this
    that.setData({
      hiddenYinDaoTu: true,
      yindaotuIndex: 2
    })
    that.moreNextTap()
  },
  _readyKuaiSuJiYiGame () {
    console.log("开始快速记忆游戏");

    var that = this
    that.setData({
      hiddenYinDaoTu: true,
      yindaotuIndex: 3
    })
    that.moreNextTap()
  },
  _readySiTeRuPuGame () {
    console.log("开始斯特如普游戏");

    var that = this
    that.setData({
      hiddenYinDaoTu: true,
      yindaotuIndex: 0
    })
    that.moreNextTap()
  }

})