# 匹配字符串中的第一个版本号，例如：
# Get-FirstVersionNumber "The latest version is 1.2.3."

function Get-FirstVersionNumber {
    param([string]$Text)

    if ($Text -match '\d+(?:\.\d+)*') {
        return $matches[0]
    }

    return $null
}
