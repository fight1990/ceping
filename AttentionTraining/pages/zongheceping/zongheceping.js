// pages/zongheceping/zongheceping.js
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
      headers:[{ text: 'one', display: '类型' }, { text: 'three', display: '用时' }, { text: 'four', display: '正确数' }, { text: 'five', display: '正确率' }, { text: 'six', display: '得分' }],
      row: [
          {'one': '交通灯','three': '-','four': '-','five': '-','six': '-'},
          {'one': '小符号','three': '-','four': '-','five': '-','six': '-'},
          {'one': '快速记忆','three': '-','four': '-','five': '-','six': '-'},
          {'one': '斯特如普','three': '-','four': '-','five': '-','six': '-'}]
    },
    tiXian: {
      headers:[{ text: 'one', display: '类型' }, { text: 'two', display: '反应能力' }, { text: 'three', display: '认知灵活度' }, { text: 'four', display: '信息处理能力' }, { text: 'five', display: '记忆能力' }],
      row: [
          {'one': '分数','two': '-','three': '-','four': '-','five': '-'},
          {'one': '标准分数','two': '80','three': '80','four': '80','five': '80'},
          {'one': '百分比','two': '-','three': '-','four': '-','five': '-'},
          {'one': '说明','two': '反应能力，是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力','three': '认知灵活度，是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力','four': '信息处理能力是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力','five': '记忆能力主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱'}]
    },
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    
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

  getGameData: function () {
    var that = this
    // 判断是否已经注册信息
    wx.getStorage({
      key: 'userInfo',
      success: function (res) {
        if (res.data) {
          that.setData({
            userData: {
              userName: res.data.nickName,
              sex: (res.data.gender==1)?"男":"女",
              age: "",
              mobile: ""
            },
          })
          api.getCombinationEvaluationByOpenid({
            data: { openid: res.data.openid },
            success: function (result) {
              if (result.code == 1) { 
                that.setData({
                  deFen: {
                    headers:[{ text: 'one', display: '类型' }, { text: 'three', display: '用时' }, { text: 'four', display: '正确数' }, { text: 'five', display: '正确率' }, { text: 'six', display: '得分' }],
                    row: [
                        {'one': '交通灯','three': '-','four': '-','five': result.data.percentage0,'six': result.data.score0},
                        {'one': '小符号','three': '-','four': '-','five': result.data.percentage1,'six': result.data.score1},
                        {'one': '快速记忆','three': '-','four': '-','five': result.data.percentage2,'six': result.data.score2},
                        {'one': '斯特如普','three': '-','four': '-','five': result.data.percentage3,'six': result.data.score3}]
                  },
                  tiXian: {
                    headers:[{ text: 'one', display: '类型' }, { text: 'two', display: '反应能力' }, { text: 'three', display: '认知灵活度' }, { text: 'four', display: '信息处理能力' }, { text: 'five', display: '记忆能力' }],
                    row: [
                        {'one': '分数','two': '-','three': '-','four': '-','five': '-'},
                        {'one': '标准分数','two': '80','three': '80','four': '80','five': '80'},
                        {'one': '百分比','two': '-','three': '-','four': '-','five': '-'},
                        {'one': '说明','two': '反应能力，是指在接受到信息之后，经过大脑对信息的分析、处理之后，作出正确决策的能力','three': '认知灵活度，是指在完成复杂的认知任务时，对各种认知过程进行协调，灵活的根据不同的要求进行状态的切换，以保证目标的顺利完成能力','four': '信息处理能力是指孩子在接收一系列复杂的信息时，大脑经过排列、组合、加工逻辑推理之后得到结果的能力','five': '记忆能力主要指在大脑接收到语言及图像信息时，大脑对信息的记忆能力，记忆能力强弱直接影响学习能力强弱'}]
                  },
                })
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
  
})
