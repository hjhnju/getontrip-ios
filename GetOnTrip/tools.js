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
        imgScrs+=imgs[i].getAttribute('data-actualsrc');
        if(i+1<imgs.length)imgScrs+="|";
    }
    return imgScrs;
}

function getImgList() {
    var list = [];
    //var imgs = $('.main-content .main-content-inner').find('img');
    var imgs = document.querySelectorAll('.main-content .main-content-inner img');
    
    for(var i=0;i<imgs.length;i++){
        var img = imgs[i];
        var data = {};
        data.src = imgs[i].getAttribute('data-actualsrc');
        data.x = getLeft(img);
        data.w = getWidth(img);
        data.h = getHeight(img);
        data.y = getTop(img);
        data.desc = getDesc(img);
        list.push(data);
    }
    return list;
}

//获取元素的纵坐标
function getTop(e) {
    var offset = e.offsetTop;
    if (e.offsetParent != null) offset += getTop(e.offsetParent);
    return offset;
}
//获取元素的横坐标
function getLeft(e) {
    var offset = e.offsetLeft;
    if (e.offsetParent != null) offset += getLeft(e.offsetParent);
    return offset;
}
//获取元素的宽
function getWidth(e) {
    return e.offsetWidth;
}
//获取元素的高
function getHeight(e) {
    return e.offsetHeight;
}

//获取图片的描述
function getDesc(img) {
    var desc = '';
    var next = img.nextSibling;
    var parent_next = img.parentNode.nextSibling;
    if (next) {
        desc = getDescByNode(next);
    } else if (parent_next) {
        desc = getDescByNode(parent_next);
    }
    return desc;
}

function getDescByNode(next) {
    var desc = '';
    if (next && next.tagName == 'P' && next.className == 'imagedesc') {
        desc = next.textContent;
        ot_next = next.nextSibling;
        if (ot_next) {
            desc = desc + "\n" + getDescByNode(ot_next);
        }
    }
    return desc;
}
