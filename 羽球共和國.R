library(rvest)
#=====================爬連結區
cawler = function(link){
  html = read_html(link)
  title = html_nodes(html, "a.topictitle")
  tt = html_text(title)#文章名
  tt = tt[4:length(tt)]
  zz = html_attrs(title)#有連結，href
  lk = NULL
  for (i in 4:length(zz)) {
    pp = as.character(zz[[i]][1])
    pp = substr(pp,2,nchar(pp))
    lk[i] = paste0("http://www.badmintonrepublic.com/phpbb3", pp)
  }
  lk = lk[4:length(lk)]
  tab = cbind(tt, lk)
  return(tab)
}
table = NULL
for (x in 0:1) {
  if(x == 0){
    html_t = "http://www.badmintonrepublic.com/phpbb3/viewforum.php?f=17"
  }
  else{
    html_t = paste0("http://www.badmintonrepublic.com/phpbb3/viewforum.php?f=17","&start=",x*36)
  }
  #cawler
  tb = cawler(html_t)
  table = rbind(table,tb)
}

#=====================內文區
content = function(link){
  html = read_html(link)
  ct = html_nodes(html, "div.content")
  tt = html_text(ct)
  #內文與留言合併
  allw = NULL
  for(u in 1:length(tt)){
    allw = paste(allw, tt[u], sep = "<NEXT>")
  }
  return(allw)
}

cont = NULL
for (x in 1:length(table[,1])) {
  cont[x] = content(as.character(table[x,2]))
  Sys.sleep(0.5)
}
table = cbind(table, cont)
write.csv(table, file = 'C:\\Users\\user\\Desktop\\DATA_共和國.csv')
