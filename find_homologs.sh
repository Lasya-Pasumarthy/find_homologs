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

# Filter hits with >30% identity and >90% match length
awk -v min_identity=30 -v min_match_length=0.90 '{
    if ($3 > min_identity && $4 > min_match_length * $5) {
        print
    }
}' temp_blast_output.txt > "$output_file"

# Count the number of filtered matches
match_count=$(wc -l < "$output_file")

# Print the number of matches to stdout
echo "Number of matches identified: $match_count"
