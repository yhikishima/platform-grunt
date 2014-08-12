/**
 * Handlebars Helpers
 */
'use strict';

// The module to be exported
var helpers = {
  forEach: function (num, options) {
    var i;
    var len;
    var result = '';
    var index;
    var week = '';
    for (index = i = 0, len = num; i < len; index = ++i) {

      switch ( index ) {
        case 0:
        case 7:
        case 14:
        case 21:
        case 28:
          week = '月';
          break;
        case 1:
        case 8:
        case 15:
        case 22:
        case 29:
          week = '火';
          break;
        case 2:
        case 9:
        case 16:
        case 23:
        case 30:
          week = '水';
          break;
        case 3:
        case 10:
        case 17:
        case 24:
        case 31:
          week = '木';
          break;
        case 4:
        case 11:
        case 18:
        case 25:
          week = '金';
          break;
        case 5:
        case 12:
        case 19:
        case 26:
          week = '土';
          break;
        case 6:
        case 13:
        case 20:
        case 27:
          week = '日';
          break;
      }

      result += options.fn({
        index: index + 1,
        week: week
      });
    }
    return result;
  }
};

module.exports.register = function (Handlebars, options) {
  options = options || {};

  for (var helper in helpers) {
    Handlebars.registerHelper(helper, helpers[helper]);
  }
  return this;
};