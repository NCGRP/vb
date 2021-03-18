vb (variant blast)
vb -hca interrogates hapx correspondence archives for orthologous sequence variation
vb -fra interrogates flashed read archives for homologous sequence variation

vb -hca
Resources:
1) A blast database for a fragmented reference genome
2) A query sequence in fasta format
3) A set of correspondence files generated using hapx

Requirements (in path):
1) blastn (part of BLAST+ package)

Usage: ./vb.sh -hca -b blastdb -q queryseq -c corresp
where,
blastdb = path to blast db for the fragmented reference genome
queryseq = path to fasta formatted query sequence
corresp = path to directory containing hapx correspondence files

Notes:

Examples: 
module load blast+/2.9.0;

./vb.sh -hca -b /home/pat.reeves/patellifolia/EL10BlastDBs/1kb_Bvulgaris_548_EL10_1.0.fa \
             -q /home/pat.reeves/patellifolia/seq/ORF803genomic.fa \
             -c /home/pat.reeves/patellifolia/hapxCorrespondenceFiles/EL10XPatellifolia535455scos;
                  
./vb.sh -hca -b /home/pat.reeves/patellifolia/EL10BlastDBs/1kb_Bvulgaris_548_EL10_1.0.fa \
             -q /home/pat.reeves/patellifolia/seq/BvFl1genomic.fa \
             -c /home/pat.reeves/patellifolia/hapxCorrespondenceFiles/EL10XPatellifolia535455scos;
                  
./vb.sh -hca -b /home/pat.reeves/patellifolia/EL10BlastDBs/1kb_Bvulgaris_548_EL10_1.0.fa \
             -q /home/pat.reeves/patellifolia/seq/BvFl1mRNAspl4.fa \
             -c /home/pat.reeves/patellifolia/hapxCorrespondenceFiles/EL10XPatellifolia535455scos;
                 
./vb.sh -hca -b /home/pat.reeves/patellifolia/EL10BlastDBs/1kb_Bvulgaris_548_EL10_1.0.fa \
             -q /home/pat.reeves/patellifolia/seq/luciferase.fa \
             -c /home/pat.reeves/patellifolia/hapxCorrespondenceFiles/EL10XPatellifolia535455scos;
                 


vb -fra
Resources:
1) The blast database from a flashed read archive
2) A query sequence in fasta format
3) The fasta file from a flashed read archive

Requirements (in path):
1) blastn (part of BLAST+ package)

Usage: ./vb.sh -fra -b blastdb -q queryseq -c fasta
where,
blastdb = path to blast db from the flashed read archive
queryseq = path to fasta formatted query sequence
fasta = path to fasta file from the flashed read archive

Notes:

Examples: 
module load blast+/2.9.0;

./vb.sh -fra -b /home/pat.reeves/patellifolia/flashedreadarchive/53blastdb/53fra.fa \
             -q /home/pat.reeves/patellifolia/seq/ORF803genomic.fa \
             -c /home/pat.reeves/patellifolia/flashedreadarchive/53fraFinal/53fra.fa;
                  
./vb.sh -b /home/pat.reeves/patellifolia/EL10BlastDBs/1kb_Bvulgaris_548_EL10_1.0.fa \
        -q /home/pat.reeves/patellifolia/seq/BvFl1genomic.fa \
        -c /home/pat.reeves/patellifolia/hapxCorrespondenceFiles/EL10XPatellifolia535455scos;
                  
./vb.sh -b /home/pat.reeves/patellifolia/EL10BlastDBs/1kb_Bvulgaris_548_EL10_1.0.fa \
        -q /home/pat.reeves/patellifolia/seq/BvFl1mRNAspl4.fa \
        -c /home/pat.reeves/patellifolia/hapxCorrespondenceFiles/EL10XPatellifolia535455scos;
                 
./vb.sh -b /home/pat.reeves/patellifolia/EL10BlastDBs/1kb_Bvulgaris_548_EL10_1.0.fa \
        -q /home/pat.reeves/patellifolia/seq/luciferase.fa \
        -c /home/pat.reeves/patellifolia/hapxCorrespondenceFiles/EL10XPatellifolia535455scos;
                 
                  

