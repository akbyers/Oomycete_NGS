#!/bin/bash -e

#SBATCH --account       lincoln03750
#SBATCH --job-name      blastn
#SBATCH --time          2-00:00:00
#SBATCH --mem           50GB
#SBATCH --cpus-per-task 12
#SBATCH --error         %x_%A_%a.err
#SBATCH --output        %x_%A_%a.out

# Working directory
cd /home/byersa/00_nesi_projects/lincoln03750/oomycete_AGRF/
#mkdir BLASTN

module purge
module load BLAST/2.16.0-GCC-12.3.0
module load BLASTDB/2025-01 

# 1. Run BLAST with headers
blastn -query otus_97_clean.fasta \
       -db nt \
       -remote \
       -max_target_seqs 50 \
       -evalue 1e-5 \
       -out BLASTN/blast_results.tsv \
       -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen qcovs staxids stitle"

#Add headers to file 
#(echo -e "qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tqlen\tslen\tqcovs\tstaxids\tstitle"; \
 #cat blast_results.tsv) > blast_results_with_header.tsv

# 2. Extract taxids and annotate with lineage using taxonkit
#cut -f16 BLASTN/blast_results_with_header.tsv | taxonkit lineage | taxonkit reformat -f "{k};{p};{c};{o};{f};{g};{s}" > BLASTN/lineage.txt

# 3. Add lineage back into BLAST results
#paste BLASTN/blast_results_with_header.tsv BLASTN/lineage.txt > BLASTN/blast_taxonomy.tsv

# 4. Keep only Oomycetes
#grep "Oomycota" BLASTN/blast_taxonomy.tsv > BLASTN/blast_oomycetes.tsv 

# 5. Keep only ITS1-related hits
#grep -i -E "ITS1|ITS 1|internal transcribed spacer 1|internal transcribed spacer region 1" BLASTN/blast_oomycetes.tsv > BLASTN/blast_oomycetes_ITS1.tsv 
#(echo -e "qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tqlen\tslen\tqcovs\tstaxids\tstitle\ttaxid\tlineage\tlineage"; \
 #cat BLASTN/blast_oomycetes_ITS1.tsv) > BLASTN/blast_oomycetes_ITS1_with_header.tsv

#Retain only oomycetes and ITS1-related hits in the fasta file
#cut -f1 BLASTN/blast_oomycetes_ITS1.tsv | sort -u > BLASTN/oomycete_ids.txt 

#module load SeqKit/2.4.0
#seqkit grep -f BLASTN/oomycete_ids.txt BLASTN/otus_97_clean.fasta > BLASTN/otus_97_oomycetes_ITS1.fasta ##843 OTUs remain from original pool of 903