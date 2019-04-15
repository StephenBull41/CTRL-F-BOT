$dir = Read-Host "Enter files directory"
Write-Host "`n"
Write-Host "Enter a filter e.g '*.txt' to search all text files in the directory or 'filename.log' for just the one file"
Write-Host "`n"
$filter = Read-Host "Filter"

$all_files = [IO.Directory]::EnumerateFiles($dir, $filter)

$term = Read-Host "Enter search term(case sensitive)"
[int32]$offset_min = Read-Host "How many lines before the found line should be printed?"
[int32]$offset_max = Read-Host "How many lines after the found line should be printed?"
$i = 0
Clear-Host

Foreach($file in $all_files){

    $i = 0
    Write-Host "Starting file: " -NoNewline
    Write-Host $file -ForegroundColor Magenta
    write-host "──────────────────────────" -Foregroundcolor Green
    $file_lines = [IO.File]::ReadAllLines($file)

    foreach($line in $file_lines){

        if(($line -eq $term) -or ($line.Contains($term))){
            
            $k = $i - $offset_min
            For($j = 0; $j -lt ($offset_max + $offset_min + 1); $j++){
            
                Write-Host $file_lines[$k] -ForegroundColor Cyan
                $k++
            }
            write-host "──────────────────────────" -Foregroundcolor Green
        } 
        $i++
    }

}

Write-Host "End of search" -ForegroundColor Magenta
read-host
