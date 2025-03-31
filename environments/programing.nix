{ config, pkgs, lib, ... } :
{
   environment.systemPackages = with pkgs; [
  # Programming Tools
    git
    picocom
  #   #clangStdenv # probably best to use shell.nix or flake.nix
  #   cmake
  #   clang
  #     boost
  #     eigen
  #     grpc
  #     jsoncpp
  #     protobuf
  #     openssl
  #     libtorch-bin
  #     libsvm
  #   rustup
  #   python3
  #   nodejs
  #   go
  #   jdk
  #   podman-compose
  ];
}
