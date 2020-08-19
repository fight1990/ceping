// pages/cePingInfo/cePingInfo.js

const date = new Date()
const years = []
const months = []
const days = []

for (let i = 1990; i <= date.getFullYear(); i++) {
  years.push(i)
}

for (let i = 1; i <= 12; i++) {
  months.push(i)
}

for (let i = 1; i <= 31; i++) {
  days.push(i)
}

Page({

  /**
   * 页面的初始数据
   */
  data: {
    ageButton_disabled: true,
    isInfomation: false,
    isAgeSelected: true,

    years,
    year: date.getFullYear(),
    months,
    month: 2,
    days,
    day: 2,
    value: [9999, 1, 1],

    selectedDate: ''
  },

  readButtonAction: function () {
    this.setData({
      isInfomation: false,
      isAgeSelected: true
    })
  },

  ageSelectedSubmit: function () {
    if (this.data.selectedDate.length <= 0) {
      wx.showToast({
        title: '请设置孩子出生日期',
        icon: 'none'
      })
    } else {

      wx.setStorageSync('age_player', this.data.selectedDate)
      wx.navigateTo({
        url: '/pages/cePingGame/cePingGame',
      })
    }

  },

  bindChange(e) {
    const val = e.detail.value
    var selectedDate = this.data.years[val[0]]+'-'+this.data.months[val[1]]+'-'+this.data.days[val[2]]
    this.setData({
      year: this.data.years[val[0]],
      month: this.data.months[val[1]],
      day: this.data.days[val[2]],
      selectedDate: selectedDate,
    })
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