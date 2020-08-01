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

module.exports = {
  formatTime: formatTime,
  sortArray: sortArray,
  getArrayItems: getArrayItems,
  getRpx: getRpx,
  getScrienWidth: getScrienWidth
}
