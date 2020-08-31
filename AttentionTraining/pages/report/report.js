// pages/report/report.js
var api = require("../../Api/api.js")

Page({

  /**
   * 页面的初始数据
   */
  data: {
    gameList: [],
    user: {},
    showDetail:false, // 显示详情
    game: {} ,// 报告详情
  },

  /**
   * 获取年龄
   */
  getAge: function (n) {
    var birthStr = n.replace(/-/g, '/');
    var birthDay = new Date(birthStr).getTime();
    var now = new Date().getTime();
    var hours = (now - birthDay) / 1000 / 60 / 60;
    var year = Math.floor(hours / (24 * 30 * 12));
    hours = hours % (24 * 30 * 12);
    var months = Math.floor(hours / (24 * 30));
    hours = hours % (24 * 30);
    var days = Math.floor(hours / (24));
    var str = ''
    if (year == 0) {
      str = year + '周岁' + months + '个月'
    } else if (months == 0) {
      str = year + '周岁' + months + '个月'
    } else {
      str = year + '周岁' + months + '个月'
    }
    return str
  },

  formatNumber: function (n) {
    n = n.toString()
    return n[1] ? n : '0' + n
  },

  getLocalTime: function (ns) {
    //needTime是整数，否则要parseInt转换  
    var time = new Date(parseInt(ns) * 1000); //根据情况*1000
    var y = time.getFullYear();
    var m = time.getMonth() + 1;
    var d = time.getDate();
    var h = time.getHours();
    var mm = time.getMinutes();
    var s = time.getSeconds();
    return y + '-' + this.add0(m) + '-' + this.add0(d) + ' ' + this.add0(h) + ':' + this.add0(mm) + ':' + this.add0(s);
  },
  //小于10的补零操作
  add0: function (m) {
    return m < 10 ? '0' + m : m
  },

  /**时间戳转日期 格式2018年01月01日*/
  getChaYMD: function (ns) {
    var allStr = this.getLocalTime(ns);
    var year = allStr.substr(0, 4);
    var month = allStr.substr(5, 2);
    var day = allStr.substr(8, 2);
    return year + '年' + month + '月' + day + '日';
  },

  /** 
 * 时间戳转化为年 月 日 时 分 秒 
 * number: 传入时间戳 
 * format：返回格式，支持自定义，但参数必须与formateArr里保持一致 
*/
 formatTimeTwo: function (number, format) {
    var that = this
    var formateArr = ['Y', 'M', 'D', 'h', 'm', 's'];
    var returnArr = [];

    var date = new Date(number * 1000);
    returnArr.push(date.getFullYear());
    returnArr.push(that.formatNumber(date.getMonth() + 1));
    returnArr.push(that.formatNumber(date.getDate()));

    returnArr.push(that.formatNumber(date.getHours()));
    returnArr.push(that.formatNumber(date.getMinutes()));
    returnArr.push(that.formatNumber(date.getSeconds()));

    for(var i in returnArr) {
      format = format.replace(formateArr[i], returnArr[i]);
    } 

    console.log(format)
    return format;
},

  /**
   * 显示单个item详情
   */
  showDetailTap: function (e) {
    var that = this
    var gameid = e.currentTarget.dataset.gameid
    var gametype = e.currentTarget.dataset.gametype
    var gameData= e.currentTarget.dataset.gamedata

    if (gametype == 1) {
     wx.navigateTo({
       url: '/pages/zonghecepinginfo/zonghecepinginfo?gameData='+JSON.stringify(gameData),
     })
      return
    }

    that.setData({
      showDetail: true,
    })
    var params = {}
    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          api.zhanShiBaogao({
            data: {
              openid: res.data.openid,
              gameid: gameid
            },
            success: function (res) {
              var game = res.games
              var scale = res.scale
              game.scale = scale
              that.setData({
                game: game,
        
              })
            },
            fail: function (res) {

            }
          })
        }
      }
    })
  },

  /**
   * 关闭单个item详情
   */
  closeDetailTap: function () {
    var that = this
    that.setData({
      showDetail: false,
    }) 
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: '报告',    //页面标题
    })
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

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          that.setData({
            "nickName": res.data.nickName,
            "avatar": res.data.avatarUrl
          })

          api.checkBaogao({
            data: { openid: res.data.openid },
            success: function (res) {
              var list = [].concat(res.games)
              for (var i = 0; i < list.length;i++) {
                if (Object.keys(list[i]).length === 0) {
                  list.splice(i, 1)
                } else {
                  var obj = list[i]
                  obj.time = that.formatTimeTwo(obj.creatime/1000, 'Y/M/D h:m')
                }
              }

              var ceping = res.ceping
              if (typeof(ceping) == 'array') {
                for (var i = 0; i < ceping.length;i++) {
                  var obj = ceping[i]
                  obj.zhcp = true
                  obj.id = 'zhcp'
                  obj.type = 1
                  obj.time = that.formatTimeTwo(ceping.creatime/1000, 'Y/M/D h:m')
                }
                list = list.concat(ceping)
              } else if (typeof(ceping) == 'object') {
                ceping.zhcp = true
                ceping.id = 'zhcp'
                ceping.type = 1
                ceping.time = that.formatTimeTwo(ceping.creatime/1000, 'Y/M/D h:m')
                list = list.concat([ceping])
              }

              list.sort(that.compare('creatime'))

              var user = res.user
              user.birth = that.getChaYMD(user.age / 1000)
              var newAge = that.getAge(that.formatTimeTwo(user.age/ 1000, 'Y/M/D h:m'))
              user.newAge = newAge
              that.setData({
                gameList: list,
                user: user
              })
            },
            fail: function (res) {

            }
          })
        }
      }
    })
  },

  //json数组比较
  compare:function (property) {
    return function (a, b) {
      var value1 = a[property];
      var value2 = b[property];
      return value2 - value1;
    }
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