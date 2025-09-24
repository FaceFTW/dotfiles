# Webcam Daemon setup via ustreamer. Assumes Raspberry Pi environment
final: prev: with prev; {
  final.ustreamer = (
    pkgs.ustreamer.override {
      withSystemd = false;
      withJanus = false;
    }
  );
}
