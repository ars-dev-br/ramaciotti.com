var ars = (function () {
    "use strict";

    var body = document.getElementsByTagName("body")[0];
    var menuTrigger = document.getElementById("menu-trigger");

    function isChildOf(child, parent) {
        if(child === null)
            return false;
        else if(child.id === parent)
            return true;
        else
            return isChildOf(child.parentElement, parent);
    }

    function closeMenu(evt) {
        if(!isChildOf(evt.target, "menu") && evt.target.id !== "menu-trigger") {
            body.classList.remove("show-menu");
            document.removeEventListener("touchend", closeMenu);
            document.removeEventListener("click", closeMenu);
        }
    }

    function openMenu(evt) {
        evt.stopPropagation();
		evt.preventDefault();

        body.classList.add("show-menu");

        document.addEventListener("touchend", closeMenu);
        document.addEventListener("click", closeMenu);
    }

    function onload() {
        body.classList.remove("no-js");
        menuTrigger.addEventListener("touchend", openMenu);
        menuTrigger.addEventListener("click", openMenu);
    }

    return {
        onload: onload
    }
}());
window.onload = ars.onload();
