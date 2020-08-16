const formatTime = date => {
  const year = date.getFullYear()
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours()
  const minute = date.getMinutes()
  const second = date.getSeconds()

  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

const formatNumber = n => {
  n = n.toString()
  return n[1] ? n : '0' + n
}

function sortArray(arr) {
  for(let i = 0,len = arr.length; i < len; i++){
    let currentRandom = parseInt(Math.random() * (len - 1));
    let current = arr[i];
    arr[i] = arr[currentRandom];
    arr[currentRandom] = current;
  }
  return arr
}

// 随机取数组中的几个元素
function getArrayItems(arr, num) {
  //新建一个数组,将传入的数组复制过来,用于运算,而不要直接操作传入的数组;
  var temp_array = new Array();
  for (var index in arr) {
      temp_array.push(arr[index]);
  }
  //取出的数值项,保存在此数组
  var return_array = new Array();
  for (var i = 0; i<num; i++) {
      //判断如果数组还有可以取出的元素,以防下标越界
      if (temp_array.length>0) {
          //在数组中产生一个随机索引
          var arrIndex = Math.floor(Math.random()*temp_array.length);
          //将此随机索引的对应的数组元素值复制出来
          return_array[i] = temp_array[arrIndex];
          //然后删掉此索引的数组元素,这时候temp_array变为新的数组
          temp_array.splice(arrIndex, 1);
      } else {
          //数组中数据项取完后,退出循环,比如数组本来只有10项,但要求取出20项.
          break;
      }
  }
  return return_array;
}


//获取px与rpx之间的比列 
function getRpx() { 
  var winWidth = wx.getSystemInfoSync().windowWidth;
  return 750/winWidth;
}

function getScrienWidth() {
  return wx.getSystemInfoSync().windowWidth;
}

// 根据出生日期计算年龄周岁 传参格式为1996-06-08
function getAge(strBirthday) {
  var returnAge = '';
  var mouthAge = '';
  var strBirthdayArr = strBirthday.split("-");
  var birthYear = strBirthdayArr[0];
  var birthMonth = strBirthdayArr[1];
  var birthDay = strBirthdayArr[2];
  var d = new Date();
  var nowYear = d.getFullYear();
  var nowMonth = d.getMonth() + 1;
  var nowDay = d.getDate();
  if (nowYear == birthYear) {
    // returnAge = 0; //同年 则为0岁
    var monthDiff = nowMonth - birthMonth; //月之差 
    if (monthDiff < 0) {
    } else {
      mouthAge = monthDiff;
    }
  } else {
    var ageDiff = nowYear - birthYear; //年之差
    if (ageDiff > 0) {
      if (nowMonth == birthMonth) {
        var dayDiff = nowDay - birthDay; //日之差 
        if (dayDiff < 0) {
          returnAge = ageDiff - 1;
        } else {
          returnAge = ageDiff;
        }
      } else {
        var monthDiff = nowMonth - birthMonth; //月之差 
        if (monthDiff < 0) {
          returnAge = ageDiff - 1;
        } else {
          mouthAge = monthDiff;
          returnAge = ageDiff;
        }
      }
    } else {
      returnAge = -1; //返回-1 表示出生日期输入错误 晚于今天
    }
  }
  return returnAge
}

module.exports = {
  formatTime: formatTime,
  sortArray: sortArray,
  getArrayItems: getArrayItems,
  getRpx: getRpx,
  getScrienWidth: getScrienWidth,
  getAge: getAge
}
