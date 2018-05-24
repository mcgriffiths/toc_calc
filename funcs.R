test <- function(){
  for (afleg in 0:1){
    for (adleg in 0:1){
      for (abarb in 0:1){
        for(amili in c(TRUE,FALSE)){
          for (dfleg in 0:1){
            for(ddleg in 0:1){
              for(dbarb in 0:1){
                for(dmili in c(TRUE,FALSE)){
                  for(cast in c(TRUE,FALSE)){
                    for(leader in c("none","ardshap","cniva","rival")){
                      for(flank in c(TRUE,FALSE)){
                        for(event in c('plague', 'good_aug', 'bad_aug')){
                          print(c(afleg, adleg, abarb, amili, 
                                  dfleg, ddleg, dbarb, dmili, cast,
                                  leader, flank, event))
                          run_trials(afleg, adleg, abarb, amili, 
                                        dfleg, ddleg, dbarb, dmili, cast,
                                        leader = 'None', flank = FALSE, event = FALSE, 
                                        trials=1)
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}


roll_die <- function(success, nhits=0){
  roll <- sample(1:6, size=1)
  if (roll == 6){
    nhits <- nhits + 1
    nhits <- roll_die(success, nhits)
  } else if (roll >= success) {
    nhits <- nhits + 1
  }
  nhits
}

tot_hits <- function(fleg, dleg, barb, mili, event, leader, cast){
  nhits <- 0
  base <- 0
  
  if((fleg+dleg+mili) > 0){
    if(event == "good_aug"){
      base <- -1
    } else if(event == "bad_aug"){
      base <- 1
    }
    
  }
  
  fleg_thresh <- base + 3
  dleg_thresh <- base + 5
  barb_thresh <- base + 4
  mili_thresh <- base + 5
  
  if(fleg > 0){
    for (i in 1:fleg) nhits = nhits + roll_die(fleg_thresh)
  }
  if(dleg > 0){
    for (i in 1:dleg) nhits = nhits + roll_die(dleg_thresh)
  }
  if(barb > 0){
    for (i in 1:barb) nhits = nhits + roll_die(barb_thresh)
  }
  if(mili){
    nhits = nhits + roll_die(mili_thresh)
  }
  
  if((fleg + dleg + mili) > 0){
    if(leader == 'shap'){
      nhits = nhits - 1
    }
  } else {
    if(leader == 'ard' | leader == 'shap'){
      for (i in 1:2) nhits = nhits + roll_die(4)
    }
    if(leader == 'cniva'){
      for (i in 1:2) nhits = nhits + roll_die(3)
    }
    if(leader == 'rival'){
      for (i in 1:3) nhits = nhits + roll_die(4)
    }
  }
  
  if(event == 'plague'){
    nhits = nhits + 1
  }
  if(cast){
    nhits <- nhits - 1
  }
  if(nhits < 0) nhits <-0
  
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

run_trials <- function(afleg, adleg, abarb, amili, 
                       dfleg, ddleg, dbarb, dmili, cast,
                       leader = 'None', flank = FALSE, event = FALSE, 
                       trials=10000){
  
  results <- tibble(index = 1:trials)
  attack_strength <- tot_strength(afleg,adleg,abarb,amili)
  defence_strength <- tot_strength(dfleg,ddleg,dbarb,dmili)
  if(leader != 'None') defence_strength <- defence_strength + 1
  
  results <- results %>% rowwise() %>%
    mutate(attack = tot_hits(afleg,adleg,abarb,amili,event,leader,cast)) %>%
    mutate(defence = tot_hits(dfleg,ddleg,dbarb,dmili,event,leader,FALSE)) %>%
    mutate(outcome = calc_result(attack, defence, attack_strength, defence_strength)) %>%
    ungroup()
  
  if(flank){
    losers <- results %>%
      filter(outcome == "Defence wins")
    winners <- results %>%
      filter(outcome != "Defence wins")
    if(nrow(losers) > 0){
      losers <- losers %>%
        rowwise() %>%
        mutate(attack = tot_hits(afleg,adleg,abarb,amili,event,leader,cast)) %>%
        mutate(outcome = calc_result(attack, defence, attack_strength, defence_strength)) %>%
        ungroup()
      results <- rbind(winners,losers)
    }
  }
  
  results
}


