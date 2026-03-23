function Join-NumberParts {
    param([int[]]$Parts)
    return ($Parts -join '.')
}