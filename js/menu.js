var ars = (function () {
    "use strict";

    var body = document.getElementsByTagName("body")[0];
    var menuTrigger = document.getElementById("menu-trigger");

    function isMobile() {
        return (('ontouchend' in window))/* ||
            (navigator.maxTouchPoints > 0) ||
            (navigator.msMaxTouchPoints > 0));*/
    }

    function isChildOf(child, parent) {
        if(child === null)
            return false;
        else if(child.id === parent)
            return true;
        else
            return isChildOf(child.parentElement, parent);
    }

    function closeMenu(evt) {
        var eventType = isMobile() ? "touchend" : "click";
        if(!isChildOf(evt.target, "menu") && evt.target.id !== "menu-trigger") {
            body.classList.remove("show-menu");
            document.removeEventListener(eventType, closeMenu);
        }
    }

    function openMenu(evt) {
        evt.stopPropagation();
		evt.preventDefault();

        body.classList.add("show-menu");

        var eventType = isMobile() ? "touchend" : "click";
        document.addEventListener(eventType, closeMenu);
    }

    function onload() {
        body.classList.remove("no-js");
        var eventType = isMobile() ? "touchend" : "click";
        menuTrigger.addEventListener(eventType, openMenu);
    }

    return {
        onload: onload
    }
}());
window.onload = ars.onload();
