roll_die <- function(success, nhits=0){
  roll <- sample(1:6, size=1)
  if (roll == 6){
    nhits = nhits + 1
    nhits <- roll_die(success, nhits)
  } else if (roll >= success) {
    nhits = nhits + 1
  }
  nhits
}

tot_hits <- function(fleg, dleg, barb, mili){
  nhits = 0
  
  if(fleg > 0){
    for (i in 1:fleg) nhits = nhits + roll_die(3)
  }
  if(dleg > 0){
    for (i in 1:dleg) nhits = nhits + roll_die(5)
  }
  if(barb > 0){
    for (i in 1:barb) nhits = nhits + roll_die(4)
  }
  if(mili){
    nhits = nhits + roll_die(5)
  }
  nhits
}

tot_strength <- function(fleg, dleg, barb, mili){
  strength = (fleg * 2) + dleg + barb + mili
  strength
}

calc_result <- function(ahits, dhits, astrength, dstrength){
  result <- ""
  if(ahits >= dstrength && dhits >= astrength) {
    result <- "Mutual elimination"
  } else if(ahits >= dstrength){
    result <- "Attack wins by elimination"
  } else if(dhits >= astrength){
    result <- "Defence wins by elimination"
  } else if(ahits > dhits){
    result <- "Attack wins"
  } else if(dhits >= ahits){
    result <- "Defence wins"
  } else {
    result <- "Unexpected result"
  }
  result
}



run_trials <- function(afleg, adleg, abarb, amili, dfleg, ddleg, dbarb, dmili, flank = FALSE, trials=10000){
  
  results <- tibble(index = 1:trials)
  attack_strength <- tot_strength(afleg,adleg,abarb,amili)
  defence_strength <- tot_strength(dfleg,ddleg,dbarb,dmili)
  
  results <- results %>% rowwise() %>%
    mutate(attack_hits = tot_hits(afleg,adleg,abarb,amili)) %>%
    mutate(defence_hits = tot_hits(dfleg,ddleg,dbarb,dmili)) %>%
    mutate(outcome = calc_result(attack_hits, defence_hits, attack_strength, defence_strength)) %>%
    ungroup()
  
  if(flank){
    losers <- results %>%
      filter(outcome == "Defence wins")
    winners <- results %>%
      filter(outcome != "Defence wins")
    losers <- losers %>%
      rowwise() %>%
      mutate(attack_hits = tot_hits(afleg,adleg,abarb,amili)) %>%
      mutate(outcome = calc_result(attack_hits, defence_hits, attack_strength, defence_strength)) %>%
      ungroup()
    results <- rbind(winners,losers)
  }
  
  results
}

results <- run_trials(3,0,3,0,3,0,0,0)

mean(results$attack_hits)
mean(results$defence_hits)

