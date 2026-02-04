{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    androidenv.androidPkgs.androidsdk
    androidenv.androidPkgs.emulator
    androidenv.androidPkgs.ndk-bundle
    jdk # Java
  ];
}
