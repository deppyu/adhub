var currentInput;
var key = "";
var isShow = false;
var activeDiv;

var dataRequest = "";//返回数据的分隔符
var kwlength;//关键字最小长度
var autoTab;//是否回车后自动转到下一个文本框
var parameterName;//回传时的参数名
var parameterNameTable;
var parameterNameField;
jQuery.fn.AutoComplete = function(request, option){
    this.each(function(){        
        if(this.tagName.toLowerCase() == "input" && $(this).attr("type").toLowerCase() == "text")
        {
            $(this).keydown(function(e){
                selectText(e.keyCode,this);
            });            
            $(this).keyup(function(e){
                searchKey(e.keyCode);
            });
           $(this).blur(function(){
                selectedDiv = $("#floor>div[@class=selected]");
                if(selectedDiv.length<1)
                {
                     hideText();
                     return;
                }
            });
        }
    });    
    if(request.length == 0) throw "request is required";
    dataRequest = request;
    kwlength = option.kwlength || 1 ;
    seperator = option.seperator || ",";
    autoTab = option.autoTab || false;
    parameterName = option.parameterName || ""; 
    parameterNameTable=option.parameterNameTable || "";
    parameterNameField=option.parameterNameField || "";
        //alert(parameterNameTable);
    //alert(parameterNameField);
    $("body").prepend("<div id='floor' class='floor'></div>")
    $("#floor").hide();
}

function showText()
{
    text = document.getElementById(currentInput.attr("id"));
    div = document.getElementById("floor");
    div.style.left = getPos(text,"Left") + "px";
    div.style.top = getPos(text,"Top") + text.offsetHeight +3+ "px";
    div.style.width = text.offsetWidth - 2 +100+ "px";
    $("#floor").show();
}

function hideText()
{
//alert(111);
    $("#floor").hide();
    $("#floor").html("");
    key="";    
    currentInput = null;
    isShow = false;
}

function getPos(el,ePro)				
{
    var ePos=0;
    while(el!=null)
    {		
        ePos+=el["offset"+ePro];
        el=el.offsetParent;
    }
    return ePos;
}

function searchKey(keycode)
{
    if(keycode == 38 || keycode == 40 || keycode == 13 || keycode == 27 || keycode == 9) return;    
    if(currentInput != null && (key == "" || currentInput.val() != key) && currentInput.val().length >= kwlength)
    {
//    alert(parameterNameTable);
//    alert(parameterNameField);
    
        var divs = "";
        jQuery.ajax({
            type: "Post",
            dataType: "text",
            url: dataRequest,            
            data:parameterNameTable+"&"+parameterNameField+"&"+(parameterName != "" ? parameterName + "=" + currentInput.val():(currentInput.attr("name") == null ? currentInput.attr("id") + "=" + currentInput.val():currentInput.serialize())),
            success: function(msg){                
                if(msg.length==0)
                {
                    hideText();
                    return;
                }
                var datas = msg.split(seperator);
                $.each(datas, function(i, n){
                    if(n.length > 0) divs+="<div class=unselected onclick=setInput() onmouseout = $(this).attr('class','unselected') onmouseover = mouseover(this)>"+ n +"</div>";
                });
                $("#floor").html(divs);
                isShow = true;
                showText();
                
            }
        });
        //alert(data);
        key = currentInput.val();
    }    
    if(key.length == 0 || key.length < kwlength) hideText();
}
function setInput()
{
 //alert(111);
    selectedDiv = $("#floor>div[@class=selected]");
    if(selectedDiv.length<1)
    {
        hideText();
        return;
    }
    currentInput.val(selectedDiv.text());
    hideText();
   
}
function findNextInput(target)
{   
    var index;
    $("input[@type=text]").each(function(i){
        if($(this).attr("id") == target.attr("id")) index = i;
    });
    return $("input[@type=text]")[ index + 1 ];
}

function selectText(keycode,sInput)
{    
    currentInput = $("#"+sInput.id);
    if(keycode == 13)
    {        
//        if(autoTab) $(findNextInput(currentInput)).focus();
//        hideText();
            setInput();
            
    }
    if(!isShow) return;
    if(keycode == 27) hideText();    
    selectedDiv = $("#floor>div[@class=selected]");
    if(selectedDiv.text() != "")
    {
        selectedDiv.attr("class","unselected");
        if(keycode == 38)
        {
            if(selectedDiv.prev().text() != "")
            {
                selectedDiv.prev().attr("class","selected");
                //currentInput.val(selectedDiv.prev().text());
            }
            else
            {
                $("#floor>div:last").attr("class","selected");
                //currentInput.val($("#floor>div:last").text());                
            }
        }
        else if(keycode == 40)
        {
            if(selectedDiv.next().text() != "")
            {
                selectedDiv.next().attr("class","selected");
               // currentInput.val(selectedDiv.next().text());
            }
            else
            {
                $("#floor>div:first").attr("class","selected");
                //currentInput.val($("#floor>div:first").text());                
            }
        }            
    }
    else if(keycode == 38)
    {
        $("#floor>div:last").attr("class","selected");
        //currentInput.val($("#floor>div:last").text());
    }
    else if(keycode == 40)
    {
        $("#floor>div:first").attr("class","selected");
        //currentInput.val($("#floor>div:first").text());        
    }
}

function mouseover(sDiv)
{    
    $("#floor").children("div").attr("class","unselected");
    $(sDiv).attr("class","selected");
    //currentInput.val($(sDiv).text());
}
