// ==UserScript==
// @name         Dashboard View
// @namespace    http://fongincanada.net/
// @version      0.1
// @description  Adjusts display elements to maximize the screen area dedicated to tasks
// @author       Patrick Fong
// @include      http://tasks.fongincanada.net/*/issues*
// @grant        none
// ==/UserScript==
 
(function() {
    'use strict';
 
   var sidebar = document.getElementById('sidebar');
    sidebar.style.display = "none";
   
   var content = document.getElementById('content');
    content.style.marginRight = "0px";
   
   var mainMenu = document.getElementById('main-menu');
    mainMenu.style.display = "none";
   
   var topMenu = document.getElementById('top-menu');
    topMenu.style.display = "none";
   
   var header = document.getElementById('header');
    header.style.paddingBottom = "0px";
   
    var meta = document.createElement('meta');
    meta.httpEquiv = 'refresh';
    meta.content = '120';
    document.getElementsByTagName('head')[0].appendChild(meta);
})();