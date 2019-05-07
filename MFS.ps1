$dir = Read-Host "Enter files directory"
Write-Host "`n"
Write-Host "Enter a filter e.g '*.txt' to search all text files in the directory or 'filename.log' for just the one file"
Write-Host "`n"
$filter = Read-Host "Filter"

$all_files = [IO.Directory]::EnumerateFiles($dir, $filter)

$term = Read-Host "Enter search term(not case sensitive)"
[int32]$offset_min = Read-Host "How many lines before the found line should be printed?"
[int32]$offset_max = Read-Host "How many lines after the found line should be printed?"
$i = 0
Clear-Host
$cont_loop = "true";
while($cont_loop -eq "true"){

    Foreach($file in $all_files){

        $i = 0
        Write-Host "Starting file: " -NoNewline
        Write-Host $file -ForegroundColor Magenta
        write-host "──────────────────────────" -Foregroundcolor Green
        $file_lines = [IO.File]::ReadAllLines($file)

        foreach($line in $file_lines){

            if(($line.ToUpper() -eq $term.ToUpper()) -or ($line.ToUpper().Contains($term.ToUpper()))){
            
                $k = $i - $offset_min
                $l = 0;
                if($k -lt 0){
                    $l += 2 * -$k - 1
                    $k = 0
                }
                For($j = 0; $j -lt ($offset_max + $offset_min + 1 - $l); $j++){
                    
                    if($k -eq $i){

                        try{
                            $pre_ln = $file_lines[$k].Remove($file_lines[$k].ToUpper().Indexof($term.ToUpper()))
                        }catch [System.ArgumentOutOfRangeException]{
                            $pre_ln = ""
                        }
                        
                        try{
                            $post_ln = $file_lines[$k].Remove(0, $pre_ln.Length + $term.Length)
                        }catch [System.ArgumentOutOfRangeException]{
                            $post_ln = ""
                        }
                        $term_ln = $file_lines[$k]
                        if($pre_ln.Length -gt 0){

                            $term_ln = $file_lines[$k].Remove(0, $pre_ln.Length)

                        }
                        if($term_ln.Length -gt $term.Length){

                            $term_ln = $term_ln.Remove($term.Length)

                        }
                        
                        #Write-Host "Debug: line k = " $file_lines[$K] -BackgroundColor Black -ForegroundColor DarkYellow
                        #Write-Host "Debug: pre_ln = " $pre_ln -BackgroundColor Black -ForegroundColor DarkYellow
                        #Write-Host "Debug: term_ln = " $term_ln -BackgroundColor Black -ForegroundColor DarkYellow
                        #Write-Host "Debug: post_ln = " $post_ln -BackgroundColor Black -ForegroundColor DarkYellow

                        Write-Host $pre_ln -NoNewline -ForegroundColor Cyan
                        Write-Host $term_ln -NoNewline -ForegroundColor Cyan -BackgroundColor DarkGray
                        Write-Host $post_ln -ForegroundColor Cyan

                    }else{

                        Write-Host $file_lines[$k] -ForegroundColor Cyan

                    }
                    
                    $k++
                }
                write-host "──────────────────────────" -Foregroundcolor Green
            } 
            $i++
        }

    }

    Write-Host "End of search" -ForegroundColor Magenta
    Write-Host "`n"
    $loopyn = Read-Host "Search again with new term? (y/n)"
    if($loopyn.ToUpper() -eq "Y"){

        $term = Read-Host "Enter a new search term"
        $offset_min = Read-Host "How many lines before the found line should be printed?"
        $offset_max = Read-Host "How many lines after the found line should be printed?"

    } else { $cont_loop = "false" }

}
