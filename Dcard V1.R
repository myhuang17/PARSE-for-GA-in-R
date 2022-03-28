library(tidyverse)
library(httr)
library(jsonlite)
library(lubridate)
library(magrittr)
options(stringsAsFactors = F)
#設定一個空的資料集，幫助儲存爬下來的資料
temp_data <- tibble()
#dcard api url
page_url = c("https://www.dcard.tw/_api/forums/badminton/posts?popular=false")
res2 = GET(page_url) %>% content("text") %>% fromJSON() %>%
  select(-anonymousSchool, -anonymousDepartment, -pinned, -meta, -mediaMeta, -layout, -withImages, -withVideos, -media, -reportReasonText)
fix_url2 = "https://www.dcard.tw/_api/forums/badminton/posts?popular=false"
last_id2 = last(res2$id) #檢查是否為最後一個id
for (i in 1:10) {
  url2 = paste0(fix_url2, "&limit=100&before=", last_id2) %>% print()
  resdata = GET(url2) %>% content("text") %>% fromJSON() %>% select(-anonymousSchool, -anonymousDepartment, -pinned, -meta, -mediaMeta, -layout, -withImages, -withVideos, -media, -reportReasonText)
  res2 = bind_rows(res2, resdata)
  message(nrow(resdata))
}
ans = data.frame(id = res2$id, title = res2$title, text = res2$excerpt, origin_link = res2$forumId)
for (i in 1:length(ans[,1])){
  ans$origin_link[i] = paste0("https://www.dcard.tw/f/badminton/p/", ans$id[i])
}
write.csv(ans, file = 'C:\\Users\\user\\Desktop\\DATA_1.csv')

#use_python("C:\\Users\\user\\AppData\\Local\\Programs\\Python\\Python38\\python.exe", required = T)
#jieba_py <- import_from_path('jieba', path = "C:\\Users\\user\\AppData\\Local\\Programs\\Python\\Python38\\jieba-tw-master", convert = TRUE, delay_load = FALSE)
