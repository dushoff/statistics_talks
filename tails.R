library(shellpipes); manageConflicts()

library(readr)
library(tibble)

set.seed(2121)

params_tbl <- read_csv(I("
	species, sex, Ml, Sdl
	Elephant, male, 4.860, 0.120
	Elephant, female, 4.780, 0.120
	Mouse, male, 2.120, 0.198
	Mouse, female, 1.995, 0.198
" ), show_col_types = FALSE)

tail_lengths <- function(params_tbl, n) {
    # recycle n if needed
    if (length(n) == 1L) n <- rep(n, nrow(params_tbl))

    out <- lapply(seq_len(nrow(params_tbl)), function(i) {
        tibble(
            species=params_tbl$species[i]
            , sex=params_tbl$sex[i]
				, id=i
            , tailLength=rlnorm(
                n[i]
                , meanlog=params_tbl$Ml[i]
                , sdlog=params_tbl$Sdl[i]
            )
        )
    })

    do.call(rbind, out) |> tibble::as_tibble()
}
tails <- tail_lengths(params_tbl, n=20)

summary(tails)
print(tails, n=Inf)
rdsSave(tails)
