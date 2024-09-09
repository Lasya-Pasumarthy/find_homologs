#!/bin/bash
	
# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <query file> <subject file> <output file>"
    exit 1
fi

# Assign arguments to variables
query_file="$1"
subject_file="$2"
output_file="$3"

# Run BLAST search with the specified query and subject files
# The output format includes query ID (qseqid), subject ID (sseqid), percent identity (pident),
# alignment length (length), and lengths of the query (qlen) and subject (slen)
blastn -query "$query_file" -subject "$subject_file" -outfmt "6 qseqid sseqid pident length qlen slen" -out temp_blast_output.txt

# Filter perfect matches: 100% identity and alignment length equals query length
awk '$3 == 100 && $4 == $5' temp_blast_output.txt > "$output_file"

# Count the number of perfect matches
perfect_match_count=$(wc -l < "$output_file")

# Print the number of perfect matches to stdout
echo "Number of perfect matches: $perfect_match_count"
