source("seloger_api.R")
# TODO


search_url_paris <- "http://ws.seloger.com/search.xml?idtt=1&cp=75&tri=d_dt_crea"
search_url_paris_plus_200 <- "http://ws.seloger.com/search.xml?idtt=1&cp=75&tri=d_dt_crea&surfacemax=10"
search_url_1_pg <- "http://ws.seloger.com/search.xml?idtt=1&ci=330192&tri=d_dt_crea&pxmax=400"
search_url_no_result <- "http://ws.seloger.com/search.xml?idtt=1&ci=330192&tri=d_dt_crea&pxmax=1"

xml_paris <- xmlParse(search_url_paris)

xml_1_page <- xmlParse(search_url_1_pg)

df_test <- xml_listing_to_df(xml_1_page)


get_total_nb_listing(xml_paris)

get_displayed_nb_listing(xml_paris)
get_next_pg_url(xml_paris)

get_next_pg_url(xml_1_page)


all_pg_xml_paris <- get_all_page_xml(search_url_paris)
all_pg_xml_paris[[1]] 
all_pg_xml_paris[[4]]

no_result <- get_all_page_xml(search_url_no_result)


# TODO : compare w/ verbose output to at least count number of listings retrieved
listing_paris_test_1 <- get_all_listing_df(postal_cd = 75, search_type = "rent", max_surf_area = 10, verbose = TRUE)

#complete_df_paris_test_1 <- bind_rows(listing_paris_test_1)

# 608 listings (inflated number by SeLoger after some analysis)
nrow(complete_df_paris_test_1) #577
length(unique(complete_df_paris_test_1$listing_id)) #567

merged_paris_test_1 <- merge_listing_df(listing_paris_test_1)
nrow(merged_paris_test_1) #567
length(unique(merged_paris_test_1$listing_id)) #567

head(merged_paris_test_1)

object.size(merged_paris_test_1) #511KB

merged_paris_test_1 %>% 
  filter(listing_id == 111414119) %>%
  select(crtn_dt, updt_dt, title, price, surf_area, postal_cd, description)


listing_paris_test_2 <- get_all_listing_df(postal_cd = 75, search_type = "rent", max_surf_area = 10, verbose = TRUE)


complete_df_paris_test_1[duplicated(complete_df_paris_test_1$listing_id), ]

tail()
max(merged_paris_test_1$price)
merged_paris_test_1[max2(merged_paris_test_1$price), ]$price

min(merged_paris_test_1$price)




url_rent_and_price <- "http://ws.seloger.com/search.xml?cp=75&idtt=1&pxmin=199&tri=a_px&SEARCHpg=4"

rent_price_df <- xmlParse(url_rent_and_price) %>% xml_listing_to_df()

str(rent_price_df)

filter(rent_price_df, listing_id == 114112911)$rent
filter(rent_price_df, listing_id == 114112911)$price


#  Error in if (min_price >= max_price) { 
# Missing value where true false needed bug
null_bug_url <- "http://ws.seloger.com/search.xml?cp=75007&idtt=2&pxmin=790000&tri=a_px&SEARCHpg=4"
null_bug_df <- xmlParse(null_bug_url) %>% xml_listing_to_df()
max(coalesce(null_bug_df$rent, null_bug_df$price))

max(coalesce(null_bug_df$rent, null_bug_df$price), na.rm = TRUE)

null_bug_df$rent
null_bug_df$price
