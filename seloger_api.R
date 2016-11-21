require(XML)
require(stringr)
require(dplyr)
source("seloger_api_constant.R")

# TODO : Use constants for ALL string literals

# TODO : doc (1 sentence explanation, descr arg IN and OUT)

# search_type : 1 = "for rent"", 2 = "for sale"
# property_type : character vector and NA for all
# postal_cd : TODO : have link to postal code / insee code mapping
# TODO : basic arg checking ?
get_search_url <- function(
  postal_cd
  , search_type = names(SEARCH_TYPE_PARAM_VALUE)
  , property_type = NULL
  , min_price = NULL
  , max_price = NULL
  , min_surf_area = NULL
  , max_surf_area = NULL
  , order_by = names(ORDER_BY_PARAM_VALUE)
) {
  
  # Argument checking
  search_type <- match.arg(search_type)
  order_by <- match.arg(order_by)
  if(!is.null(min_price) && !is.numeric(min_price)) {
    stop("Argument \"min_price\" should be numeric")
  }
  if(!is.null(max_price) && !is.numeric(max_price)) {
    stop("Argument \"max_price\" should be numeric")
  }
  if(!is.null(min_surf_area) && !is.numeric(min_surf_area)) {
    stop("Argument \"min_surf_area\" should be numeric")
  }
  if(!is.null(max_surf_area) && !is.numeric(max_surf_area)) {
    stop("Argument \"max_surf_area\" should be numeric")
  }
  
  #search_type
  search_param <- paste0("idtt=", SEARCH_TYPE_PARAM_VALUE[[search_type]])
  # postal_cd
  search_param <- paste0(search_param, "&cp=", paste(postal_cd, collapse = ","))
  # property_type
  if(!all(is.null(property_type)) ) {
    property_type_char <- paste(unlist(PROPERTY_TYPE_PARAM_VALUE[property_type]), collapse = ",")
    search_param <- paste0(search_param, "&idtypebien=", property_type_char)  
  }
  # min_price
  if(!is.null(min_price)) {
    search_param <- paste0(search_param, "&pxmin=", min_price)  
  }
  # max_price
  if(!is.null(max_price)) {
    search_param <- paste0(search_param, "&pxmax=", max_price)  
  }
  # min_surf_area
  if(!is.null(min_surf_area)) {
    search_param <- paste0(search_param, "&surfacemin=", min_surf_area)  
  }
  # max_surf_area
  if(!is.null(max_surf_area)) {
    search_param <- paste0(search_param, "&surfacemax=", max_surf_area)  
  }
  # order_by
  if(!is.null(order_by)) {
    search_param <- paste0(search_param, "&tri=", ORDER_BY_PARAM_VALUE[[order_by]])  
  }
  
  # Output search URL
  paste0(BASE_SEARCH_URL, search_param)
}

# IN : XML (result of xmlParse)
# OUT : listings dataframe
xml_listing_to_df <- function(xml) {
  if(is.null(xml)) {
    xml_df <- NULL
  } else {
    # Convert the listings nodes to a dataframe
    listing_nodes <- getNodeSet(xml, "//annonce")
    if(length(listing_nodes) == 0) {
      xml_df <- data.frame(matrix(nrow = 0, ncol = length(LISTING_ATTR_EN)))
      names(xml_df) <- LISTING_ATTR_EN
      warning("No listings found in XML")
    } else {
      xml_df_tmp <- xmlToDataFrame(listing_nodes, colClasses = NULL, homogeneous = FALSE
                               , collectNames = TRUE)
      
     
      # Create dataframe with all the useful columns
      xml_df <- data.frame(matrix(nrow = 0, ncol = length(LISTING_ATTR_FR_API)))
      names(xml_df) <- LISTING_ATTR_FR_API
      # Merge because xmlToDataFrame() does not always have all the attributes of LISTING_ATTR_FR_API
      xml_df <- merge(xml_df, xml_df_tmp, all = TRUE)
      
      # Keep only useful attributes
      xml_df <- select(xml_df, one_of(LISTING_ATTR_FR_API))
      
      # Convert French attributes to English names
      names(xml_df) <- LISTING_ATTR_EN
      
      # Convert to right types
      # Can't be done in xmlToDataFrame() because attributes are not always present and not in the same order
      xml_df$party_id <- as.integer(xml_df$party_id)
      xml_df$listing_id <- as.integer(xml_df$listing_id)
      xml_df$agency_id <- as.integer(xml_df$agency_id)
      xml_df$property_type_cd <- as.integer(xml_df$property_type_cd)
      xml_df$price <- as.numeric(xml_df$price)
      xml_df$room_nb  <- as.integer(xml_df$room_nb )
      xml_df$bedroom_nb <- as.integer(xml_df$bedroom_nb)
      xml_df$surf_area <- as.numeric(xml_df$surf_area)
      xml_df$country_id <- as.integer(xml_df$country_id)
      xml_df$postal_cd <- as.integer(xml_df$postal_cd)
      xml_df$location_insee_cd <- as.integer(xml_df$location_insee_cd)
      xml_df$photo_nb <- as.integer(xml_df$photo_nb)
      xml_df$longitude <- as.integer(xml_df$longitude)
      xml_df$longitude <- as.integer(xml_df$longitude)
      xml_df$bathroom_nb <- as.integer(xml_df$bathroom_nb)
      xml_df$shower_room_nb <- as.integer(xml_df$shower_room_nb)
      xml_df$toilet_nb <- as.integer(xml_df$toilet_nb)
    }
  }
  
  xml_df
}

get_total_nb_listing <- function(xml) {
  nodes <- getNodeSet(xml, "//nbTrouvees")
  if(length(nodes) > 0) {
    result <- xmlValue(nodes[[1]]) %>% as.numeric()
  } else {
    result <- NULL
  }
  result
}

get_displayed_nb_listing <- function(xml) {
  nodes <- getNodeSet(xml, "//nbAffichables")
  if(length(nodes) > 0) {
    result <- xmlValue(nodes[[1]]) %>% as.numeric()
  } else {
    result <- NULL
  }
  result
}

get_next_pg_url <- function(xml) {
  # TODO : remove repetitions http://ws.seloger.com/http://ws.seloger.com/http://ws.seloger.com/http://ws.seloger.com/search.xml?
  
  nodes <- getNodeSet(xml, "//pageSuivante")
  if(length(nodes) > 0) {
    result <- xmlValue(nodes[[1]])
  } else {
    result <- NULL
  }
  result
}

# Get the XML for each available page of the search  result
get_all_page_xml <- function(search_url, verbose = FALSE) {
  if(verbose) {
    print(paste("Getting XML for page :", search_url))
  }
  
  listing_xml <- list(xmlParse(search_url))
  
  
  
  next_pg_url <- get_next_pg_url(listing_xml[[1]])
  while(!is.null(next_pg_url)) {
    # Wait 1 second to not spam the server
    Sys.sleep(1)
    if(verbose) {
      print(paste("Getting XML for page :", next_pg_url))
    }
    
    listing_xml <- append(listing_xml, xmlParse(next_pg_url))
    next_pg_url <- listing_xml[[length(listing_xml)]] %>% get_next_pg_url()
  }
  
  listing_xml
}


# TODO : progress bar
get_all_listing_df <- function(..., min_price= 0, listing_df_list = NULL, verbose = FALSE) {
  # Store search parameters to be able to modify some of them afterwards
  search_param <- list(...)
  if(!is.null(search_param$order_by)) {
    stop("The order_by argument cannot be set explicitly because it needs to be forced by this function.")
  }
  
  # Force ascending price ordering for the search results
  search_url <- get_search_url(order_by = "price_asc", min_price = min_price, ...)
  
  listing_xml_list <- get_all_page_xml(search_url, verbose)
  
  nb_displayed_listing <- get_displayed_nb_listing(listing_xml_list[[1]])
  total_nb_listing <- get_total_nb_listing(listing_xml_list[[1]])
  
  if(verbose) {
    print(paste("Total number of listings :", total_nb_listing))
  }
  
  # Convert all pages XML to dataframes
  listing_df_list <- append(listing_df_list, lapply(listing_xml_list, xml_listing_to_df))

  # If not all results can be displayed, do another search to get more results
  if(total_nb_listing > nb_displayed_listing) {
    # Get current highest price to set the minimum price of the next search
    max_price <- max(listing_df_list[[length(listing_df_list)]]$price, na.rm = TRUE)
    
    # Wait 1 second to not spam the server
    Sys.sleep(1)
    
    # Recursive call to get all the results
    listing_df_list <- get_all_listing_df(..., min_price = max_price, listing_df_list = listing_df_list, verbose = verbose)
  }
  
  listing_df_list
}