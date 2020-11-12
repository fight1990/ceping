// pages/guide/guide.js
const ctx2 = wx.createCanvasContext('runCanvas')

Page({

  // /**
  //  * 页面的初始数据
  //  */
  // data: {
  //   showResult: false, // 显示结果
  //   result: 0, // 结果对错 0-错 1-对
  //   showBottom: false, // 显示底部按钮
  //   showShadow: true, // 显示透明视图
  //   count: 3, // 倒计时
  //   timer: '',//定时器名字
  //   showShadowTwo: false, // 显示第二个透明视图
  //   showShadowThree: true, // 显示第三个透明视图 - 正式开始
  // },

  /**
 * 页面的初始数据
 */
  data: {
    answerList: Array(5), // 题目总数
    selectedIndex: -1,
    isRead: false, // 判断是否现实游戏页面
    result: 0, // 结果对错 0-错 1-对

    count: 3, // 倒计时
    timer: '',//定时器名字

    hideBottom: true, // 隐藏底部判断视图
    hideResult: true, // 隐藏结果视图

    showColor: "", // 显示当前颜色
    showPositionArr: Array(2), // 记录当前亮灯位置

    previousColor: "", // 记录前一个颜色
    previousPositionArr: Array(2), // 记录前一个亮灯位置

    lights: Array(3),
    isSame: false, // 是否相同
    rightCount: 0, // 对的题目数量

    hideResult: true, // 显示结果
    hideShadowOne: false, // 显示透明视图

    hideShadowTwo: true, // 显示第二个透明视图
    isTry: false, // 试一试
    hideShadowThree: true, // 显示第三个透明视图 - 正式开始

    isSame: false, // 是否相同
    rightCount: 0, // 对的题目数量

    scrId: 0,
    suspend: true, //是否暂停
    noSelect: false, // 未选择
  },

  hideShadowThreeTap: function () {
    var that = this
    that.setData({
      hideShadowThree: true,
      suspend: false,
    })
  },

  drawProgressbg: function () {
    // 使用 wx.createContext 获取绘图上下文 context
    var ctx = wx.createCanvasContext('canvasProgressbg')
    ctx.setLineWidth(10);// 设置圆环的宽度
    ctx.setStrokeStyle('#a4a4a4'); // 设置圆环的颜色
    ctx.setLineCap('round') // 设置圆环端点的形状
    ctx.beginPath();//开始一个新的路径
    ctx.arc(65, 65, 35, 0, 2 * Math.PI, false);
    //设置一个原点(100,100)，半径为90的圆的路径到当前路径
    ctx.stroke();//对当前路径进行描边
    ctx.draw();
  },

  /**
   * 未选择 直接下一题
   */
  noSelectTap: function () {
    var that = this
    that.setData({
      hideResult: false,
      result: 0,
    })
    if (that.data.selectedIndex == that.data.answerList.length - 1) {
      if (that.data.selectedIndex > 0) {
        clearInterval(that.data.timer)
        that.lastQuestion()
        return
      }

    } else {
      // 下一题
      setTimeout(function () {
        that.data.noSelect = false
        clearInterval(that.data.timer)
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
    if (that.data.result == 1) {
      var count = that.data.rightCount + 1
      that.setData({
        rightCount: count
      })
    }
    if (that.data.selectedIndex == that.data.answerList.length - 1) {
      if (that.data.selectedIndex > 0) {
        clearInterval(that.data.timer)
        that.lastQuestion()
        return
      }
    } else {
      // 下一题
      clearInterval(that.data.timer)

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
    }
    if (that.data.selectedIndex == that.data.answerList.length - 1) {
      if (that.data.selectedIndex > 0) {
        clearInterval(that.data.timer)
        that.lastQuestion()
        return
      }
    } else {
      // 下一题
      clearInterval(that.data.timer)

      setTimeout(function () {
        that.doNext();
      }, 1000);
    }
  },

  /**
 * 判断是否是最后一题
 */
  lastQuestion: function () {
    var that = this
    setTimeout(function () {
      that.setData({
        hideShadowThree: false
      })
    }, 1000);
    
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

    if (that.data.selectedIndex == 0) {
      that.setData({
        hideBottom: true,
        hideResult: true,
      })
    } else {
      that.setData({
        hideBottom: false,
        hideResult: true,
      })
    }

    var position = 0
    var colorNum = 0
    var color = "#fff"
    var positionArray = Array(2)

    if (that.data.selectedIndex >= 0 && that.data.selectedIndex <= 49) {
      position = Math.floor(Math.random() * 3)
      var position1 = Math.floor(Math.random() * 3)
      var position2 = -1
      color = "#058005"
      positionArray = [position1, position2]

    } else if (that.data.selectedIndex >= 50) {
      // var position1 = Math.floor(Math.random() * 3)
      // var position2 = Math.floor(Math.random() * 3)
      // positionArray = [position1, position2]
      // colorNum = Math.floor(Math.random() * 2)
      // if (colorNum == 0) { // 红色
      //   color = "#FF3838"
      // } else { // 绿灯
      //   color = "#058005"
      // }

      positionArray = that.randomTwo()
    }


    if (that.data.selectedIndex >= 1) {
      that.data.previousColor = that.data.showColor
      that.data.previousPositionArr = that.data.showPositionArr
    }

    that.setData({
      count: that.data.count,
      showPositionArr: positionArray,
      showColor: color
    })

    if (that.data.selectedIndex >= 1) {
      var position1 = positionArray[0]
      var current1 = that.data.previousPositionArr[0]
      if (position1 == current1) {
        that.data.isSame = true
      } else {
        that.data.isSame = false
      }
    } else {
      var position1 = 0 // 绿灯位置
      var current1 = 0 // 绿灯位置
      for (var i = 0; i < positionArray.length; i++) {
        var obj = positionArray[i]
        if (obj == "058005") {
          position1 = i
        }
      }
      for (var i = 0; i < that.data.previousPositionArr.length; i++) {
        var obj = that.data.previousPositionArr[i]
        if (obj == "058005") {
          current1 = i
        }
      }
      if (position1 == current1) {
        that.data.isSame = true
      } else {
        that.data.isSame = false
      }
    }
    var param = { isAnswer: that.data.isAnswer }
    that.countDown(param)
  },

  /**
   *  随机两个数
   */
  randomTwo: function () {
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

    var colorArr = []
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
    return colorArr
  },


  /**
   * 出题计时器
   */
  countDown: function (param) {

    let that = this;
    let newCount = 3;//获取倒计时初始值
    if (that.data.suspend == true) { // 暂停状态
      that.data.suspend = false
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
        ringMove(start, end)
        step++
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

    if (that.data.selectedIndex == 1) {
      that.setData({
        hideShadowTwo: false,
        count: 3
      })
      clearInterval(that.data.timer)
      that.stopTimer()
      that.data.selectedIndex = that.data.selectedIndex + 1
      return
    } 

    that.setData({
      count: newCount
    })

    that.setData({
      timer: setInterval(function () {
        animation()
        that.setData({
          count: that.data.count - 1
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
   * 正式开始
   */
  startTap: function () {
    var that = this
    wx.setStorage({
      key: 'hasGuide',
      data: 'true',
    })
    wx.navigateTo({
      url: '/pages/lights/lights',
    })
  },

  /**
   * 我知道了 - 按钮
   */
  hideShadowView: function () {
    var that = this
    that.setData({
      hideShadowOne: true,
    })
    that.startTimer()

    // let count = that.data.count;//获取倒计时初始值
    // that.setData({
    //   timer: setInterval(function () {
    //     count--;
    //     that.setData({
    //       count: count
    //     })
    //     if (count <= 0) {
    //       clearInterval(that.data.timer);
    //       that.setData({
    //         hideShadowTwo: false,
    //       })
    //     }
    //   }, 1000)
    // })
  },

  /**
   * 试一试
   */
  tryTap: function () {
    var that = this
    that.startTimer()
    that.setData({
      hideShadowTwo: true,
      isTry: true, 
    })
    // setTimeout(function () {
    //   clearInterval(that.data.timer)
    //   that.doNext()
    // }, 1000);
  },

  /**
 * 暂停倒计时
 */
  stopTimer: function () {
    var that = this
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
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: '选择注意力训练',    //页面标题
    })
    var that = this
    that.doNext()
    that.stopTimer()

    
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    this.drawProgressbg()
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

  }
})