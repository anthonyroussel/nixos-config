{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    #
    # Unstable dev tools
    #
    # Cloud tools
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.awscli2
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.awsebcli
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.google-cloud-sdk
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.kubectl

    # Dev tools
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.chezmoi
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.doctl
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.gh
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.hugo

    # Node.js
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.nodejs-18_x
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.nodePackages.yarn

    # Password management
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.gopass
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.gopass-jsonapi

    # Python
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.python3
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.python3Packages.pip
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.pipenv

    # Infra as Code (IaC)
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.terraform
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.terraform-ls
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.pulumi-bin
  ];
}
