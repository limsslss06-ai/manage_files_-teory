
function Get-Items {
    param(
        [string]$StartPath = ".",
        [string]$RootPath = $StartPath,  # the root path for relative path calculation
        [int]$CurrentDepth = 0,        # current depth, used for recursion
        [int]$MaxDepth = [int]::MaxValue    # the explore depth, default to unlimited
    )

    Write-Host "Scanning: $StartPath"

    # 只在第一层规范化 RootPath
    if ($CurrentDepth -eq 0) {
        $RootPath = (Resolve-Path $RootPath).Path.TrimEnd('\')
    }

    $items = Get-ChildItem -Path $StartPath -Force -ErrorAction SilentlyContinue

    foreach ($item in $items) {

        # 使用固定 RootPath 计算相对路径
        $relativePath = $item.FullName.Substring($RootPath.Length).TrimStart('\')

        # 创建自定义对象
        $obj = [PSCustomObject]@{
            Item         = $item
            Depth        = $CurrentDepth
            RelativePath = $relativePath    # 以 RootPath 为基准的相对路径
            Children     = @()  # 可递归填充
        }

        # 如果是文件夹且未超最大深度，则递归
        if ($item.PSIsContainer -and $CurrentDepth -lt $MaxDepth) {
            $children = @(Get-Items `
                    -StartPath $item.FullName `
                    -RootPath $RootPath `
                    -CurrentDepth ($CurrentDepth + 1) `
                    -MaxDepth $MaxDepth)

            $obj.Children = $children
        }

        $obj
    }

}
