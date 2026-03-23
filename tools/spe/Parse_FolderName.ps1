function Parse-FolderName {
    param([string]$FolderName)
    # 匹配格式：数字（可带点） + 空格 + 标题
    if ($FolderName -match '^(\d+(?:\.\d+)*)\s+(.*)') {
        $numStr = $matches[1]
        $title = $matches[2]
        $parts = $numStr -split '\.' | ForEach-Object { [int]$_ }
        return [PSCustomObject]@{
            NumberParts = $parts
            Title       = $title
        }
    }
    Write-Warning "文件夹名不符合规范: $FolderName"
    return $null
}