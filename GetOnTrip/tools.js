function imageSourceFromPoint(x, y) {
    var element = document.elementFromPoint(x, y);
    if (element.tagName == 'IMG' && element.src) {
        var rect = element.getBoundingClientRect();
        alert('{{' + rect.left + ',' + rect.top + '}' + ',{' + rect.right + ',' + rect.height + '}}');
        
        return element.src;
    }
    return null;
}

function getImageSource() {
    var imgScrs="";
    var imgs = document.getElementsByTagName('IMG');
    for(var i=0;i<imgs.length;i++){
        imgScrs+=imgs [i].src;
        if(i+1<imgs.length)imgScrs+="|";
    }
    return imgScrs;
}

function hello() {
    return "hello world";
}
