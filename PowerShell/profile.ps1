# Install-Module -Name Terminal-Icons -Repository PSGallery
Import-Module Terminal-Icons

# Modificare il NOME-TEMA con quello che preferisci (trovi  la lista completa qui https://ohmyposh.dev/docs/themes)
oh-my-posh init pwsh --config "$HOME/.poshthemes/catppuccin_mocha.omp.json" | Invoke-Expression

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# Cronologia completamento comandi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Funzioni di utility
function .. {
    cd ..
}   

function .... {
    cd ../../
}

function ...... {
    cd ../../../
}
