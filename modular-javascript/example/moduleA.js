// moduleA.js
define(['dep1-for-moduleA'], function (randomNumber) {
  
  var bigNumber = function () {
    return randomNumber() * 2;
  };

  return bigNumber;

});