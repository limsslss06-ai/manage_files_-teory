# 将 Markdown 内容中的标题层级进行调整，例如将所有标题增加一个层级（# 变成 ##，## 变成 ### 等），但不修改代码块中的内容。
# 例如：
#
# 代码块：
# Convert-HeaderLevel -Content $markdownContent -BaseLevel 1

# 原文（before）：
# # Title
# ## Subtitle
# Some text
# 
# （after）：
# ## Title
# ### Subtitle  
# Some text

function Convert-MarkdownHeaderLevel {
    param(
        [string]$Content,
        [int]$BaseLevel,          # 当前层级对应的额外 # 数量（例如 1 表示文件内标题前增加一个 #）
        [string]$CodeBlockMarker = '```'
    )
    $lines = $Content -split "`r`n|`n|`r"
    $inCodeBlock = $false
    $result = @()
    foreach ($line in $lines) {
        # 检测代码块边界
        if ($line.Trim().StartsWith($CodeBlockMarker)) {
            $inCodeBlock = -not $inCodeBlock
            $result += $line
            continue
        }
        if (-not $inCodeBlock -and $line.TrimStart().StartsWith('#')) {
            # 是标题行
            $trimmed = $line.TrimStart()
            $origLevel = $line.Length - $line.IndexOf($trimmed)  # 原有 # 数量
            $newLevel = $origLevel + $BaseLevel
            $newLine = ('#' * $newLevel) + $trimmed.Substring($origLevel)
            $result += $newLine
        } else {
            $result += $line
        }
    }
    return ($result -join "`r`n")
}