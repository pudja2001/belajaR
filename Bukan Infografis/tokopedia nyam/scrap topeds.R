# url yang dipakai adalah
# https://www.tokopedia.com/discovery/flash-sale-tokopedia-nyam
# https://www.tokopedia.com/discovery/nyam-minuman/
# https://www.tokopedia.com/discovery/nyam-makanan/

setwd("~/belajaR/Bukan Infografis/tokopedia nyam")

rm(list=ls())
library(rvest)
library(dplyr)

# PART 1
# input loc
#ini aja nanti yang diganti
input_loc = "~/belajaR/Bukan Infografis/tokopedia nyam/Link/"
nama_file = "22 Oktober 2020 makanan"  #baru sampe mari yah

# ambil dbase links 
url = paste0(input_loc,nama_file,".txt")
url = readLines(url)

# bebersih links
dbase_link = 
  data.frame(
    id = 1,
    url = url
  ) %>% 
  filter(!grepl("discovery",url,ignore.case = T)) %>% 
  filter(!grepl("deal",url,ignore.case = T)) %>% 
  mutate(penanda = stringr::str_length(url)) %>% 
  arrange(penanda) %>% 
  filter(penanda >= 50)

url = dbase_link$url

# PART 2
# Fungsi scrape data
scrap = function(url){
  data = 
    read_html(url) %>% {
      tibble(
        nama = html_nodes(.,'.css-x7lc0h') %>% html_text(),
        harga = html_nodes(.,".css-c820vl") %>% html_text(),
        seller = html_nodes(.,'.css-xmjuvc') %>% html_text(),
        terjual = html_nodes(.,'b') %>% html_text(),
        lokasi = html_nodes(.,".css-1s83bzu span") %>% html_text(),
        link = url,
        keterangan = nama_file
        )
    }
  return(data)
}


i = 1
data = scrap(url[i])

for(i in 2:length(url)){
  temp = scrap(url[i])
  data = rbind(data,temp)
  print(paste0('ambil data ke ',
               i,
               ' done - alhamdulillah'))
}

data$waktu.scrape = Sys.time()
data = distinct(data)

setwd("~/belajaR/Bukan Infografis/tokopedia nyam")

load("hasil scrape.rda")
raw = rbind(raw,data)
save(raw,file = 'hasil scrape.rda')