#!/bin/bash

# Usage: see README.txt

#establish default values
mode="";

#acquire command line variables to define path to input resources
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -hca)
    mode="hca";
    shift # past argument
    ;;
    -fra)
    mode="fra";
    shift # past argument
    ;;
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
    rp="$2" # path to directory containing hapx correspondence files (bwa mapped scos) (vb -hca)
            # or path to fasta file containing reads (vb -fra)
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

#verify user settings
if [[ "$mode" == "" ]]; 
then echo $'\n'"No mode selected. Choose -hca or -fra."$'\n';
  exit 1;
fi;

#blast query
blr=$(blastn -html -num_alignments 0 -db "$fdb" -query "$qseq");
#blr=$(blastn -html -num_alignments 0 -db 1kb_Bvulgaris_548_EL10_1.0.fa -query /home/pat.reeves/patellifolia/seq/ORF803genomic.fa); # -out 2.txt;
#blr=$(blastn -html -num_alignments 0 -db 1kb_Bvulgaris_548_EL10_1.0.fa -query <(echo "AAATTTCCCGGG")); # -out 4.txt; #this finds nothing

#print query sequence name
echo "$blr" | grep '<b>Query=</b> ' | sed 's:<b>::' | sed 's:</b>::';

#process blastn results
if grep -q "No hits found" <(echo "$blr");
then echo $'\n'"Query does not match reference genome. Quitting..."$'\n';
  exit 1;
else od=$(TMPDIR=$(pwd); mktemp -d -t 'vb'"$mode"'o.XXXXXX'); #make a directory to receive files found in archive
  a=$(echo "$blr" | grep " <a href=" | awk -F' ' '{print $1}'); #get a list of db regions that are hits to the query sequence (assumes -html produces no extraneous " <a href=" tags
  blk="$blr"; #transfer blast output to a variable that can be marked when reads are present in archive


  ### hca mode ###
  if [[ "$mode" == "hca" ]];
  then
    for i in $a; 
      do b=$(find "$rp" -name "$i*.global.fa" -exec sh -c 'cp {} '"$od"'; echo {}' \;); #cp reads to $od, and echo to stdout to capture as $b
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
  

  ### fra mode ###
  elif [[ "$mode" == "fra" ]];
  then
    fao=$(echo "$od" | rev | cut -d'/' -f1 | rev)".fa"; #name of output file from name of output directory
    (echo "$a" | head | parallel --bar 'grep -A1 ^\>{}$ '"$rp") > "$od"/"$fao";
  fi;
  
  #save modified blast results to file
  bo=$(echo "$od" | rev | cut -d'/' -f1 | rev)".txt"; #name of output file from name of output directory
  echo "$blk" > "$od"/"$bo";

  #parting words
  echo "vb BLAST result: $od/$bo";
  echo;
fi; 
### END MAIN ###






