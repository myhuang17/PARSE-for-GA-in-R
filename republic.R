library(rvest)
html = read_html("http://www.badmintonrepublic.com/phpbb3/viewforum.php?f=17&sid=df582166a8444e7bd7c7e39c772666e5")
title = html_nodes(html, "a.topictitle")
tt = html_text(title)#文章名
zz = html_attrs(title)#有連結，href
lk = NULL
for (i in 1:length(zz)) {
  pp = as.character(zz[[i]][1])
  pp = substr(pp,2,nchar(pp))
  lk[i] = paste0("http://www.badmintonrepublic.com/phpbb3", pp)
}
table = cbind(tt,lk)
