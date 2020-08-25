// pages/zonghecepinginfo/zonghecepinginfo.js
var api = require("../../Api/api.js")
const util = require("../../utils/util.js");

Page({

  /**
   * 页面的初始数据
   */
  data: {
    screenWidth: 710 / util.getRpx() * 1.0,
    userData: {
      userName: "",
      sex: "",
      age: "",
      mobile: ""
    },
    deFen: {
      jtd: '交通灯：用时-秒，正确数-题，正确率-，得分-分；\n',
      xfh: '小符号：用时-秒，正确数-题，正确率-，得分-分；\n',
      ksjy: '快速记忆：用时-秒，正确数-题，正确率-，得分-分；\n',
      strp: '斯特如普：用时-秒，正确数-题，正确率-，得分-分；\n',
      zsc: '总用时长：-秒\n'
    },
    tiXian: {
      'fy': {
        'title': '反应能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '反应能力: 是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力\n'
      },
      'rz': {
        'title': '认知灵活度\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '认知灵活度: 是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力\n'
      },
      'xx': {
        'title': '信息处理能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '信息处理能力: 是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力\n'
      },
      'jy': {
        'title': '记忆能力\n',
        'scole': '分数80分，百分比80%，标准分值：80分\n',
        'info': '记忆能力: 主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱\n'
      }
    }
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var gameResult = options.gameResult
    if (gameResult) {
      this.uploadGameData(gameResult)
    }
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    this.getGameData()
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

  },

  uploadGameData: function(gameResult) {

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          var params = {
            openid: res.data.openid,
            userid: result.user.id,
            nickname: res.data.nickName,
            headUrl: res.data.avatarUrl,
            data: gameResult
          }
          api.saveGamesData({
            data: params,
            success: function (response) {
              console.log(response)
            },
            fail: function (res) {
              
            }
          })
        }
      },
      fail:function (res){

      }
    })
  },

  getGameData: function() {
    var that = this
    let age = util.getAge(wx.getStorageSync('age_player'))

    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          api.goToWeChat({
            data: { openid: res.data.openid },
            success: function (result) {
              if (result.user) { 
                if (result.user.state == 1) { // 已注册
                  that.setData({
                    userData: {
                      userName: result.user.name,
                      sex: result.user.sex,
                      age: age + '岁',
                      mobile: result.user.phone
                    },
                  })

                  api.getCombinationEvaluationByOpenid({
                    data: { openid: res.data.openid },
                    success: function (result) {
                      if (result.code == 1) { 
                        that.setData({
                          deFen: {
                            jtd: '交通灯：用时-秒，正确数-题，正确率'+result.data.percentage0+'，得分'+result.data.score0+'分；\n',
                            xfh: '小符号：用时-秒，正确数-题，正确率'+result.data.percentage1+'，得分'+result.data.score1+'分；\n',
                            ksjy: '快速记忆：用时-秒，正确数-题，正确率'+result.data.percentage2+'，得分'+result.data.score2+'分；\n',
                            strp: '斯特如普：用时-秒，正确数-题，正确率'+result.data.percentage3+'，得分'+result.data.score3+'分；\n',
                            zsc: '总用时长：'+ result.data.times +'秒'
                          },
                        })
                      }
                    },
                    fail: function (res) {
        
                    }
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
         
      }
    })
  }
})