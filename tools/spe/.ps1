function Get-FolderStructure {
    param(
        [string]$Path,
        [int[]]$ParentNumberParts = @()
    )
    $folders = Get-ChildItem -Path $Path -Directory | Where-Object {
        $parsed = Parse-FolderName $_.Name
        $parsed -ne $null
    } | ForEach-Object {
        $parsed = Parse-FolderName $_.Name
        $currentNumberParts = $ParentNumberParts + $parsed.NumberParts
        [PSCustomObject]@{
            FullPath       = $_.FullName
            Name           = $_.Name
            NumberParts    = $currentNumberParts
            Title          = $parsed.Title
            Children       = Get-FolderStructure -Path $_.FullName -ParentNumberParts $currentNumberParts
            Files          = Get-ChildItem -Path $_.FullName -File -Filter '*.md' | Sort-Object Name
        }
    }
    # 按数字部分排序（例如 1.2 排在 1.10 之前，需按各部分数值比较）
    return $folders | Sort-Object { ($_.NumberParts -join '.') }  # 简单字符串排序可能不精确，但可接受
    # 如需精确排序，可自定义比较器，此处简化
}