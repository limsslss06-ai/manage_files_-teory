# 匹配字符串中的第一个整数数字，例如：
# Get-FirstIntegerNumber "The price is 100 dollars."  # 输出: 100


function Get-FirstIntegerNumber {
    param([string]$Text)

    if ($Text -match '\d+') {
        return [int]$matches[0]
    }

    return $null
}


