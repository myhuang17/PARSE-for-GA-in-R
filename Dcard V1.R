library(tidyverse)
library(httr)
library(jsonlite)
library(lubridate)
library(magrittr)
options(stringsAsFactors = F)
#設定一個空的資料集，幫助我們儲存爬下來的資料
temp_data <- tibble()
#dcard api url
page_url = c("https://www.dcard.tw/_api/forums/badminton/posts?limit=100")
res2 = GET(page_url) %>% content("text") %>% fromJSON() %>%
  select(-anonymousSchool, -anonymousDepartment, -pinned, -meta, -mediaMeta, -layout, -withImages, -withVideos, -media, -reportReasonText)
fix_url2 = "https://www.dcard.tw/_api/forums/badminton/posts?limit=100"
last_id2 = last(res2$id) #檢查是否為最後一個id
for (i in 1:10) {
  url2 = paste0(fix_url2, "&limit=100&before=", last_id2) %>% print()
  resdata = GET(url2) %>% content("text") %>% fromJSON() %>% select(-anonymousSchool, -anonymousDepartment, -pinned, -meta, -mediaMeta, -layout, -withImages, -withVideos, -media, -reportReasonText)
  res2 = bind_rows(res2, resdata)
  message(nrow(resdata))
}
ans = data.frame(id = res2$id, title = res2$title, text = res2$excerpt, origin_link = res2$forumId)
write.csv(ans, file = 'C:\\Users\\user\\Desktop\\碩\\一下\\3 網路流量分析與行銷應用\\外部資料蒐集\\DATA_1.csv')
