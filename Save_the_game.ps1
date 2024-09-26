# Define os caminhos (certifique-se de ajustá-los)
$diretorio = "C:\Users\Jorge L\Desktop\Saves\SNES"
$repositorio = "C:\Users\Jorge L\Desktop\Git\Saves"
$processo = "snes9x-x64"
Start-Process "C:\Users\Jorge L\Emu\Snes\snes9x-x64" -ArgumentList "C:\Users\Jorge L\Emu\Snes\Roms"
# Função para verificar se o processo está em execução
function IsProcessRunning ($processName) {
    Get-Process -Name $processName | Select-Object -First 1
}

# Função para realizar o commit
function CommitChanges ($repoPath) {
    cd $repoPath
	git remote add origin git@github.com:lucasrocha96/SaveTheGame.git
	git branch -M main
	git push -u origin main
    git add .
    git commit -m "Commit automático após fechar SNES9X em $(Get-Date -Format s) - Jogo: Super Mario World" # Substitua por um nome de jogo dinâmico se necessário
}

# Loop infinito para monitorar o diretório e o processo
while ($true) {
    # Verifica se o processo SNES9X está em execução
    if (!(IsProcessRunning $processo)) {
        # Obtém as informações dos arquivos uma vez
        $arquivos = Get-ChildItem $diretorio -Recurse | Select-Object -LastWriteTime

        # Verifica se houve alterações
        if ($arquivos | Compare-Object -ReferenceObject $arquivos -Property LastWriteTime) {
            try {
                CommitChanges $repositorio
                Write-Host "Commit realizado com sucesso!"
            } catch {
                Write-Warning "Erro ao realizar o commit: $($_.Exception.Message)"
            }
        }
    }
    Start-Sleep -Seconds 10
}
