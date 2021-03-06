options(repos = c(CRAN = "https://cran.rstudio.com"))
update.packages(ask=F)
source("https://bioconductor.org/biocLite.R")
biocLite(ask=F)

install.packages("rjson")
packages.to.install <- 
c("Bioconductor/BiocGenerics","Bioconductor/S4Vectors","Bioconductor/IRanges","grimbough/Rhdf5lib","sneumann/mzR","limma","isobar", "lgatto/MSnbase","plotly","reshape","qvalue")

for (package in packages.to.install) {
    biocLite(package)
}

