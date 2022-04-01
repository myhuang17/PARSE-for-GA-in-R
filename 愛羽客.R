#library(RSelenium)#專爬動態網頁
library(rvest)
#=====================爬連結區
tabl = NULL
for (i in 1:10) {
  link = paste0("https://quanzi.tiyushe.com/group/view.html?id=13&type=2&page=",i)
  html = read_html(link)
  zz = html_nodes(html, "li.group-invitation-item")
  li = html_nodes(zz, "a")
  li = html_attr(li, "href")#連結
  tt = html_nodes(zz,"span.item-title")
  title = html_text(tt)#標題
  tm = html_nodes(zz, "span.item-bottom-time")
  tm = html_text(tm)
  tb = cbind(title, li, tm)
  tabl = rbind(tabl, tb)
}

#=====================內文區
content = function(link){
  html = read_html(link)
  ct = html_nodes(html, "div#js-article-content")
  tt = html_text(ct)
  return(tt)
}
tb_ct = NULL
for(i in 1:length(tabl[,1])){
  tb_ct[i] = content(tabl[i,2])
}
