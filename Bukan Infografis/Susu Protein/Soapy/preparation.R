rm(list=ls())
library(dplyr)

# ambil dbase links 
link = readLines('link produk.txt')
link = unique(link)
dummy = data.frame(id = c(1:length(link)),
                   url = link,
                   asli = link) %>% 
  filter(grepl('-i.',url,fixed = T)) %>% 
  filter(!grepl("help",url)) %>% 
  mutate(url = gsub("wpi","",url,ignore.case = T),
         url = gsub("isi","",url,ignore.case = T),
         url = gsub("iso","",url,ignore.case = T),
         url = gsub("imi","",url,ignore.case = T),
         url = gsub("im","",url,ignore.case = T),
         url = gsub("in","",url,ignore.case = T)) %>% 
  tidyr::separate(url,into = c('hapus','pakai'),sep = '-i.') %>% 
  tidyr::separate(pakai, into = c('info1','info2'),sep = '\\.') %>%
  mutate(link_final = paste0('https://shopee.co.id/api/v2/item/get?itemid=',
                             info2,
                             '&shopid=',
                             info1))
dummy %>% filter(is.na(info2)) %>% View()

url = dummy$link_final
save(url,file = 'hasil scrape.rda')