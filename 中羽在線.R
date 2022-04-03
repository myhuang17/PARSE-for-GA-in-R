#library(RSelenium)#專爬動態網頁
library(rvest)
library(stringi)
#=====================爬連結區__爬各廠
rt1 = NULL
rt2 = NULL
big_table = NULL
dh = c(1, 2, 13, 22)
for (zx in 1:length(dh)) {
  for(pg in 1:3){
    link = paste0("https://www.badmintoncn.com/cbo_eq/list.php?brand=", dh[zx],"&sort=0&class=1&fee=&name=&order=buy&page=", pg)
    html = read_html(link)
    html = html_nodes(html, "div.list")
    tt = html_nodes(html, "a.listName")
    title = html_text(tt)
    title = gsub("\n","",title)#標題
    lk = html_attr(tt, "href")
    lk_a = substr(lk, 1, 12)
    lk_b = gsub(lk_a[1], "", lk)
    lk = paste0("https://www.badmintoncn.com", lk_a, "_specs", lk_b)#連結
    pt = html_nodes(html, "span.right")
    pt = html_text(pt)
    pt = pt[3:32]
    pt = gsub("\n","",pt)#評分
    rt = html_nodes(html, "span.smalltext")
    rt = html_text(rt)[2:31]
    rt = strsplit(rt,"；")
    for(i in 1:length(rt)){
      rt1[i] = rt[[i]][1]#想要
      rt2[i] = rt[[i]][2]#用過
    }
    rt1 = gsub("人想要","",rt1)#想要
    rt2 = gsub("人用过","",rt2)#用過
    table = cbind(title, lk, pt, rt1, rt2)
  }
  big_table = rbind(big_table, table)
}

#==========================================相關資訊
#基礎資料
infos = function(link){
  pai_l = read_html(link)
  pai_l = html_nodes(pai_l, "div.div_5")
  pai_1 = html_nodes(pai_l, "div.list")[1]
  pai_t = html_text(pai_1)[1]
  pai_t = strsplit(pai_t,"\r\n")
  pai_if = cbind(pai_t[[1]][6], pai_t[[1]][8], pai_t[[1]][12], pai_t[[1]][14], pai_t[[1]][16])#, pai_t[[1]][18], pai_t[[1]][19])#品牌,系列,價格,描述,上市時間,產地,代碼
  #參數
  pai_2 = html_nodes(pai_l, "div.list")[2]
  pai_2t = html_text(pai_2)
  pai_2t = strsplit(pai_2t,"\r\n")
  pai_2ta = gsub("\t\t", "", pai_2t[[1]])
  pai_pa = cbind(pai_2ta[4], pai_2ta[6], pai_2ta[8], pai_2ta[10], pai_2ta[12], pai_2ta[14], pai_2ta[16], pai_2ta[18])
  
  pai = cbind(pai_if, pai_pa)
  return(pai)
}


#==================================MAIN
btabo = NULL
for (x in 1:length(big_table[,1])) {
  binfo = infos(big_table[x,2])
  btabo = rbind(btabo, binfo)
}
bx = cbind(big_table,btabo)
write.csv(ans, file = 'C:\\Users\\user\\Desktop\\DATA_中羽在線.csv')
