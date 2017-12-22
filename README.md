# PUF-State-Distribution

The goal of this project is to create a public-use file (PUF) with income-tax microdata that represents not just the U.S. as a whole, but each of the 50 states. The initial goal is to construct a file that is consistent with known or estimated values for each state, for many variables, for a recent historical year.

We anticipate starting with a national PUF for a recent year that has NO state codes on it, and using it as the basis for each state. (My/our understanding of the latest PUFs are that they do not have any state codes on them.) 

Thus, if the national file has 150k records, then each state might, initially, have 150k records, but with different, adjusted, weights. Our goal is to develop a rational method for adjusting weights to hit the targets for a given state. If some of the weights end up to be zero for a given state, the records could be dropped.

See https://github.com/open-source-economics/taxdata/issues/138 for an initial discussion.

We are open to exploring other approaches, too.
