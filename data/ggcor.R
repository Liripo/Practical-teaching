library(ggcor)
set.seed(1)
x <- rand_dataset(7,col.names = paste0("x",1:7),obs = 100)
y <- rand_dataset(3,col.names = paste0("y",1:3),obs = 100)
corrxy <- correlate(x,y)
cor_tbl(corrxy$r,cluster = T) %>% 
  quickcor() +geom_circle2() + 
  scale_fill_gradient2n(colors =RColorBrewer::brewer.pal(11, "RdBu"))

