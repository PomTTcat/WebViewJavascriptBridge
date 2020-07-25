function thisisJEFFinject() {
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'https://__bridge_loaded__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

//function thisisJEFFMsginject() {
//    var WVJBIframe = document.createElement('iframe');
//    WVJBIframe.style.display = 'none';
//    WVJBIframe.src = 'https://__wvjb_queue_message__';
//    document.documentElement.appendChild(WVJBIframe);
//    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
//}
thisisJEFFinject();
//function jttttttt() {
//    var WVJBIframe = document.createElement('iframe');
//    WVJBIframe.style.display = 'none';
//    WVJBIframe.src = 'https://www.baidu.com;
//    document.documentElement.appendChild(WVJBIframe);
//    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 2000)
//}

//jttttttt();
//


//jttttttt();
