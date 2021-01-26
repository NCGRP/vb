#starting 1/22/2021
#development of vbquery.sh, a program to query flashed read archives for reads matching
#a query from the focal crop genome using blastn

#vb.sh (variant blast)
#returns sequences and bam alignments between a reference genome and target genome

#requirements:
#1. a blastdb formatted fragmented reference genome (EL10)
#2. alignments from hapx processing a flashed read archive (Patellifolia) against a reference genome (EL10)
#3. a query sequence



#make blastdbs for fasta files of EL10 fragmented chromosomes, takes about 12 seconds total
screen;
sscavenger;
module load blast+/2.9.0;
cd /home/pat.reeves/patellifolia/EL10BlastDBs;
pd=$(pwd);
cat Chr[1-9]_Bvulgaris_548_EL10_1.0.fa > 1kb_Bvulgaris_548_EL10_1.0.fa; #make a single file containing all chromosomes' 1kb fragments
makeblastdb -in "$pd"/1kb_Bvulgaris_548_EL10_1.0.fa -parse_seqids -dbtype nucl;

#try some test queries, use html format to facilitate extracting the hits
blr=$(blastn -html -num_alignments 0 -db 1kb_Bvulgaris_548_EL10_1.0.fa -query /home/pat.reeves/patellifolia/seq/Hs1pro-1.fa); # -out 1.txt;
blr=$(blastn -html -num_alignments 0 -db 1kb_Bvulgaris_548_EL10_1.0.fa -query /home/pat.reeves/patellifolia/seq/ORF803genomic.fa); # -out 2.txt;
blr=$(blastn -html -num_alignments 0 -db 1kb_Bvulgaris_548_EL10_1.0.fa -query /home/pat.reeves/patellifolia/seq/ORF803mRNA.fa); # -out 3.txt;
blr=$(blastn -html -num_alignments 0 -db 1kb_Bvulgaris_548_EL10_1.0.fa -query <(echo "AAATTTCCCGGG")); # -out 4.txt; #this finds nothing


rp="/home/pat.reeves/patellifolia/OrthoVariant/blastnresultsflashedreads"; #root path to directory containing hapx processed flashed reads (bwa mapped scos)
pd=$(pwd);
if grep -q "No hits found" <(echo "$blr");
then echo $'\n'"Query does not match reference genome. Quitting..."$'\n';

else od=$(TMPDIR=$(pwd); mktemp -d -t 'vb.XXXXXX'); #make a directory to receive files found in flashed read archive
  a=$(echo "$blr" | grep " <a href=" | awk -F' ' '{print $1}'); #get a list of reference genome 1kb regions that are hits to the query sequence (assumes -html produces no extraneous " <a href=" tags
  blk="$blr"; #transfer blast output to a variable that can be marked when reads are present in hapx archive
  for i in $a; 
    do c=$(echo "$i" | cut -d_ -f2); #name of contig or chromosome containing hit fragment
      b=$(find "$rp"/"$c"hapxscossummary/"$c"scos535455Finalhapx/alignments -name "$i*.global.fa" -exec sh -c 'cp {} '"$od"'; echo {}' \;); #cp reads to $od, and echo to stdout to capture as $b
      d=$(find "$rp"/"$c"hapxscossummary/"$c"scos535455Finalhapx/alignments -name "$i*_aligned_haps.bam*" -exec sh -c 'cp {} '"$od"'; echo {}' \;); #cp bam and bai file to $od
      
      #modify blast output to mark fragments with reads in the hapx archive
      if [[ "$b" == "" ]];
      then echo "$i X"; #there are no reads in hapx archive for this reference fragment
        blk=$(echo "$blk" | sed "s/^$i /X $i /");
      else echo "$i *"; # reads are present in the hapx archive for this reference fragment
        blk=$(echo "$blk" | sed "s/^$i /* $i /");
      fi;
    done;
  echo;
  echo "(*) sequences found, (X) not found"
  
  #save blast results to file
  bo=$(echo "$od" | rev | cut -d'/' -f1 | rev)".txt"; #name of output file from name of output directory
  echo "$blk" > "$od"/"$bo";
  
  echo "Blast results saved as $od/$bo";
  echo;
fi; 



