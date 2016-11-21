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



get_all_listing_df(postal_cd = 75, max_surf_area = 10, verbose = TRUE)


get_all_listing_df(postal_cd = 75, min_price = 10, max_surf_area = 10, verbose = TRUE)
