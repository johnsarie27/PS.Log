# Write-LogInfo

## SYNOPSIS
Write INFO to log

## SYNTAX

```
Write-LogInfo [-Path] <String> [-Message] <String[]> [[-Id] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Write INFO to log

## EXAMPLES

### EXAMPLE 1
```
Write-LogInfo -Path C:\temp\log.log -Message 'Log file updated'
Adds the information-level log entry 'Log file updated'
```

## PARAMETERS

### -Path
Path to log file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
Log message

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
Unique ID for log entry or set of entries (e.g., process id, etc.)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
## OUTPUTS

### None.
## NOTES
General notes

## RELATED LINKS
