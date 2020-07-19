// pages/siterupuGuide/siterupuGuide.js

var api = require("../../Api/api.js")
const ctx2 = wx.createCanvasContext('runCanvas')

Page({

  /**
   * 页面的初始数据
   */
  data: {
    answerList: Array(10), // 题目总数
    selectedIndex: -1,


    count: 4, // 倒计时
    timer: '',// 出题定时器名字
    hideBottom: true, // 隐藏底部判断视图
    hideResult: true, // 隐藏结果视图

    hideTipShadow: true, // 是否隐藏继续作答
    hideResultShadow: true, // 是否隐藏结果
    scrId: 0,
 
    hideShadowOne: false, // 显示透明视图
    showGuoduye: true, // 显示过渡页面

    timerTwo: '', // 过渡页面倒计时
    countTwo: 4, // 倒计时
  },

    /**
   * 我知道了 - 按钮
   */
  hideShadowView: function () {
    var that = this
    that.stopTimer() 

    wx.navigateTo({
      url: '/pages/siterupu/siterupu',
    })
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
   * 绘制canvas
   */
  drawProgressbg: function (paramId) {
    // 使用 wx.createContext 获取绘图上下文 context
    var ctx = wx.createCanvasContext(paramId)
    ctx.setLineWidth(8);// 设置圆环的宽度
    ctx.setStrokeStyle('#D9D9D9'); // 设置圆环的颜色
    ctx.setLineCap('round') // 设置圆环端点的形状
    ctx.beginPath();//开始一个新的路径
    ctx.arc(65, 65, 35, 0, 2 * Math.PI, false);
    //设置一个原点(100,100)，半径为90的圆的路径到当前路径
    ctx.stroke();//对当前路径进行描边
    ctx.draw();
  },


  /**
   * 暂停倒计时
   */
  stopTimer: function (){
    var that = this
    clearInterval(that.data.timer)
    clearInterval(that.data.timerTwo)
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
   * 滑动
   */
  scrollTap: function (e) {
    var that = this
    that.data.scrId = that.data.scrId + 1
    that.setData({
      scrId: that.data.scrId,
    })
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
    })

    var param = { isAnswer: that.data.isAnswer }
    that.countDown(param)
  },




  /**
   * 出题计时器
   */
  countDown: function (param) {  
    let that = this;
    let newCount = that.data.count;//获取倒计时初始值
    var step = 1,//计数动画次数
      num = 0,//计数倒计时秒数（n - num）
      start = 1.5 * Math.PI,// 开始的弧度
      end = -0.5 * Math.PI,// 结束的弧度
      time = null;// 计时器容器

    var  n = newCount; // 当前倒计时为多少秒
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
      context.setStrokeStyle('#21AEFF')
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
        }
      }, 1000)
    })  
  },

    /**
   * 出题计时器
   */
  countDownTwo: function () {  
    let that = this;
    let newCount = that.data.countTwo;//获取倒计时初始值
    var step = 1,//计数动画次数
      num = 0,//计数倒计时秒数（n - num）
      start = 1.5 * Math.PI,// 开始的弧度
      end = -0.5 * Math.PI,// 结束的弧度
      time = null;// 计时器容器

     var n = newCount; // 当前倒计时为多少秒
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
      var context = wx.createCanvasContext('secondCanvasTwo')

      var gradient = context.createLinearGradient(200, 100, 100, 200);
      gradient.addColorStop("0", "#2661DD");
      gradient.addColorStop("0.5", "#40ED94");
      gradient.addColorStop("1.0", "#5956CC");

      // 绘制圆环
      context.setStrokeStyle('#21AEFF')
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
    that.setData({
      countTwo: newCount
    })
    
    that.setData({
      timerTwo: setInterval(function () {
        animation()
        that.setData({
          countTwo: that.data.countTwo-1
        })
        if (that.data.countTwo <= 0) {
          clearInterval(that.data.timerTwo)
          that.setData({
            showGuoduye: false,
          })
        }
      }, 1000)
    })  
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: '特斯鲁普测验',    //页面标题
    })
    var that = this
    that.doNext()
    that.stopTimer()
    that.countDownTwo()

  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    var that = this
    that.drawProgressbg('canvasProgressbg')
    that.drawProgressbg('canvasProgressbgTwo')
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
    var that = this
    clearInterval(that.data.timer);
    clearInterval(that.data.timerTwo);

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
    var that = this
 
    clearInterval(that.data.timer);
    clearInterval(that.data.timerTwo);

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
        // path: "/pages/start/start" + "?gameid=" + that.data.gameid + "&isShare=1",
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
  }
})