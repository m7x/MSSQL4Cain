#!/bin/bash

show_help(){
        echo "Simple MSSQL Password Hashes Converter to Cain"
        echo -e "\nUsage:\n$0 --file input_file --output output_file [--server MSSQL_Server] [--comment comment]\n"
        }


while [[ $# != 0 ]]; do
    arg_name=$1; shift
    case "$arg_name" in
      --help|-?|-h) show_help; exit 0;;
      --file|-f) file=$1; shift;;
      --output|-o) output=$1; shift;;
      --server|-s) server=$1; shift;;
      --comment|-c) comment=$1; shift;;
      *) echo "invalid option: $1"; show_help;exit 1;;
    esac
done

if [ -z "$file" ] || [ -z "$output" ]; then
        show_help;
        exit 1;
fi

echo "Input File: "$file;
while read line
do
    full_hash=$line
    #For debugging
    #echo "Hash: "$full_hash;
    username=`echo $full_hash | cut -d ":" -f 1`
    salt_hash=`echo $full_hash | cut -d "x" -f 2`
    salt=${salt_hash:4:8}
    hash=${salt_hash:12}

    #For debugging
    #echo "Username: "$username;
    #echo "Salt: "$salt;
    #echo "Hash: "$hash;
    echo -e "$server\t$username\t\t\t$salt\t\t$hash\t$comment"
    echo -e "$server\t$username\t\t\t$salt\t\t$hash\t$comment" >> $output

done < "$file"
echo "Output File: "$output
