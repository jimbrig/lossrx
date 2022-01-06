If (!(Get-Command npm)) {
  throw ("no npm installation detected, please install node and npm")
}

refreshenv

If (!(Get-Command dbml)) {
  Write-Host "No dbml npm installation found; installing dbml globally.." -ForegroundColor Yellow
  npm install -g dbml
  Write-Host "Done."
}

Function Build-DbDocs {
  $build_path =  Resolve-Path (Join-Path $PSScriptRoot ".." "database.dbml")
  dbdocs build $build_path
}
