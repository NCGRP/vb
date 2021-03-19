vb (variant blast)
vb -hca interrogates hapx correspondence archives for orthologous sequence variation
vb -fra interrogates flashed read archives for homologous sequence variation

Requirements (in path):
1) blastn (part of BLAST+ package)
2) sgrep

vb -hca
Resources:
1) A blast database for a fragmented reference genome
2) A query sequence in fasta format
3) A set of correspondence files generated using hapx

Usage: ./vb.sh -hca -b blastdb -q queryseq -c corresp [-o outfol]
where,
blastdb = path to blast db for the fragmented reference genome
queryseq = path to fasta formatted query sequence
corresp = path to directory containing hapx correspondence files
outfol = path to output folder

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

Usage: ./vb.sh -fra -b blastdb -q queryseq -c fasta [-o outfol]
where,
blastdb = path to blast db from the flashed read archive
queryseq = path to fasta formatted query sequence
fasta = path to sorted fasta file from the flashed read archive
outfol = path to output folder

Notes:

Examples: 
module load blast+/2.9.0;

./vb.sh -fra -b /home/pat.reeves/patellifolia/flashedreadarchive/53blastdb/53fra.fa \
             -q /home/pat.reeves/patellifolia/seq/ORF803genomic.fa \
             -c /home/pat.reeves/patellifolia/flashedreadarchive/53fraFinal/53frasorted.fa \
             -o /home/pat.reeves/vb/vbo.53xORF803;
                  
for i in 53 54 55;
  do ./vb.sh -fra -b /home/pat.reeves/patellifolia/flashedreadarchive/"$i"blastdb/"$i"fra.fa \
                  -q /home/pat.reeves/patellifolia/seq/BvFl1genomic.fa \
                  -c /home/pat.reeves/patellifolia/flashedreadarchive/"$i"fraFinal/"$i"frasorted.fa;
                  -o /home/pat.reeves/vb/vbo."$i"xBvFl1genomic;
  done;
  
time seq 53 1 55 | parallel './vb.sh -fra -b /home/pat.reeves/patellifolia/flashedreadarchive/{}blastdb/{}fra.fa \
                  -q /home/pat.reeves/patellifolia/seq/BvFl1genomic.fa \
                  -c /home/pat.reeves/patellifolia/flashedreadarchive/{}fraFinal/{}frasorted.fa \
                  -o /home/pat.reeves/vb/vbfrao.{}xBvFl1genomic;'
                  
                  
                  
./vb.sh -fra -b /home/pat.reeves/patellifolia/flashedreadarchive/53blastdb/53fra.fa \
             -q /home/pat.reeves/patellifolia/seq/BvFl1mRNAspl4.fa \
             -c /home/pat.reeves/patellifolia/flashedreadarchive/53fraFinal/53frasorted.fa;
                 
./vb.sh -fra -b /home/pat.reeves/patellifolia/flashedreadarchive/53blastdb/53fra.fa \
             -q /home/pat.reeves/patellifolia/seq/luciferase.fa \
             -c /home/pat.reeves/patellifolia/flashedreadarchive/53fraFinal/53frasorted.fa;
                 
                  

