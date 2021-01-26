#!/bin/bash

# Usage: see README.txt

#acquire command line variables to define path to input resources
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -b)
    fdb="$2" # path to blast db for the fragmented reference genome
    shift # past argument
    shift # past value
    ;;
    -q)
    qseq="$2" # path to fasta formatted query sequence
    shift # past argument
    shift # past value
    ;;
    -c)
    rp="$2" # path to directory containing hapx correspondence files (bwa mapped scos)
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

### MAIN ###
pd=$(pwd);

#blast query
blr=$(blastn -html -num_alignments 0 -db "$fdb" -query "$qseq");
#blr=$(blastn -html -num_alignments 0 -db 1kb_Bvulgaris_548_EL10_1.0.fa -query /home/pat.reeves/patellifolia/seq/ORF803genomic.fa); # -out 2.txt;
#blr=$(blastn -html -num_alignments 0 -db 1kb_Bvulgaris_548_EL10_1.0.fa -query <(echo "AAATTTCCCGGG")); # -out 4.txt; #this finds nothing

#print query sequence name
echo "$blr" | grep '<b>Query=</b> ' | sed 's:<b>::' | sed 's:</b>::';

#process blastn results
if grep -q "No hits found" <(echo "$blr");
then echo $'\n'"Query does not match reference genome. Quitting..."$'\n';

else od=$(TMPDIR=$(pwd); mktemp -d -t 'vb.XXXXXX'); #make a directory to receive files found in flashed read archive
  a=$(echo "$blr" | grep " <a href=" | awk -F' ' '{print $1}'); #get a list of reference genome 1kb regions that are hits to the query sequence (assumes -html produces no extraneous " <a href=" tags
  blk="$blr"; #transfer blast output to a variable that can be marked when reads are present in hapx archive
  for i in $a; 
    do c=$(echo "$i" | cut -d_ -f2); #name of contig or chromosome containing hit fragment
      b=$(find "$rp" -name "$i*.global.fa" -exec sh -c 'cp {} '"$od"'; echo {}' \;); #cp reads to $od, and echo to stdout to capture as $b
      d=$(find "$rp" -name "$i*_aligned_haps.bam*" -exec sh -c 'cp {} '"$od"'; echo {}' \;); #cp bam and bai file to $od
      
      #modify blast output to mark fragments with reads in the hapx archive
      if [[ "$b" == "" ]];
      then echo "$i X"; #there are no reads in hapx archive for this reference fragment
        blk=$(echo "$blk" | sed "s/^$i /X $i /");
      else echo "$i *"; # reads are present in the hapx archive for this reference fragment
        blk=$(echo "$blk" | sed "s/^$i /* $i /");
      fi;
    done;
  echo "(*) sequences found, (X) not found";
  echo "Sequences, alignments: $od";
  
  #save modified blast results to file
  bo=$(echo "$od" | rev | cut -d'/' -f1 | rev)".txt"; #name of output file from name of output directory
  echo "$blk" > "$od"/"$bo";
  
  echo "vb BLAST result: $od/$bo";
  echo;
fi; 
### END MAIN ###






