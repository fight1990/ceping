// pages/xiaofuhaostart/xiaofuhaostart.js
Page({

  /**
   * 页面的初始数据
   */
  data: {

  },

  /**
   * 开始阅读
   */
  
  readBtnAction: function (e) {
    var that = this
    if (wx.getStorageSync("xiaofuhao_guide")) {
      wx.navigateTo({
        url: '/pages/xiaofuhaoGame/xiaofuhaoGame',
      })
    } else {
      wx.navigateTo({
        url: '/pages/xiaofuhaoGuide/xiaofuhaoGuide',
      })
    }
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    wx.setNavigationBarTitle({
      title: '工作记忆区训练',    //页面标题
    })
    wx.setNavigationBarColor({
      frontColor: '#ffffff',
      backgroundColor: '#92DAAE',
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
    // wx.navigateTo({
    //   url: '/pages/home/home',
    // })
    // wx.redirectTo({
    //   url: '/pages/home/home',
    // })
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