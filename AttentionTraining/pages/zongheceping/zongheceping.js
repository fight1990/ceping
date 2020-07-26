// pages/zongheceping/zongheceping.js
const util = require("../../utils/util.js");

Page({

  /**
   * 页面的初始数据
   */
  data: {
    screenWidth: 710 / util.getRpx() * 1.0,
    userData: {
      userName: "张晓云",
      sex: "男",
      age: "7岁",
      mobile: "17688888888"
    },
    deFen: {
      headers:[{ text: 'one', display: '类型' }, { text: 'two', display: '难易' }, { text: 'three', display: '用时' }, { text: 'four', display: '正确数' }, { text: 'five', display: '正确率' }, { text: 'six', display: '得分' }],
      row: [
          {'one': '交通灯','two': '初级','three': '0','four': '0','five': '0','six': '0'},
          {'one': '交通灯','two': '中级','three': '0','four': '0','five': '0','six': '0'},
          {'one': '交通灯','two': '高级级','three': '0','four': '0','five': '0','six': '0'}]

    }
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