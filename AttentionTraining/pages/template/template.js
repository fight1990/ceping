
var jiaotongdeng = {
  
  hideShadowThreeTap: function () {
    var that = this
    that.setData({
      hideShadowThree: true,
      suspend: false,
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

  },
}

export default jiaotongdeng



// Page({

//   /**
//  * 页面的初始数据
//  */
//   data: {
    
//     hideShadowOne: false, // 显示透明视图
//     hideShadowTwo: true, // 显示第二个透明视图
//     hideShadowThree: true, // 显示第三个透明视图 - 正式开始
//   },

//   hideShadowThreeTap: function () {
//     var that = this
//     that.setData({
//       hideShadowThree: true,
//       suspend: false,
//     })
//   },
 
//   /**
//    * 正式开始
//    */
//   startTap: function () {
//     var that = this
//     wx.setStorage({
//       key: 'hasGuide',
//       data: 'true',
//     })
//     wx.navigateTo({
//       url: '/pages/lights/lights',
//     })
//   },

//   /**
//    * 我知道了 - 按钮
//    */
//   hideShadowView: function () {
//     var that = this
//     that.setData({
//       hideShadowOne: true,
//     })
//     that.startTimer()

//   },

//   /**
//    * 试一试
//    */
//   tryTap: function () {
//     var that = this
//     that.startTimer()
//     that.setData({
//       hideShadowTwo: true,
//       isTry: true, 
//     })
//   },

// })