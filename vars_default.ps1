# Edit variable values and then save this file as 'vars.ps1' to get it included into the publish procedure.

$env:Github_UserRepo   = ''   # Publish to Github; commit git changes
$env:Github_ApiKey     = ''   # Publish to Github token
$env:NuGet_ApiKey      = ''   # Publish to PSGallery token
$env:Chocolatey_ApiKey = ''   # Publish to Chocolatey token

$env:gitlab_user            = ''   # GitLab username to use for the push
$env:gitlab_api_key         = ''   # GitLab API key associated with gitlab_user
$env:gitlab_push_url        = ''   # GitLab URL to push to. Must be HTTP or HTTPS. e.g. https://jekotia:MyPassword@git.example.org/jekotia/au.git
$env:gitlab_commit_strategy = ''   # Same values as the Git plugin; single, atomic, or atomictag
