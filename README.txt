vb (variant blast) interrogates hapx correspondence archives for orthologous sequence variation

Resources:
1) A blast database for a fragmented reference genome
2) A query sequence in fasta format
3) A set of correspondence files generated using hapx

Requirements (in path):
1) blastn (part of BLAST+ package)

Usage: ./vb.sh -b blastdb -q queryseq -c corresp
where,
blastdb = path to blast db for the fragmented reference genome
queryseq = path to fasta formatted query sequence
corresp = path to directory containing hapx correspondence files

Notes:

Examples: 
module load blast+/2.9.0;
./vb.sh -b /home/pat.reeves/patellifolia/EL10BlastDBs/1kb_Bvulgaris_548_EL10_1.0.fa \
        -q /home/pat.reeves/patellifolia/seq/ORF803genomic.fa \
        -c /home/pat.reeves/patellifolia/hapxCorrespondenceFiles/EL10XPatellifolia535455scos;
                  
                  
                  
                  

