for (( ;; )); do
    read -u 4 A || {
        <read error/eof; perhaps you can send a message here and/or break the loop with break>
    }
    read -u 5 B || {
        <do something similar>
    }
    <do something with $A and $B>
done 4< file1.txt 5< file2.txt