/*
	Paginator 3000
	- idea by ecto (fhn.ru)
	- coded by karaboz (futurico.ru)
*/

Paginator = function(id, pagesTotal, pagesSpan, currentPage, baseUrl, indexPage){
	this.htmlBox = $(id);
	if(!this.htmlBox || !pagesTotal || !pagesSpan) return;

	this.pagesTable;
	this.pagesTr; 
	this.sliderTr;
	this.pagesCells;
	this.slider;
	
	this.pagesTotal = pagesTotal;
	if(pagesSpan < pagesTotal){
		this.pagesSpan = pagesSpan;
	} else {
		this.tableWidth = Math.floor(100*pagesTotal/pagesSpan) + '%';
		this.htmlBox.addClass('fullsize');
		this.pagesSpan = pagesTotal;
	}
	
	this.currentPage = currentPage;
	this.firstCellValue;

	if(baseUrl){
		this.baseUrl = baseUrl;
	} else {
		this.baseUrl = "/pages/";
	}
	

	this.initPages();
	this.initSlider();
	this.drawPages();
	this.initEvents();

	this.scrollToCurrentPage();
	this.setCurrentPagePoint();
} 

Paginator.prototype.initPages = function(){
	var html = "<table><tr>" 
	for (var i=1; i<=this.pagesSpan; i++){
		html += "<td></td>"
	}
	html += "</tr>" +
	"<tr><td colspan='" + this.pagesSpan + "'>" +
	"<div class='scrollbar'>" + 
		"<div class='line'></div>" + 
		"<div class='current_page_point'></div>" + 
		"<div class='slider'>" + 
			"<div class='slider_point'></div>" + 
		"</div>" + 
	"</div>" +
	"</td></tr></table>"
	this.htmlBox.innerHTML = html;

	this.pagesTable = this.htmlBox.getElements('table')[0];
	this.pagesTr = this.pagesTable.getElements('tr')[0]; 
	this.sliderTr = this.pagesTable.getElements('tr')[1];
	this.pagesCells = this.pagesTr.getElements('td');
	this.scrollbar = this.pagesTable.getElement('.scrollbar');
	this.slider = this.pagesTable.getElement('.slider');
	this.currentPagePoint = this.pagesTable.getElement('.current_page_point');
	
	$(this.pagesTable).setStyle('width', this.tableWidth);
}

Paginator.prototype.initSlider = function(){
	this.slider.xPos = 0;
	this.slider.style.width = this.pagesSpan/this.pagesTotal * 100 + "%";	
}

Paginator.prototype.initEvents = function(){
	var _this = this;

	this.slider.onmousedown = function(e){
		if (!e) var e = window.event;
		e.cancelBubble = true;
		if (e.stopPropagation) e.stopPropagation();
		var e_ = new Event(e);
		this.dx = e_.page.x - this.xPos;
		document.onmousemove = function(e){
			var e_ = new Event(e);
			if (!e) var e = window.event;
			_this.slider.xPos = e_.page.x - _this.slider.dx;
			_this.setSlider();
			_this.drawPages();
		}
		document.onmouseup = function(){
			document.onmousemove = null;
			_this.enableSelection();
		}
		_this.disableSelection();
	}

	this.scrollbar.onmousedown = function(e){
		if(_this.paginatorBox && _this.paginatorBox.hasClass('fullsize')) return;
		if (!e) var e = window.event;
		var e_ = new Event(e);
		_this.slider.xPos = e_.page.x - $(_this.scrollbar).getPosition().x - _this.slider.offsetWidth/2;
		_this.setSlider();
		_this.drawPages();
	}

	addEvent(window, 'resize', resizePaginator);
	
	document.onkeydown = function(event) {
		event = new Event(event);
		var tagName = event.target.tagName;
		if (tagName != 'INPUT' && tagName != 'TEXTAREA' && !event.alt && event.control) {
			
			if (event.key == 'left') {
				if (_this.currentPage > 1) {
					window.location.href = _this.baseUrl + (_this.currentPage - 1);
				}
			} else if (event.key == 'right') {
				if (_this.currentPage < _this.pagesTotal) {
					window.location.href = _this.baseUrl + (_this.currentPage + 1);
				}
			}
		}
	}
	

}

Paginator.prototype.setSlider = function(){
	this.slider.style.left = this.slider.xPos + "px";

}

Paginator.prototype.drawPages = function(){

	var percentFromLeft = this.slider.xPos/(this.pagesTable.offsetWidth);
	
	this.firstCellValue = Math.round(percentFromLeft * this.pagesTotal);
	var html = "";
	if(this.firstCellValue < 1){
		this.firstCellValue = 1;
		this.slider.xPos = 0;
		this.setSlider();
	} else if(this.firstCellValue >= this.pagesTotal - this.pagesSpan) {
		this.firstCellValue = this.pagesTotal - this.pagesSpan + 1;
		this.slider.xPos = this.pagesTable.offsetWidth - this.slider.offsetWidth;
		this.setSlider();
	}
	for(var i=0; i<this.pagesCells.length; i++){
		var currentCellValue = this.firstCellValue + i;
		var prefixLength = String(this.pagesTotal).length - String(currentCellValue).length;
		var prefix = this.makePrefix(prefixLength);
		if(currentCellValue == this.currentPage){
			html = "<span>" + "<em>" + String(currentCellValue) + "</em>" + String(prefix) + "</span>";
		} else {
			html = "<span>" + "<a href='" + this.baseUrl + currentCellValue + "'>" + String(currentCellValue) + "</a>" + String(prefix) + "</span>";
		}
		this.pagesCells[i].innerHTML = html;
	}
}

Paginator.prototype.scrollToCurrentPage = function(){
	this.slider.xPos = (this.currentPage - Math.round(this.pagesSpan/2))/this.pagesTotal * this.pagesTable.offsetWidth;
	this.setSlider();
	this.drawPages();
}

Paginator.prototype.setCurrentPagePoint = function(){
	if(this.currentPage == 1){
		this.currentPagePoint.style.left = 0;
	} else {
		this.currentPagePoint.style.left = this.currentPage/this.pagesTotal * this.pagesTable.offsetWidth + "px";	
	}
}

Paginator.prototype.makePrefix = function(prefixLength){
	var prefix = "";
	for (var i=0; i<prefixLength; i++){
		prefix += "_";
	}
	return prefix;
}

Paginator.prototype.disableSelection = function(){
	document.onselectstart = function(){
		return false;
	}
	this.slider.focus();	
}

Paginator.prototype.enableSelection = function(){
	document.onselectstart = function(){
		return true;
	}
	this.slider.blur();		
}

resizePaginator = function (){
	if(typeof pag == 'undefined') return;

	pag.setCurrentPagePoint();
	pag.scrollToCurrentPage();
}