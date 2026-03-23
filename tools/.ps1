function Get-FolderDetails {
    <#
    .SYNOPSIS
    递归获取指定路径下的文件夹结构，并生成结构化对象。
    
    .DESCRIPTION
    - 可自定义文件类型过滤、递归深度。
    - 返回对象包含：FullPath, Name, NumberParts, Title, Children, Files。
    
    .PARAMETER Path
    要扫描的根目录路径。
    
    .PARAMETER FileFilter
    文件类型过滤字符串，如 '*.md'，支持通配符。
    
    .PARAMETER IncludeUnnumbered
    是否包含不符合编号格式的文件夹，默认 false。
    
    .PARAMETER MaxDepth
    最大递归深度，0 表示无限递归。
    
    .EXAMPLE
    $tree = Get-NumberedFolderTree -Path "C:\Docs" -FileFilter '*.md'
    $tree | Format-Table Name,NumberParts,Title
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [int[]]$ParentNumberParts = @(),

        [string]$FileFilter = '*',

        [bool]$IncludeUnnumbered = $false,

        [int]$MaxDepth = 0
    )

    # 内部递归函数计数当前深度
    param(
        [int]$CurrentDepth = 1
    )

    # 获取当前目录下的文件夹
    $folders = Get-ChildItem -Path $Path -Directory | ForEach-Object {

        $parsed = Parse-FolderName $_.Name

        if ($parsed -eq $null) {
            if (-not $IncludeUnnumbered) {
                return
            }
            # 对于不符合编号格式的文件夹，生成默认 NumberParts 空数组，Title = Name
            $parsed = [PSCustomObject]@{
                NumberParts = @()
                Title       = $_.Name
            }
        }

        # 拼接父级编号 + 当前编号
        $currentNumberParts = $ParentNumberParts + $parsed.NumberParts

        # 递归子文件夹（如果未达到最大深度）
        $children = @()
        if ($MaxDepth -eq 0 -or $CurrentDepth -lt $MaxDepth) {
            $children = Get-FolderDetails -Path $_.FullName `
                                              -ParentNumberParts $currentNumberParts `
                                              -FileFilter $FileFilter `
                                              -IncludeUnnumbered $IncludeUnnumbered `
                                              -MaxDepth $MaxDepth `
                                              -CurrentDepth ($CurrentDepth + 1)
        }

        # 获取当前文件夹下的文件
        $files = Get-ChildItem -Path $_.FullName -File -Filter $FileFilter | Sort-Object Name

        # 返回对象
        [PSCustomObject]@{
            FullPath    = $_.FullName           # 当前文件夹的完整路径
            Name        = $_.Name               # 当前文件夹的名称
            NumberParts = $currentNumberParts   # 当前文件夹的完整编号数组
            Title       = $parsed.Title
            Children    = $children             # 子文件夹列表
            Files       = $files        # 可以根据需要添加更多属性，如文件数量、子文件夹数量等
        }
    }

    # 按数字部分排序，字符串排序可能不完全精确
    # 可以按数组自定义比较器增强
    return $folders | Sort-Object { ($_.NumberParts -join '.') }
}
