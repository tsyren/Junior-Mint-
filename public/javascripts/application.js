// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var d = document;
	var winIE = (navigator.userAgent.indexOf("Opera")==-1 && (d.getElementById && d.documentElement.behaviorUrns)) ? true : false;
	function bodySize(){
	if(winIE && d.documentElement.clientWidth) {
		sObj = d.getElementsByTagName("body")[0].style;
		sObj.width = (d.documentElement.clientWidth<740) ? "740px" : "100%";
		}
	}
	function init(){
		if(winIE) { bodySize(); }
	}
	onload = init;
	if(winIE) { onresize = bodySize; }
function maxlength(element, maxvalue)
{
 if( $(element).value.length > maxvalue){
   $(element).value = $(element).value.substring(0, maxvalue);
   alert("длина превышена");
  }
}
function mark_for_destroy(element){
	$(element).next('.should_destroy').value = 1;
	$(element).up('.question').hide();
}
function validate_form(form,msg){
   if(form.comment[content].value == ''){
       alert( msg );
       form.comment[content].focus();
       return false;
   }
   return true;
}
