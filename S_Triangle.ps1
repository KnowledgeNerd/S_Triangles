# $BaseTriangle = [string[]]@()
# $BaseTriangle += "  ┏━┓ " 
# $BaseTriangle += "┏━┛ ┗━┓"
# $BaseTriangle += "┗━━━━━┛"

function Stack_S_Triangles ()
{
    [OutputType([String[]])]
    Param
    (
        # Param2 help description
        [Parameter(Mandatory=$true,   
                   Position=0)]
        [string[]]
        $Triangle
    )

    #
    # Helper Functions
    #

    function AppendTextLineByLine
    {
        [OutputType([String[]])]
        Param
        (
            # Target Text to be appended ONTO in [String[]] object
            [Parameter(Mandatory=$true,   
                       Position=0)]
            [string[]]
            $Target,

            # MergeText Text to be APPENDED  in [String[]] object
            [Parameter(Mandatory=$true, 
                       Position=1)]
            [string[]]
            $MergeText,

            # Target_StartIndex Start Index of Text on Target to be appended ONTO
            [Parameter(Mandatory=$true,  
                       Position=2)]
            [ValidateScript({$_ -is [int] -and ($_ -ge 0 -and $_ -lt ($Target.count))})]
            [int]
            $Target_StartIndex,

            # Target_EndIndex Endt Index of Text on Target to be appended ONTO
            [Parameter(Mandatory=$true, 
                       Position=3)]
            [ValidateScript({$_ -is [int] -and ($_ -ge 0 -and $_  -lt ($Target.count))})]
            [int]
            $Target_EndIndex,

            # MergeText_StartIndex Start Index of Text on MergeText to be appended ONTO
            [Parameter(Mandatory=$true, 
                       Position=2)]
            [ValidateScript({$_ -is [int] -and ($_ -ge 0 -and $_ -lt ($MergeText.count))})]
            [int]
            $MergeText_StartIndex,

            # MergeText_EndIndex End Index of Text on MergeText to be appended ONTO
            [Parameter(Mandatory=$true,  
                       Position=3)]
            [ValidateScript({$_ -is [int] -and ($_ -ge 0 -and $_  -lt ($MergeText.count))})]
            [int]
            $MergeText_EndIndex
        )

        ##### Check for parameters for errors

        # Check if range(#lines) for Target and MergeText match
        $Target_Range =  $Target_EndIndex - $Target_StartIndex + 1
        $MergeText_Range = $MergeText_EndIndex - $MergeText_StartIndex + 1
        $Target_Ranges_Equal_Or_Greater = $Target_Range -ge $MergeText_Range

        # Error if $False
        if (-not $Target_Ranges_Equal_Or_Greater)
        {
            Write-Error -Exception "Parameter Validation" -Message "Target Range is Less Than MergeText Range"
        }

        ###### Start Append Code
        for ($iter = 0; $iter -lt $MergeText_Range; $iter++)
        { 
            $Target_Index = $Target_StartIndex + $iter
            $MergeText_Index = $MergeText_StartIndex + $iter

            $New_Text = $Target[$Target_Index] + $MergeText[$MergeText_Index]
            $Target[$Target_Index] = $New_Text
        }
        Write-Output $Target
    }


    function Create_Filled_String_Array ($Num_of_Elements, $Num_of_Characters_per_Element, $Character)
    {
        $Character_Text = ""
        for ($i = 0; $i -lt $Num_of_Characters_per_Element; $i++)
        { 
            $Character_Text += $Character
        }

        $String_Array = @()
        for ($j = 0; $j -lt $Num_of_Elements; $j++)
        { 
            $String_Array += @("$Character_Text")
        }

        Write-Output $String_Array
    }

    function Replace_Range_w_String ($Target, $Replacement_Text, $Start_Index, $End_Index)
    {
        $Part1 = [string]($Target[0..($Start_Index-1)] -join '')
        $Part2 = $Replacement_Text
        $Part3 = [string]($Target[($End_Index+1)..($Target.Length-1)] -join '')
        $New_String = [string]($Part1+$Part2+$Part3)

        Write-Output $New_String
    }

    function Strip_Last_Char ($Target)
    {
        $New_String_Array = $Target | Foreach {$_[0..($_.length - 2)] -join ''}

        Write-Output $New_String_Array
    }

    function Print-Triangle ($Triangle)
    {
        $Triangle | % {Write-Verbose "--$($_)--"}
    }

    #
    #   Main Code
    #

    # Step 0 - Define Variables
    $Current_Triangle = $Triangle
    $Current_Triangle_Y = $Current_Triangle.count
    $Current_Triangle_X = $Current_Triangle[$Current_Triangle_Y-1].length

    # Step 1 - Copy $Current_Triangle to workspace $Current_Triangle 
    $New_Triangle = $Current_Triangle
    Print-Triangle -Triangle $New_Triangle

    # Step 2 - Add Space to End of Each Line
    $Space_String_Array = Create_Filled_String_Array -Num_of_Elements $Current_Triangle_Y -Num_of_Characters_per_Element 1 -Character ' '
    $New_Triangle = AppendTextLineByLine -Target $New_Triangle -MergeText $Space_String_Array -Target_StartIndex 0 -Target_EndIndex ($New_Triangle.count-1) -MergeText_StartIndex 0 -MergeText_EndIndex ($Space_String_Array.count-1)
    $Current_Triangle = Strip_Last_Char -Target $Triangle
    Print-Triangle -Triangle $New_Triangle

    # Step 3 - Append Current_Triange onto New_Triangle
    $New_Triangle = AppendTextLineByLine -Target $New_Triangle -MergeText $Current_Triangle -Target_StartIndex 0 -Target_EndIndex ($New_Triangle.count-1) -MergeText_StartIndex 0 -MergeText_EndIndex ($Current_Triangle.count-1)
    Print-Triangle -Triangle $New_Triangle

    # Step 4 - Calc X and Y
    $New_Triangle_Y = $New_Triangle.count
    $New_Triangle_X = $New_Triangle[$New_Triangle_Y-1].length
    
    # Step 5 - Calc, Create, and Append TopSubTrianglePadding
    $Elements_Needed = ($Current_Triangle_Y - 1)
    $Padding_Needed = [int](($New_Triangle_X - $Current_Triangle_X) / 2)
    $TopSubTrianglePadding = Create_Filled_String_Array -Num_of_Elements $Elements_Needed -Num_of_Characters_per_Element $Padding_Needed -Character ' '
    $Temp_Triangle = $New_Triangle
    $New_Triangle = @()
    $New_Triangle = $TopSubTrianglePadding + $Temp_Triangle
    Print-Triangle -Triangle $New_Triangle
    
    # Step 6 - Re-Calc X and Y
    $New_Triangle_Y = $New_Triangle.count
    $New_Triangle_X = $New_Triangle[$New_Triangle_Y-1].length

    # Step 7 - Append all but the last line of the Current_Triangle to the first elements of New_Triangle
    $New_Triangle = AppendTextLineByLine -Target $New_Triangle -MergeText $Current_Triangle -Target_StartIndex 0 -Target_EndIndex ($Elements_Needed -1) -MergeText_StartIndex 0 -MergeText_EndIndex ($Elements_Needed -1)
    $New_Triangle = AppendTextLineByLine -Target ([string[]]$New_Triangle) -MergeText $TopSubTrianglePadding -Target_StartIndex 0 -Target_EndIndex ($Elements_Needed-1) -MergeText_StartIndex 0 -MergeText_EndIndex ($Elements_Needed -1)
    Print-Triangle -Triangle $New_Triangle

    # Step 8 - Replace TopSubTriangle Bottom Row of New_Triangle with the modified Bottom Row of Current_Triangle 
    $Replacement_Junction = '╋'
    $Replacement_MiddlePart = ($Current_Triangle[($Current_Triangle.Count-1)][1..($Current_Triangle[($Current_Triangle.Count-1)].length-2)] -join '')
    $Replacement_Text = $Replacement_Junction + $Replacement_MiddlePart + $Replacement_Junction
    $Start_Index = $Padding_Needed
    $End_Index = ($Padding_Needed + $Current_Triangle_X) - 1
    $Target_Row = [int]([System.Math]::Round(($New_Triangle_Y/2),[System.MidpointRounding]::AwayFromZero)) - 1
    $New_Triangle[$Target_Row] = Replace_Range_w_String -Target $New_Triangle[$Target_Row] -Replacement_Text $Replacement_Text -Start_Index $Start_Index -End_Index $End_Index
    Print-Triangle -Triangle $New_Triangle

    # Step 9 - Replace TopSubTriangle Bottom Row of New_Triangle with the modified Bottom Row of Current_Triangle 
    $Replacement_Text = '┻━┻'
    $Start_Index = $Current_Triangle_X - 1
    $End_Index = $Start_Index + $Replacement_Text.Length -1
    $Target_Row = $New_Triangle_Y -1
    $New_Triangle[$Target_Row] = Replace_Range_w_String -Target $New_Triangle[$Target_Row] -Replacement_Text $Replacement_Text -Start_Index $Start_Index -End_Index $End_Index
    Print-Triangle -Triangle $New_Triangle
   
    Write-Output $New_Triangle
}

function S_Triangle
{
    [OutputType([String[]])]
    Param
    (
        # Param2 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true,  
                   Position=0)]
        [ValidateScript({$_ -is [int] -and ($_ -ge 1 -and $_ -le 8)})]
        [ValidateRange(1,8)]
        [int]
        $Rank
    )

    
    $BaseTriangle = [string[]]@()
    $BaseTriangle += "  ┏━┓  " 
    $BaseTriangle += "┏━┛ ┗━┓"
    $BaseTriangle += "┗━━━━━┛"

    if ($Rank -eq 1)
    {
        $New_Triangle = $BaseTriangle
    }
    elseif ($Rank -lt 1)
    {
        $New_Triangle = $null
        throw [System.Exception]
    }
    else
    {
        $Current_Triangle = S_Triangle -Rank ($Rank-1)
        $New_Triangle = Stack_S_Triangles -Triangle $Current_Triangle
    }

    Write-Output $New_Triangle
}

function Out-File-UTF8NoBOM
{
    [OutputType([void])]
    Param
    (
        # Triangle The S Triangle to output into a batch file
        [Parameter(Mandatory=$true,  
                   Position=1)]
        [string]
        $FilePath,

        # Triangle The S Triangle to output into a batch file
        [Parameter(Mandatory=$true,  
                   Position=0)]
        [string]
        $Output_Text,

        # Triangle The S Triangle to output into a batch file
        [Parameter(Mandatory=$false,  
                   Position=2)]
        [switch]
        $Force
    )

    if ([System.IO.File]::Exists($FilePath)) 
    {
        if ($Force) 
        {
            Get-Item -Path $FilePath | Remove-Item -Force
            $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllLines($FilePath, $Output_Text, $Utf8NoBomEncoding)
        }
    }
    else
    {
        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines($FilePath, $Output_Text, $Utf8NoBomEncoding)
    }
}

function Output_S_Triangle_to_Batch
{
    [OutputType([void])]
    Param
    (
        # Triangle The S Triangle to output into a batch file
        [Parameter(Mandatory=$true,  
                   Position=0)]
        [string[]]
        $Triangle,

        # FilePath The path of the file you'd like to output $Triangle to
        [Parameter(Mandatory=$true,  
                   Position=1)]
        [string]
        $FilePath,

        # Force Whether you'd like to overwrite an existing file
        [Parameter(Mandatory=$false,  
                   Position=2)]
        [switch]
        $Force
    )

    $Top_Batch = @'
echo off
chcp 65001 > nul
'@

    $Bottom_Batch = @'
chcp 437 > nul
pause
'@

    $Triangle_Text = ""
    $Triangle | % {$Triangle_Text += 'echo ' + $_ + "`r`n" }
    $Batch_Text = @()
    #$Batch_Text = $Top_Batch + "`r`n" + ($Triangle -join "`r`n") + "`r`n" + $Bottom_Batch
    $Batch_Text = $Top_Batch + "`r`n" + $Triangle_Text + $Bottom_Batch

    if ($Force) 
    {
        Out-File-UTF8NoBOM -FilePath $FilePath -Output_Text $Batch_Text -Force
    }
    else
    {
        Out-File-UTF8NoBOM -FilePath $FilePath -Output_Text $Batch_Text
    }
}

function Create_S_Triangle_Batch_Files ($Rank_Start, $Rank_End, $Destination_Folder)
{
    $Launcher_Text = ""
    ($Rank_Start)..($Rank_End) | % {
        $Triangle = S_Triangle -Rank $_
        Output_S_Triangle_to_Batch -Triangle $Triangle -FilePath (Join-Path -Path $Destination_Folder -ChildPath "S_Tri_Rank_$($_).bat") -Force
        $Launcher += "call S_Tri_Rank_$($_).bat`r`n"
    }
    Out-File-UTF8NoBOM -FilePath (Join-Path -Path $Destination_Folder -ChildPath "Show_Triangles.bat") -Output_Text $Launcher_Text -Force
}

####
####   Please modify for your use.  
####

Create_S_Triangle_Batch_Files -Rank_Start 1 -Rank_End 8 -Destination_Folder "C:\Share\Triangles"
