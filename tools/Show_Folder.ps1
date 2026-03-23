function Show-FolderTree {
    param(
        [string]$Path,
        [int]$Indent = 0
    )

    # 获取当前目录的文件夹
    $folders = Get-ChildItem -Path $Path -Directory | Sort-Object Name
    $files   = Get-ChildItem -Path $Path -File | Sort-Object Name

    $prefix = ' ' * $Indent

    # 打印文件夹
    foreach ($folder in $folders) {
        Write-Output "$prefix[Folder] $($folder.Name)"
        # 递归子文件夹
        Show-FolderTree -Path $folder.FullName -Indent ($Indent + 2)
    }

    # 打印文件
    foreach ($file in $files) {
        Write-Output "$prefix[File] $($file.FullName)"
    }
}
