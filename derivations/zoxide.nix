{
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin rec {
  pname = "zoxide";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "icezyclon";
    repo = "zoxide.fish";
    rev = version;
    hash = "sha256-OjrX0d8VjDMxiI5JlJPyu/scTs/fS/f5ehVyhAA/KDM=";
  };
}
