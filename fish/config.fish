if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end;
fundle plugin 'edc/bass'
fundle plugin 'franciscolourenco/done'
fundle plugin 'fishpkg/fish-humanize-duration'
fundle init
bass source ~/.nix-profile/etc/profile.d/nix{,-daemon}.sh
