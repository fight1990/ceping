// pages/components/jiaotongdeng_ydt/jiaotongdeng_ydt.js

var api = require("../../../Api/api.js")
const util = require("../../../utils/util.js");

//选择注意力训练
var trafficlight_canvasgraph = wx.createCanvasContext('trafficlight_canvasgraph',this)
var ctxTimer = wx.createCanvasContext("bgCanvas",this)
var ctxTimer_two = wx.createCanvasContext("bgCanvas_two",this)

var valHandle;  //定时器

var oW =  650.0 / util.getRpx() * 1.0;
var oH =  650.0 / util.getRpx() * 1.0;
// 线宽
var lineWidth = 2;
// 大半径
var r = (oW / 2);
var cR = r - 10 * lineWidth;

var trafficlight_gameDatas = [];
var timestamp = Date.parse(new Date());  

Component({
  /**
   * 组件的属性列表
   */
  properties: {

  },

  /**
   * 组件的初始数据
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

    hideGuoduye: true,
    hideGuoduye: true,
    hideShadowZero: false,
    hideShadowOne: true

  },

  /**
   * 组件的方法列表
   */
  methods: {
    _readyJiaoTongDengGame: function() {
      this.triggerEvent("readyJiaoTongDengGame");
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
     * 不相同
     */
    differentTap: function () {
      var that = this
      clearInterval(valHandle)  //销毁定时器

      that.setData({
        hideResult: false,
      })

      //选择注意力训练
      var currentData = trafficlight_gameDatas[that.data.selectedIndex];
      var beforeData = trafficlight_gameDatas[that.data.selectedIndex-1];
      if(currentData.position != beforeData.position) {
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
      if(that.data.selectedIndex == trafficlight_gameDatas.length-1) {
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

      that.setData({
        hideResult: false,
      })

      //选择注意力训练
      var currentData = trafficlight_gameDatas[that.data.selectedIndex];
      var beforeData = trafficlight_gameDatas[that.data.selectedIndex-1];
      if(currentData.position == beforeData.position) {
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
      if(that.data.selectedIndex == trafficlight_gameDatas.length-1) {
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


      })

      timestamp = Date.parse(new Date());
      that.doNext()
    },
    /**
     * 下一题
     */
    doNext: function () {
      var that = this

      if(that.data.selectedIndex == trafficlight_gameDatas.length-1) {
        that.lastQuestion()
        return
      }
  
      that.data.isAnswer = false
  
      var nextIndex = that.data.selectedIndex + 1
      var time = '';
      if (trafficlight_gameDatas[nextIndex]) {
        time = trafficlight_gameDatas[nextIndex].time;
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

      //选择注意力训练
      that.trafficlight_gameCreater();
    },

    /**
     * 判断是否是最后一题
     */
    lastQuestion: function () {
      var that = this

      //选择注意力训练
      var timesend = Date.parse(new Date());  
      var spandTimer = Math.floor((timesend - timestamp) / 1000) - trafficlight_gameDatas.length - trafficlight_gameDatas[0].time;

      var rightCount = that.data.rightCount
      that.setData({
        globalTimer: spandTimer,
        jtd_time: spandTimer,
        jtd_correct: rightCount
      })
      that.gotoGuoDuPage()
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

      //选择注意力训练
      that.data.stepText = trafficlight_gameDatas[this.data.selectedIndex].time //重新设置一遍初始值，防止初始值被改变
      
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
          that._readyJiaoTongDengGame()
        }
      },100)
    },

    /**
     * 选择注意力训练游戏
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
      // this.startCircleTime(ctxTimer);
    },

    /**
     * 选择注意力训练游戏数据
     */
    countWithTraffixLightLevel: function(level) {
      var gameCount = [];
      /**
       第一位：题目数量；
      第二位: 时间要求(毫秒)；
      第三位: 符号数
      */
      switch (level) {
        case 1:
          gameCount = [15,'4'];
          break;
        case 2:
          gameCount = [30,'3'];
          break;
        case 3:
          gameCount = [40,'2'];
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

    getTraffixLightModel: function(level, time) {
      var position = Math.floor(Math.random()*(3));
      return {'color': 'Green',
              'position': position,
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
      var trafficlight_gameDatas1 = this.getTraffixLightDataWithLevel(1);
      var trafficlight_gameDatas2 = this.getTraffixLightDataWithLevel(1);
      var trafficlight_gameDatas3 = this.getTraffixLightDataWithLevel(1);
      trafficlight_gameDatas = trafficlight_gameDatas1.concat(trafficlight_gameDatas2,trafficlight_gameDatas3)
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

    hideShadowZeroView: function() {
      var that = this
      that.setData({
        hideGuoduye: true,
        hideBottom: false,
        hideShadowZero: true,
        hideShadowOne: false,
      })
    },
    /**
     * 我知道了 - 按钮
     */
    hideShadowView: function () {
      var that = this
      that.setData({
        hideGuoduye: false,
        hideShadowZero: true,
        hideShadowOne: true
      })
      ctxTimer_two.clearRect(0,0,oW,oH)
      that.countDownTwo()
    },

    countDownTwo: function() {
      this.setData({
        stepText: 5,
        isShowTimer: true
      })
      this.timerCircleReady(ctxTimer_two);
      this.startCircleTime(ctxTimer_two);
    }
  },
  
  /**
   * 生命周期
   */
  lifetimes: {
    created:function() {
      this.makeGameDatas();
    },
    ready:function() {
      trafficlight_canvasgraph = wx.createCanvasContext('trafficlight_canvasgraph',this)
      ctxTimer = wx.createCanvasContext("bgCanvas",this)
      ctxTimer_two = wx.createCanvasContext("bgCanvas_two",this)

      this.moreTap()
    },
    detached: function () {
      clearInterval(valHandle)  //销毁定时器
    }
  },


  hideShadowZeroView: function() {
    var that = this
    that.setData({
      hideGuoduye: true,
      hideBottom: false,
      hideShadowZero: false,
      hideShadowOne: false,
    })
  },
  /**
   * 我知道了 - 按钮
   */
  hideShadowView: function () {
    var that = this
    that.setData({
      hideGuoduye: false,
      hideShadowZero: true,
      hideShadowOne: true
    })
    ctxTimer_two.clearRect(0,0,oW,oH)
    that.countDownTwo()
  },

  countDownTwo: function() {
    this.setData({
      stepText: 5,
      isShowTimer: true
    })
    this.timerCircleReady(ctxTimer_two);
    this.startCircleTime(ctxTimer_two);
  }
})
