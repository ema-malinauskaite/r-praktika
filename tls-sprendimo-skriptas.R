fun_atomu_grupiu_sumoms <- function(liz_kont, grupavimo_failas) { #pirmas kintamasis- kontaktu failas su pridetais pavadinimais ar1_atom1,

  #-------
  # atomu pervadinimas pilnesniu pavadinimu

  kontaktai_atomu_pavadinimai <- liz_kont %>%
    select(V6, V7, V13, V14, V15) %>%
    filter(V13 != ".") %>%
    filter(V7 != "OXT") %>% #!!!!!!!!!!!!!!!!!
    filter(V14 != "OXT") %>% #!!!!!!!!!!!!!!!!!
    mutate(V6 = recode_factor(V6,"MSE" = "MET")) %>%
    mutate(V13 = recode_factor(V13,"MSE" = "MET"))

  kontaktai_atomu_pavadinimai$ar1_atom1 <- with(kontaktai_atomu_pavadinimai, paste0(V6,V7))
  kontaktai_atomu_pavadinimai$ar2_atom2 <- with(kontaktai_atomu_pavadinimai, paste0(V13,V14))

  #------
  # Grupes priskyrimas kiekvienam atomui
  grupavimo_lentele <- grupavimo_failas %>%
    mutate_all(na_if,"") %>%
    tibble::column_to_rownames(var = "V1")
  grupes_pavadinimai <- rownames(grupavimo_lentele)

  kontaktai_atomu_pavadinimai <- kontaktai_atomu_pavadinimai %>%
    mutate(grupe1 = 0) %>%
    mutate(grupe2 = 0)

  for (i in grupes_pavadinimai) {
    viena_eilute <- grupavimo_lentele[i,]
    viena_eilute <- viena_eilute[,colSums(is.na(viena_eilute)) == 0]
    for (j in viena_eilute) {
      kontaktai_atomu_pavadinimai <- kontaktai_atomu_pavadinimai %>%
        mutate(grupe1 = ifelse(ar1_atom1 == j, i, grupe1)) %>%
        mutate(grupe2 = ifelse(ar2_atom2 == j, i, grupe2))
    }
  }
  #-----
  # Isrusiuotu pavadinimu grupe1-grupe2 sudarymas ir kontakto sumu skaiciavimas pagal grupes
  matrica_pavadinimams <- as.matrix(data.frame(grupe1 = kontaktai_atomu_pavadinimai$grupe1, grupe2 = kontaktai_atomu_pavadinimai$grupe2))

  surusiuoti_pavad <- matrica_pavadinimams %>%
    split(., row(.)) %>% sapply(
      . %>% sort %>% paste(collapse = "-")
    ) %>% data.frame

  atom_kont_sumos <- cbind(kontaktai_atomu_pavadinimai, surusiuoti_pavad) %>%
    rename(kontakto_tipas = ".") %>%
    group_by(kontakto_tipas) %>%
    summarise(kontakto_suma = sum(V15))

  #-----
  # Nulines lenteles kurimas
  grupavimo_lentele <- grupavimo_failas %>%
    mutate_all(na_if,"") %>%
    tibble::column_to_rownames(var = "V1")
  grupes_pavadinimai <- rownames(grupavimo_lentele)

  nuline_lentele_atomu_grupiu_pavadinimai<- data.frame(1:(nrow(grupavimo_lentele)^2))

  nuline_lentele_atomu_grupiu_pavadinimai$pirma <- data.frame(rep(grupes_pavadinimai, each = nrow(grupavimo_lentele)))
  nuline_lentele_atomu_grupiu_pavadinimai$antra <- rep(grupes_pavadinimai, times = nrow(grupavimo_lentele))

  matrica_pavadinimams_nuline <- as.matrix(data.frame(grupe1 = nuline_lentele_atomu_grupiu_pavadinimai$pirma, grupe2 = nuline_lentele_atomu_grupiu_pavadinimai$antra))

  nuline_lentele_atomu <- matrica_pavadinimams_nuline %>%
    split(., row(.)) %>% sapply(
      . %>% sort %>% paste(collapse = "-")
    ) %>% data.frame() %>%
    rename("kontakto_tipas" = ".")


  nuline_lentele_atomu$nuliai <- rep(0, times = nrow(nuline_lentele_atomu))

  nuline_lentele_atomu <- nuline_lentele_atomu %>%
    group_by(kontakto_tipas) %>%
    summarise(nuliai = sum(nuliai)) %>%
    transpose(make.names = "kontakto_tipas")

  nuline_lentele_atomu
  #-----
  # Standartizavimas

  atom_kont_sumos <- spread(atom_kont_sumos, kontakto_tipas, kontakto_suma)

  sujungta <- full_join(nuline_lentele_atomu, atom_kont_sumos) %>%
    gather() %>%
    group_by(key) %>%
    summarise(kontakto_suma = sum(value)) %>%
    mutate_all(~replace(., is.na(.), 0)) %>%
    spread(., key, kontakto_suma)

  #----------
  return(sujungta)
}




