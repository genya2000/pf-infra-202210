(function() {
  'use strict';
  var d = 'stg.switch-plus.jp';

  if (window.spa && window.spa.vars)  // Compatibility
	window.spa = window.spa.vars
  else
	window.spa = window.spa || {}

  window.spkps = window.spkps || [];

  // Get all data we're going to send off to the counter endpoint.
  var get_data = function(vars) {
    var id = document.querySelector('script[data-spcid]');
	var data = {
      cid: id.dataset.spcid,
      ft: vars.spft,
      vid: vars.spvid,
	  t: null,
	  r: null,
      l: null,
	  q: location.search,
	}

    if (vars.splid !== undefined) {
      data.lid = vars.splid;
    }

	if (is_empty(data.r)) data.r = document.referrer;
	if (is_empty(data.t)) data.t = document.title;
	if (is_empty(data.l)) {
      data.l = (window.navigator.languages && window.navigator.languages[0]) ||
            window.navigator.language ||
            window.navigator.userLanguage ||
            window.navigator.browserLanguage;
    }
    
	if (is_empty(data.p)) {
	  var loc = location,
		  c = document.querySelector('link[rel="canonical"][href]')
	  if (c) {  // May be relative or point to different domain.
		var a = document.createElement('a')
		a.href = c.href
		if (a.hostname.replace(/^www\./, '') === location.hostname.replace(/^www\./, ''))
		  loc = a
	  }
	  data.p = loc.protocol + '//' + loc.hostname + loc.pathname;
      data.kp = window.spkps.indexOf(data.p) != -1;
	}

	return data
  }

  // Check if a value is "empty" for the purpose of get_data().
  var is_empty = function(v) { return v === null || v === undefined || typeof(v) === 'function' }

  var genUuid = function() {
    var chars = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".split("");
    for (let i = 0, len = chars.length; i < len; i++) {
      switch (chars[i]) {
      case "x":
        chars[i] = Math.floor(Math.random() * 16).toString(16);
        break;
      case "y":
        chars[i] = (Math.floor(Math.random() * 4) + 8).toString(16);
        break;
      }
    }
    return chars.join("");
  }
  // Object to urlencoded string, starting with a ?.
  var urlencode = function(obj) {
	var p = []
	for (var k in obj)
	  if (obj[k] !== '' && obj[k] !== null && obj[k] !== undefined && obj[k] !== false)
		p.push(encodeURIComponent(k) + '=' + encodeURIComponent(obj[k]))
	return '?' + p.join('&')
  }


  window.spa.scanLink = function (vid, cid, lid) {
    var elements = document.getElementsByTagName('a');
    Array.prototype.forEach.call(elements, function (element) {
      var url = new URL(element.href);
      var result = url.toString().match(/^https?:\/{2,}(.*?)(?:\/|\?|#|$)/)[1];
      if (result == 'r.'+d) {
        url.searchParams.append('vid', vid);
        url.searchParams.append('client_key', cid);
        if (lid) url.searchParams.append('lid', lid);
        element.href = url.toString();
      }
    });
  }
  // Get URL to send to Spa.
  window.spa.url = function(vars) {

    var cookie;
    var firstTime;

    var microtime = (new Date()).getTime();
    var timestamp = Math.round(microtime / 1000);
    var expire_time = (timestamp + 360000) * 1000;
    var expires = (new Date(expire_time)).toUTCString()
    var page_url = location.href;
    page_url = page_url.replace(/#.*$/,"")

    var data = get_data(vars || {})
    spa.scanLink(data.vid, data.cid, data.lid);
    if (data.p === null) {
      return;
    }
    data.rnd = Math.random().toString(36).substr(2, 5)
    return "https://a."+d+"/b.gif" + urlencode(data)
  }

  // Count a hit.
  window.spa.count = function(vars) {
	var url = spa.url(vars)
	if (!url) {
	  if (console && 'log' in console)
		console.warn('spa: not counting because path callback returned null')
	  return
	}

	var img = document.createElement('img')
	img.src = url
	img.style.position = 'absolute'  // Affect layout less.
	img.setAttribute('alt', '')
	img.setAttribute('aria-hidden', 'true')

	var rm = function() { if (img && img.parentNode) img.parentNode.removeChild(img) }
	setTimeout(rm, 3000)  // In case the onload isn't triggered.
	img.addEventListener('load', rm, false)
	document.body.appendChild(img)
  }

  var getCookie = function(key) {
    var name = key + '=';
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) == ' ') { c = c.substring(1); }
      if (c.indexOf(name) == 0) { return c.substring(name.length, c.length); }
    }
    return null;
  };

  var setCookie = function(key, value, expire) {
    var cookieStr = '';
    cookieStr = cookieStr + key + '=' + value;
    cookieStr = cookieStr + ';path=/';
    if ( expire ) {
      var d = new Date();
      d.setTime(d.getTime() + expire);
      var expires = d.toUTCString();
      cookieStr = cookieStr + ';expires=' + expires;
    }
    document.cookie = cookieStr;
  };
  
  window.spa.createFrame = function () {
    var l = spa.get_query('spl');
    if (l) {
      setCookie('splid', l);
    }

    // Create iframe
    var origin = 'https://cdn.'+d;
    var el = document.createElement('iframe');
    el.src = origin + '/b/t.html';
    el.setAttribute('style', 'width:0;height:0;border:0;border:none');
    document.body.appendChild(el);

    // Add listener to get the stored Client ID
    window._spGetMessage = function (e) {
      var key = e.message ? "message" : "data";
      var data = e[key];
      if (e.origin !== origin) { return; }
      else {
        // var obj = JSON.parse(jsonString);
        // console.log('data', data);
	    window.spa.count(data);
      }
    };
    

    var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
    var eventer = window[eventMethod];
    var messageEvent = eventMethod === "attachEvent" ? "onmessage" : "message";
    eventer(messageEvent, window._spGetMessage, false);


    el.onload = function () {
      var microtime = (new Date()).getTime();
      var timestamp = Math.round(microtime / 1000);
      var message = {
        spvid: genUuid(),
        spcdomain: location.origin,
        spft: timestamp,
      };
      // // Send request to get the Client ID
      if ( getCookie('splid') ) {
        message.splid = getCookie('splid');
      }

      // console.log('message:', message);
      el.contentWindow.postMessage(message, origin);
      el.contentWindow.postMessage('get', origin);
    }

  }

  // Get a query parameter.
  window.spa.get_query = function(name) {
    var s = location.search.substr(1).split('&')
    for (var i = 0; i < s.length; i++)
	  if (s[i].toLowerCase().indexOf(name.toLowerCase() + '=') === 0)
	    return s[i].substr(name.length + 1)
  }

  var go = function() {
    spa.createFrame();
    // spa.count()
  }

  if (document.body === null)
    document.addEventListener('DOMContentLoaded', function() { go() }, false)
  else
    go()
})();
