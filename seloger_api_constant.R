BASE_URL <- "http://ws.seloger.com"
BASE_SEARCH_URL <- paste0(BASE_URL, "/search.xml?")


# Original French attributes names used for the listings in the API
# Some unnecessary attributes are commented and are kept for information purposes
LISTING_ATTR_FR_API <- c(
  "idTiers"
  , "idAnnonce"
  , "idAgence"
  #, "idPublication"
  #, "idTypeTransaction"
  , "idTypeBien"
  , "dtFraicheur"
  , "dtCreation"
  , "titre"
  , "libelle"
  , "proximite"
  , "descriptif"
  , "prix"
  , "prixUnite"
  , "prixMention"
  , "loyer"
  , "loyerUnite"
  , "loyerAnnuel"
  , "loyerAnnuelUnite"
  , "nbPiece"
  , "nbChambre"
  , "surface"
  , "surfaceUnite"
  , "idPays"
  , "pays"
  , "cp"
  , "codeInsee"
  , "ville"
  , "nbPhotos"
  , "latitude"
  , "longitude"
  , "typeDPE"
  , "consoEnergie"
  , "bilanConsoEnergie"
  , "emissionGES"
  , "bilanEmissionGES"
  , "siLotNeuf"
  , "nbsallesdebain"
  , "nbsalleseau"
  , "nbtoilettes"
  , "sisejour"
  , "surfsejour"
  , "anneeconstruct"
  , "nbparkings"
  , "nbboxes"
  , "siterrasse"
  , "nbterrasses"
  , "sipiscine")

# English attributes names => make sure the number and order is the same as in LISTING_ATTR_FR_API
LISTING_ATTR_EN <- c(
  "party_id"
  , "listing_id"
  , "agency_id"
  #, "publication_id"
  #, "transaction_type_cd"
  , "property_type_cd"
  , "updt_dt"
  , "crtn_dt"
  , "title"
  , "label"
  , "close_to"
  , "description"
  , "price"
  , "price_unit"
  , "price_notes"
  , "rent"
  , "rent_unit"
  , "annual_rent"
  , "annual_rent_unit"
  , "room_nb"
  , "bedroom_nb"
  , "surf_area"
  , "surf_area_unit"
  , "country_id"
  , "country"
  , "postal_cd"
  , "location_insee_cd"
  , "city"
  , "photo_nb"
  , "latitude"
  , "longitude"
  , "dpe_type"
  , "energy_consump"
  , "energy_consump_assesment"
  , "ges_emission"
  , "ges_emission_assessment"
  , "is_new_lot"
  , "bathroom_nb"
  , "shower_room_nb"
  , "toilet_nb"
  , "has_living_room"
  , "living_room_surf_area"
  , "construction_dt"
  , "parking_nb"
  , "box_nb"
  , "has_patio"
  , "patio_nb"
  , "has_pool")

############################################################################
# Parameter names to use in the search URL
############################################################################
SEARCH_PG_PARAM_NM <- "searchpg"

############################################################################
# Mapping between parameter values to use in the search URL
# and their meaning
############################################################################
SEARCH_TYPE_PARAM_VALUE <- list(rent = 1, sale = 2)
PROPERTY_TYPE_PARAM_VALUE <- list(
  appartment = 1
  , house = 2
  , parking_or_box = 3
  , land = 4
  , shop = 6
  , commercial_building = 7
  , office = 8
  , loft_or_workshop = 9
  , residential_building = 11
  , other_building = 12
  , castle = 13
  , hotel = 14
  , program = 15
)

ORDER_BY_PARAM_VALUE <- list(
  dt_desc = "d_dt_crea"
  , dt_asc = "a_dt_crea"
  , price_desc = "d_px"
  , price_asc = "a_px"
  , surf_area_desc = "d_surface"
  , surf_area_asc = "a_surface"
)