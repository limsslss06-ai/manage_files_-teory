. .\tools\Get_FirstIntegerNumber.ps1
. .\tools\.ps1
. .\tools\Show_Folder.ps1
. .\tools\Get_Items.ps1

function Show-Tree {
    param([array]$Nodes, [string]$Prefix = "")

    foreach ($node in $Nodes) {
        $symbol = if ($node.Item.PSIsContainer) { "[Folder]" } else { "[File]" }
        Write-Output "$Prefix$symbol $($node.RelativePath) (Depth=$($node.Depth))"

        if ($node.Children.Count -gt 0) {
            Show-Tree -Nodes $node.Children -Prefix ("  " + $Prefix)
        }
    }
}

# 使用
$tree = Get-Items -StartPath ".\src\chs"
Show-Tree -Nodes $tree
