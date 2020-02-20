args=commandArgs(TRUE);
infile=args[1];
outfile=args[2];
dt=read.table(infile, header=TRUE);
png(outfile);
hist(dt[[1]]);
dev.off();


# cia yra pavyzdinis skriptas kuris skirtas sukurti paveiksleliui, ji paleisti galima
# R --vanilla --args rezultatai/koef_wt_kartu_su_wtx_pirmi_229_baltymu_be_TRP-TRP.txt ./testas.png < failas.R
#suvedus sita koda i terminal rezultatas gaunasi histograma is duoto inputo
